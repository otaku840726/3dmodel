#!/usr/bin/env python3
"""
Magnetic Tilt Camera Mount for a printer door (glass panel) - TP-Link Tapo C100 / C110.

Assembly coordinate frame (all parts are MODELLED installed, then moved to their print pose by a RIGID
rotation only - never a mirror, so left/right features such as the DC jack stay on the correct side):
  * z = 0 : OUTER surface of the door glass, +z points out of the printer (toward the user)
  * y     : up,  x : right (seen from outside, i.e. looking at the back of the camera)

Print rules applied to every part (checked by scripts/check_and_render.py):
  * no surface steeper than 45 deg from vertical except on the bed  -> no supports, no flat bridges
  * every mating pair has an explicit clearance from TOL (below)
  * edges of mating faces that sit on the bed get an elephant-foot chamfer

Requires: pip install manifold3d trimesh numpy
"""
import argparse, json, math, os
import numpy as np
import trimesh
from manifold3d import Manifold as M, CrossSection as CS, JoinType, OpType, set_circular_segments

set_circular_segments(96)

# ----------------------------------------------------------------------------- FDM tolerances (mm)
# Values are for a 0.4 mm nozzle, 0.2 mm layers, PETG/PLA, with the slicer's XY compensation at 0.
TOL = dict(
    cam=0.25,            # camera in the cradle, per side (sliding fit)
    cap_slide=0.25,      # magnet cap in its socket, radial (rotating/sliding fit)
    lug_radial=0.30,     # bayonet lug to groove wall, radial
    lug_axial=0.25,      # bayonet lug to groove floor/roof, vertical (>= 1 layer)
    mag=0.20,            # magnet hole, radial (holes print ~0.1 mm small: magnet drops in, no hammering)
    mag_cluster=0.15,    # 7-magnet cluster pockets, radial (light press, keeps same-pole magnets in place)
    hinge_gap=0.25,      # cradle knuckle to each ear (ears flex this much when the knob is tightened)
    bore=0.50,           # bolt major diameter in the knuckle / ear bores, radial
    thread_bolt=-0.15,   # printed thread, bolt radial offset (printed lying: slightly oval)
    thread_nut=+0.20,    # printed thread, knob radial offset (vertical hole prints small)
    head=0.25,           # bolt head in its ear pocket, per side
    efoot=0.40,          # 45 deg chamfer on bed edges of mating faces (elephant foot)
)

# ----------------------------------------------------------------------------- parameters
P = dict(
    # camera head: Tapo C100/C110, measured from the reference sleeve (cavity 60.2 x 60.2, ~26 deep)
    cam_w=60.0, cam_h=60.0, cam_d=26.0, cam_r=6.0,   # cavity corner radius (<= camera corner radius)
    cradle_wall=2.0, lip=3.0, lip_t=2.0, rear_chamfer=0.6,
    stem_slot_w=9.0,         # bottom-centre slot for the camera's stem (+ ball)
    # Tapo DC 5.5x2.1 jack: bottom of the head, RIGHT of centre seen from outside (reference sleeve)
    power_x=15.1, power_from_lip=15.6, power_d=12.0,
    # microSD / reset window: LEFT side seen from outside (reference sleeve), 45-deg pointed toward the glass
    sd_y=(-12.0, 15.5), sd_from_lip=(1.5, 24.0),
    # magnet system
    mag_d_max=20.0, mag_t_max=5.0,
    cap_wall=1.0,
    slot_w=2.0, slot_v=0.7,  # coin slot: 2.0 wide, vertical walls 0.7 deep, then a 45-deg tent (no bridge)
    cap_skin=0.6,            # plastic left under the deepest point of the coin slot
    floor=0.8,               # plastic between magnet and glass
    groove_w=1.3, lug_h=1.4, lug_deg=29.0, chan_deg=36.0, twist_deg=40.0,
    roof_lip=1.7,            # socket material above the 45-deg groove roof at the bore wall
    # plates: every magnet sits ABOVE the camera, so neither plate is ever in the field of view
    outer_base=3.5, inner_base=3.0,
    sockets=[(38.0, 36.0), (-38.0, 36.0), (18.0, 66.0), (-18.0, 66.0)],
    # hinge
    hinge_dy=10.5,           # axis above the cradle's top outer surface
    hinge_r=9.5, ear_t=6.0, knuckle_hw=12.85,
    bolt_d=10.0, bolt_p=2.0,                 # 90-deg (45-deg flank) printed thread
    thread_crest=0.25, thread_root=0.25,
    bolt_flat=3.6,           # D-flats at +-3.6 (0.72 r): bolt prints lying on a flat
    head_len=16.0, head_t=3.0,               # rectangular head (7.2 x 16 x 3), keyed in an open-top pocket
    knob_r=8.5, knob_t=9.0, knob_clear=1.0,  # knob clears the caps by 1 mm
    glass_t=4.0,             # only used for the assembly render
)

# ----------------------------------------------------------------------------- 2D / 3D helpers
def rrect(w, h, r, cx=0.0, cy=0.0):
    r = min(r, w / 2 - 1e-3, h / 2 - 1e-3)
    return CS.square((w - 2 * r, h - 2 * r), True).offset(r, JoinType.Round).translate((cx, cy))

def poly(pts):
    pts = list(pts)
    a = 0.5 * sum(pts[i][0] * pts[i - 1][1] - pts[i - 1][0] * pts[i][1] for i in range(len(pts)))
    if a > 0:
        pts = pts[::-1]
    return CS([pts])

def sector(r, a0, a1, r_in=0.0, n=48):
    a = np.radians(np.linspace(a0, a1, n))
    outer = [(r * math.cos(t), r * math.sin(t)) for t in a]
    inner = [(r_in * math.cos(t), r_in * math.sin(t)) for t in a[::-1]] if r_in > 0 else [(0.0, 0.0)]
    return poly(outer + inner)

def ext(cs, z0, z1):
    return M.extrude(cs, z1 - z0).translate((0, 0, z0))

def prism_x(cs_yz, x0, x1):
    """cs_yz drawn in (y,z); extruded along +x from x0 to x1."""
    sk = cs_yz.transform(np.array([[0.0, -1.0, 0.0], [1.0, 0.0, 0.0]]))  # (u,v) = (-z, y)
    return M.extrude(sk, x1 - x0).rotate((0, 90, 0)).translate((x0, 0, 0))

def prism_y(cs_xz, y0, y1):
    """cs_xz drawn in (x,z); extruded along +y from y0 to y1."""
    sk = cs_xz.transform(np.array([[1.0, 0.0, 0.0], [0.0, -1.0, 0.0]]))  # (x, -z)
    return M.extrude(sk, y1 - y0).rotate((-90, 0, 0)).translate((0, y0, 0))

def revolve_sector(rz_pts, a0, a1):
    """Revolve an (r,z) polygon about the z axis from angle a0 to a1 (deg, CCW from +x)."""
    rev = M.revolve(poly(rz_pts), circular_segments=max(8, int(abs(a1 - a0) / 3)), revolve_degrees=a1 - a0)
    return rev.rotate((0, 0, a0))

def teardrop(r, cy, cz, up=+1):
    """Circle in (a,b) with a 45-deg point toward +b (up=+1) or -b (up=-1)."""
    c = CS.circle(r).translate((cy, cz))
    s = r / math.sqrt(2)
    tri = poly([(cy - s, cz + up * s), (cy + s, cz + up * s), (cy, cz + up * r * math.sqrt(2))])
    return CS.hull(c + tri)

def chamfer_bottom(m, shape, z0, c):
    """45-deg chamfer c on the bottom edge (z=z0) of a prism whose (convex) outline is `shape`."""
    keep = M.hull(ext(shape.offset(-c), z0, z0 + 1e-3) + ext(shape, z0 + c, z0 + c + 1e-3))
    cutter = ext(shape.offset(c + 2), z0 - 1, z0 + c) - keep
    return m - cutter

def chamfer_top(m, shape, z1, c):
    keep = M.hull(ext(shape.offset(-c), z1 - 1e-3, z1) + ext(shape, z1 - c - 1e-3, z1 - c))
    cutter = ext(shape.offset(c + 2), z1 - c, z1 + 1) - keep
    return m - cutter

def to_trimesh(m):
    mesh = m.to_mesh()
    return trimesh.Trimesh(vertices=np.asarray(mesh.vert_properties)[:, :3], faces=np.asarray(mesh.tri_verts), process=False)

def save(m, path):
    """Export a watertight STL. STL stores float32 and slicers merge equal vertices, so: round to float32,
    collapse edges shorter than 0.1 um (merge endpoints, drop the 2 degenerate triangles), then verify that the
    file re-loads watertight and that the volume is unchanged."""
    tm = to_trimesh(m.simplify(1e-3))
    assert tm.is_watertight, path
    vol = tm.volume
    tm = trimesh.Trimesh(tm.vertices.astype(np.float32).astype(np.float64), tm.faces, process=False)
    tm.merge_vertices(digits_vertex=4)
    f = tm.faces
    tm.update_faces((f[:, 0] != f[:, 1]) & (f[:, 1] != f[:, 2]) & (f[:, 0] != f[:, 2]))
    tm.remove_unreferenced_vertices()
    assert abs(tm.volume - vol) < 1e-4 * vol + 1e-3, f'{path}: volume changed by the clean-up'
    tm.export(path)
    back = trimesh.load(path)
    assert back.is_watertight and back.is_winding_consistent, f'{path} not watertight after STL export'
    return back

# ----------------------------------------------------------------------------- printed thread (90 deg)
def thread_section(p, grow=0.0, n=60):
    """Section of a single-start thread with 45-deg flanks (90-deg included angle) perpendicular to its axis.
    45-deg flanks print without overhang both vertically (knob) and lying down (bolt)."""
    P_, c, r_ = p['bolt_p'], p['thread_crest'], p['thread_root']
    flank = (P_ - c - r_) / 2               # axial length of one flank = radial depth (45 deg)
    r_maj = p['bolt_d'] / 2 + grow
    r_min = r_maj - flank
    pts = []
    for i in range(n):
        phi = 2 * math.pi * i / n
        u = (i / n) * P_                    # axial position within one pitch, crest centred at u=0
        dd = min(u, P_ - u)
        if dd <= c / 2:
            r = r_maj
        elif dd >= c / 2 + flank:
            r = r_min
        else:
            r = r_maj - (dd - c / 2)
        pts.append((r * math.cos(phi), r * math.sin(phi)))
    return poly(pts)

def threaded_rod(p, length, grow=0.0, n=60):
    """+twist = CCW with height = right-hand thread. The twist per slice equals the section's vertex spacing
    (360/n), so every triangle follows the helix: no skewed facets, every flank face stays at exactly 45 deg."""
    turns = length / p['bolt_p']
    return M.extrude(thread_section(p, grow, n=n), length, n_divisions=int(round(turns * n)) - 1, twist_degrees=360.0 * turns)

# ----------------------------------------------------------------------------- derived values
def derived(p):
    d = {}
    d['cav_w'] = p['cam_w'] + 2 * TOL['cam']
    d['cav_h'] = p['cam_h'] + 2 * TOL['cam']
    d['out_w'] = d['cav_w'] + 2 * p['cradle_wall']
    d['out_h'] = d['cav_h'] + 2 * p['cradle_wall']
    d['ytop'] = d['out_h'] / 2
    d['slot_depth'] = p['slot_v'] + p['slot_w'] / 2
    d['cap_rc'] = p['mag_d_max'] / 2 + TOL['mag'] + p['cap_wall']           # cap body radius
    d['cap_h'] = p['mag_t_max'] + 0.3 + d['slot_depth'] + p['cap_skin']      # = socket depth
    d['boss_h'] = p['floor'] + d['cap_h']                                     # plate thickness at a socket
    d['sock_r'] = d['cap_rc'] + TOL['cap_slide']
    d['groove_r'] = d['sock_r'] + p['groove_w']
    d['lug_r'] = d['groove_r'] - TOL['lug_radial']
    d['boss_r'] = d['groove_r'] + 2.0
    # groove (socket frame, z from the glass face): 45-deg roof from (groove_r, zg1) up to (sock_r, top-roof_lip)
    top = d['boss_h']
    d['zg1'] = top - p['roof_lip'] - p['groove_w']
    d['zg0'] = d['zg1'] - p['lug_h'] - 2 * TOL['lug_axial']
    d['z_glass_end'] = d['boss_h'] + 0.8                                       # cradle face nearest the glass
    d['cav_d'] = p['cam_d'] + 0.6
    d['z_rear'] = d['z_glass_end'] + d['cav_d'] + p['lip_t']
    d['y_h'] = d['ytop'] + p['hinge_dy']
    d['z_h'] = d['boss_h'] + p['knob_clear'] + p['knob_r']                    # knob clears the caps
    d['ear_x0'] = p['knuckle_hw'] + TOL['hinge_gap']
    d['ear_x1'] = d['ear_x0'] + p['ear_t']
    d['bore_r'] = p['bolt_d'] / 2 + TOL['bore']
    return d

# ----------------------------------------------------------------------------- magnet socket / cap
def socket_cut(p, d, top):
    """Cavity subtracted from a plate whose socket opening is at z=top (plate printed glass face down)."""
    rs, rg = d['sock_r'], d['groove_r']
    cut = ext(CS.circle(rs), p['floor'], top + 1)
    zg0, zg1 = d['zg0'], d['zg1']
    groove_rz = [(rs - 0.5, zg0), (rg, zg0), (rg, zg1), (rs - 0.5, zg1 + rg - rs + 0.5)]  # 45-deg roof
    for i in range(3):
        a = 90 + 120 * i
        cut += ext(sector(rg, a - p['chan_deg'] / 2, a + p['chan_deg'] / 2), zg0, top + 1)           # entry channel
        cut += revolve_sector(groove_rz, a - p['chan_deg'] / 2 - p['twist_deg'], a)  # lock: CW from the opening (ends inside the channel)
    # 45-deg lead-in at the socket mouth
    c = 0.5
    cut += M.extrude(CS.circle(rs), c + 1e-3, scale_top=((rs + c) / rs,) * 2).translate((0, 0, top - c))
    return cut

def cap_body(p, d):
    """Installed orientation: rim at z=0 (on the socket floor), top at cap_h (flush with the plate)."""
    hc, rc = d['cap_h'], d['cap_rc']
    body = ext(CS.circle(rc), 0, hc)
    # lugs: flat bottom, 45-deg top (matches the groove roof) - prints without overhang roof-down
    zl0 = d['zg0'] - p['floor'] + TOL['lug_axial']
    zl1 = zl0 + p['lug_h']
    lr = d['lug_r']
    lug_rz = [(rc - 0.5, zl0), (lr, zl0), (lr, zl1), (rc - 0.5, zl1 + lr - rc + 0.5)]
    for i in range(3):
        a = 90 + 120 * i
        body += revolve_sector(lug_rz, a - p['lug_deg'] / 2, a + p['lug_deg'] / 2)
    # coin slot across the top (along the lug at 90 deg = lock indicator): vertical walls then a 45-deg tent
    w, v = p['slot_w'], p['slot_v']
    tent = poly([(-w / 2, hc + 1), (w / 2, hc + 1), (w / 2, hc - v), (0, hc - v - w / 2), (-w / 2, hc - v)])
    body -= prism_y(tent, -rc - 2, rc + 2)
    # 45-deg lead-in at the rim (print top) and elephant-foot chamfer at the top edge (on the bed when printed)
    body = chamfer_bottom(body, CS.circle(rc), 0.0, 0.6)
    body = chamfer_top(body, CS.circle(rc), hc, TOL['efoot'])
    return body

def magnet_cap(p, d, mag_d, mag_t):
    body = cap_body(p, d)
    return body - ext(CS.circle(mag_d / 2 + TOL['mag']), -1, mag_t + 0.3)

def magnet_cap_cluster(p, d, mag_d, mag_t):
    """7 small magnets (centre + hex ring) in separate pockets - for tiny magnets such as 5x3.
    All 7 magnets must face the same way."""
    body = cap_body(p, d)
    f = TOL['mag_cluster']
    pitch = mag_d + 2 * f + 0.85                    # 0.85 mm walls between pockets
    assert pitch + mag_d / 2 + f + 1.0 < d['cap_rc'], 'cluster does not fit in the cap'
    centres = [(0.0, 0.0)] + [(pitch * math.cos(math.radians(30 + 60 * k)), pitch * math.sin(math.radians(30 + 60 * k))) for k in range(6)]
    for c in centres:
        body -= ext(CS.circle(mag_d / 2 + f, 48).translate(c), -1, mag_t + 0.3)
    return body

def cap_print_pose(m, d):
    """Roof (coin-slot face) on the bed, magnet holes open upward: no bridge anywhere."""
    return m.rotate((180, 0, 0)).translate((0, 0, d['cap_h']))

# ----------------------------------------------------------------------------- plates
def plate_outline(p, d):
    r = d['boss_r'] + 0.6          # outline 0.6 mm outside the bosses (no coincident walls)
    return CS.hull(CS.batch_boolean([CS.circle(r).translate(xy) for xy in p['sockets']], OpType.Add)
                   + CS.square((2 * d['ear_x1'], 1.0), True).translate((0, d['y_h'] - p['hinge_r'] + 0.5)))

def plate(p, d, base_t):
    shape = plate_outline(p, d)
    body = ext(shape, 0, base_t)
    for (x, y) in p['sockets']:
        body += ext(CS.circle(d['boss_r']).translate((x, y)), base_t - 1.0, d['boss_h'])
    for (x, y) in p['sockets']:
        body -= socket_cut(p, d, d['boss_h']).translate((x, y, 0))
    return chamfer_bottom(body, shape, 0.0, TOL['efoot'])

def outer_plate(p, d):
    body = plate(p, d, p['outer_base'])
    y_h, z_h, R = d['y_h'], d['z_h'], p['hinge_r']
    ear_prof = CS.hull(CS.circle(R).translate((y_h, z_h)) + CS.square((2 * R, p['outer_base']), False).translate((y_h - R, 0)))
    bore = teardrop(d['bore_r'], y_h, z_h, up=+1)                   # point up (+z) = print up
    for s in (+1, -1):
        x0, x1 = (d['ear_x0'], d['ear_x1']) if s > 0 else (-d['ear_x1'], -d['ear_x0'])
        body += prism_x(ear_prof, x0, x1) - prism_x(bore, x0 - 1, x1 + 1)
    # bolt head pocket on the -x ear: open to the top -> no roof at all; floor faces up
    hw = p['bolt_flat'] + TOL['head']
    z_bot = z_h - p['head_len'] / 2 - TOL['head']
    pocket = CS.square((2 * hw, z_h + R + 2 - z_bot), False).translate((y_h - hw, z_bot))
    body -= prism_x(pocket, -d['ear_x1'] - 1, -d['ear_x1'] + p['head_t'] + TOL['head'])
    return body

def inner_plate(p, d):
    return plate(p, d, p['inner_base'])

# ----------------------------------------------------------------------------- cradle
def cradle(p, d):
    zg, zr = d['z_glass_end'], d['z_rear']
    cav = rrect(d['cav_w'], d['cav_h'], p['cam_r'])
    outer = rrect(d['out_w'], d['out_h'], p['cam_r'] + p['cradle_wall'])
    body = chamfer_top(ext(outer, zg, zr), outer, zr, p['rear_chamfer'])   # rear (bed) edge: no elephant foot
    # hinge knuckle + 45-deg gusset (prints without support, rear lip on the bed)
    y_h, z_h, R, yt = d['y_h'], d['z_h'], p['hinge_r'], d['ytop']
    y_foot = max(yt, y_h + R * math.sqrt(2) - (zr - z_h))
    kn = CS.hull(CS.circle(R).translate((y_h, z_h)) + poly([(yt - 1.5, zg), (yt, zg), (y_foot, zr), (yt - 1.5, zr)]))
    body += prism_x(kn, -p['knuckle_hw'], p['knuckle_hw'])
    body -= prism_x(teardrop(d['bore_r'], y_h, z_h, up=-1), -p['knuckle_hw'] - 1, p['knuckle_hw'] + 1)  # point to print-up
    # camera cavity + rear window (lip)
    body -= ext(cav, zg - 1, zg + d['cav_d'])
    body -= ext(rrect(d['cav_w'] - 2 * p['lip'], d['cav_h'] - 2 * p['lip'], max(p['cam_r'] - p['lip'], 2)), zg, zr + 1)
    z_lip = zg + d['cav_d']                                        # inner face of the rear lip
    # stem slot, bottom centre, open at the glass end (= print top)
    hw = p['stem_slot_w'] / 2
    slot = CS.hull(CS.circle(hw).translate((0, z_lip - hw)) + CS.square((2 * hw, 1), False).translate((-hw, zg - 1)))
    body -= prism_y(slot, -d['out_h'] / 2 - 1, -d['cav_h'] / 2 + 0.5)
    # DC power jack, bottom wall, RIGHT of centre seen from outside (x > 0); teardrop point to print-up
    pw = teardrop(p['power_d'] / 2, p['power_x'], z_lip - p['power_from_lip'], up=-1)
    body -= prism_y(pw, -d['out_h'] / 2 - 1, -d['cav_h'] / 2 + 0.5)
    # LEFT side (x < 0): microSD / reset window, full width at the lip side, 45-deg point toward the glass end
    y0, y1 = p['sd_y']
    z0, z1 = z_lip - p['sd_from_lip'][1], z_lip - p['sd_from_lip'][0]
    h = (y1 - y0) / 2
    assert z1 - z0 > h, 'sd window too short for a 45-deg point'
    sd = poly([(y0, z1), (y1, z1), (y1, z0 + h), ((y0 + y1) / 2, z0), (y0, z0 + h)])
    body -= prism_x(sd, -d['out_w'] / 2 - 1, -d['cav_w'] / 2 + 0.5)
    # RIGHT side: ventilation window, 45-deg point toward the glass end
    zc = zg + d['cav_d'] / 2
    wl, wh = min(16.0, d['cav_d'] - 9), 18.0
    z0, z1 = zc - wl / 2, zc + wl / 2
    win = poly([(-wh / 2, z1), (wh / 2, z1), (wh / 2, z0 + wh / 2), (0, z0), (-wh / 2, z0 + wh / 2)])
    body -= prism_x(win, d['cav_w'] / 2 - 0.5, d['out_w'] / 2 + 1)
    return body

def cradle_print_pose(m, d):
    """Rear lip on the bed: ROTATE 180 deg about x (rigid - a mirror would swap left/right features)."""
    return m.rotate((180, 0, 0)).translate((0, 0, d['z_rear']))

# ----------------------------------------------------------------------------- hinge hardware
def hinge_bolt(p, d):
    """Bolt along +z, head at z=0. D-flats at y=+-bolt_flat so it prints lying on a flat (layers along the bolt).
    The head is a 7.2 x 16 x 3 block (same 7.2 height as the flats) keyed in an open-top pocket in the -x ear."""
    length = 2 * d['ear_x1'] + p['knob_t'] - 0.5 - p['head_t']   # head flush in the -x ear, tip 0.5 inside the knob
    hf = p['bolt_flat']
    head = M.cube((p['head_len'], 2 * hf, p['head_t']), True).translate((0, 0, p['head_t'] / 2))
    dog = 1.5                                                     # unthreaded 45-deg lead-in point
    rod = threaded_rod(p, length - dog, grow=TOL['thread_bolt']).translate((0, 0, p['head_t']))
    r_core = p['bolt_d'] / 2 + TOL['thread_bolt'] - (p['bolt_p'] - p['thread_crest'] - p['thread_root']) / 2 - 0.05
    z_end = p['head_t'] + length - dog
    point = M.cylinder(dog + 0.3, r_core, r_core - (dog + 0.3)).translate((0, 0, z_end - 0.3))  # starts inside the rod
    slab = M.cube((40, 2 * hf, length + p['head_t'] + 2), True).translate((0, 0, (length + p['head_t']) / 2))
    return (head + rod + point) ^ slab, length + p['head_t']

def bolt_print_pose(bolt, p):
    """Lay the bolt on its -y flat: axis along y, flat face on z=0."""
    return bolt.rotate((-90, 0, 0)).translate((0, 0, p['bolt_flat']))

def hinge_knob(p, d):
    t, R = p['knob_t'], p['knob_r']
    prof = CS.circle(R)
    for k in range(10):
        a = 2 * math.pi * k / 10
        prof -= CS.circle(1.6).translate(((R + 0.95) * math.cos(a), (R + 0.95) * math.sin(a)))
    knob = ext(prof, 0, t)
    knob -= ext(CS.circle(R + 3), t - 0.8, t + 1) - M.extrude(CS.circle(R - 0.1), 0.8, scale_top=((R - 0.9) / (R - 0.1),) * 2).translate((0, 0, t - 0.8))
    # start offset is deliberately 'odd' so no thread slice plane coincides with the countersink / chamfer cones
    knob -= threaded_rod(p, t + 2.1, grow=TOL['thread_nut']).translate((0, 0, -1.0137))
    # entry countersink on the bed face (removes the elephant foot from the thread). 39 deg, NOT 45 deg:
    # a 45-deg cone would run parallel to the 45-deg thread flank and graze it.
    r = p['bolt_d'] / 2 + TOL['thread_nut']
    r_min = r - (p['bolt_p'] - p['thread_crest'] - p['thread_root']) / 2
    r_end = r_min - 0.05                         # cone ends inside the empty hole -> no flat ring left behind
    knob -= M.cylinder((r + 0.6 - r_end) / 0.8, r + 0.6, r_end).translate((0, 0, -0.001))
    return knob

# ----------------------------------------------------------------------------- fit-test coupon
def fit_coupon(p, d):
    """One socket boss + one 12x3 cap, ~10 min print: check the bayonet / magnet fit before the plates."""
    shape = CS.circle(d['boss_r'] + 0.6)
    boss = chamfer_bottom(ext(shape, 0, d['boss_h']) - socket_cut(p, d, d['boss_h']), shape, 0.0, TOL['efoot'])
    cap = cap_print_pose(magnet_cap(p, d, 12, 3), d).translate((2 * d['boss_r'] + 6, 0, 0))
    return boss + cap

# ----------------------------------------------------------------------------- assembly helpers
def rot_about_hinge(m, d, deg):
    """deg > 0 : camera looks DOWN (bottom of the cradle swings away from the glass)."""
    return m.translate((0, -d['y_h'], -d['z_h'])).rotate((-deg, 0, 0)).translate((0, d['y_h'], d['z_h']))

def place_bolt(bolt, d, p):
    return bolt.rotate((0, 90, 0)).translate((-d['ear_x1'], d['y_h'], d['z_h']))

def place_knob(knob, d):
    return knob.rotate((0, 90, 0)).translate((d['ear_x1'], d['y_h'], d['z_h']))

def place_inner(inner, p):
    # inner plate printed glass face down; installed by turning it over (rigid 180 deg about y)
    return inner.rotate((0, 180, 0)).translate((0, 0, -p['glass_t']))

def place_cap_outer(cap, xy, d, p, locked=True):
    return cap.rotate((0, 0, -p['twist_deg'] if locked else 0)).translate((xy[0], xy[1], p['floor']))

# ----------------------------------------------------------------------------- main
def build(p=None):
    p = dict(P) if p is None else p
    d = derived(p)
    parts = dict(outer_plate=outer_plate(p, d), inner_plate=inner_plate(p, d), cradle=cradle(p, d))
    parts['hinge_bolt'], d['bolt_len'] = hinge_bolt(p, d)
    parts['hinge_knob'] = hinge_knob(p, d)
    return p, d, parts

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', default=os.path.join(os.path.dirname(__file__), '..'))
    ap.add_argument('--cam-w', type=float); ap.add_argument('--cam-h', type=float); ap.add_argument('--cam-d', type=float)
    a = ap.parse_args()
    p = dict(P)
    for k in ('cam_w', 'cam_h', 'cam_d'):
        if getattr(a, k) is not None:
            p[k] = getattr(a, k)
    p, d, parts = build(p)
    out = os.path.abspath(a.out)
    os.makedirs(os.path.join(out, 'caps'), exist_ok=True)

    printable = {
        'outer_plate': parts['outer_plate'],                       # glass face down
        'inner_plate': parts['inner_plate'],                       # glass face down
        'cradle': cradle_print_pose(parts['cradle'], d),           # rear lip down (rigid rotation)
        'hinge_bolt': bolt_print_pose(parts['hinge_bolt'], p),     # lying on a flat
        'hinge_knob': parts['hinge_knob'],                         # flat
        'test_fit_coupon': fit_coupon(p, d),
    }
    info = {}
    for k, m in printable.items():
        tm = save(m, os.path.join(out, f'{k}.stl'))
        info[k] = dict(size=[round(v, 2) for v in tm.extents], volume_cm3=round(tm.volume / 1000, 2))

    for f in os.listdir(os.path.join(out, 'caps')):
        if f.endswith('.stl'):
            os.remove(os.path.join(out, 'caps', f))
    step = 2 * d['lug_r'] + 3
    def plate_of_8(c):
        g = M()
        for i in range(8):
            g += c.translate(((i % 4) * step, (i // 4) * step, 0))
        return g
    for md in [5, 6, 8, 10, 12, 15, 18, 20]:
        for mt in [2, 3, 4, 5]:
            c = cap_print_pose(magnet_cap(p, d, md, mt), d)
            save(c, os.path.join(out, 'caps', f'cap_D{md}x{mt}.stl'))
            if (md, mt) == (12, 3):
                save(plate_of_8(c), os.path.join(out, 'caps', 'cap_D12x3_set_of_8.stl'))
    for (md, mt) in ((5, 2), (5, 3)):
        c = cap_print_pose(magnet_cap_cluster(p, d, md, mt), d)
        save(c, os.path.join(out, 'caps', f'cap_D{md}x{mt}_x7.stl'))
        if (md, mt) == (5, 3):
            save(plate_of_8(c), os.path.join(out, 'caps', 'cap_D5x3_x7_set_of_8.stl'))

    info['derived'] = {k: round(v, 3) for k, v in d.items()}
    info['tolerances'] = TOL
    with open(os.path.join(out, 'scripts', 'last_build.json'), 'w') as f:
        json.dump(info, f, indent=2)
    print(json.dumps({k: v for k, v in info.items() if k not in ('derived',)}, indent=1))

if __name__ == '__main__':
    main()
