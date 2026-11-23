#!/usr/bin/env python3
"""
Magnetic Tilt Camera Mount (printer door / glass panel) - parametric generator.

Assembly coordinate frame (used for every part unless noted):
  * z = 0  : OUTER surface of the door glass, +z points out of the printer (toward the user)
  * y      : up,  x : right (seen from outside)
Parts
  outer_plate  : sits on the outside of the glass, 4 magnet sockets + hinge ears
  inner_plate  : sits on the inside of the glass, 4 magnet sockets (mirror partner)
  cradle       : camera sleeve, lens side faces the glass, hinged at its top-glass edge
  hinge_bolt   : printed M10x1.5 bolt with captive hex head
  hinge_knob   : printed thumb knob (internal thread)
  caps/cap_D{d}x{t}.stl : bayonet magnet cartridges, one per magnet size

Requires: pip install manifold3d trimesh numpy
"""
import argparse, json, math, os
import numpy as np
import trimesh
from manifold3d import Manifold as M, CrossSection as CS, JoinType, OpType, set_circular_segments

set_circular_segments(96)

# ----------------------------------------------------------------------------- parameters
P = dict(
    # camera (measured from the reference sleeve: 60.2 x 60.2 cavity, ~26 mm deep)
    cam_w=60.0, cam_h=60.0, cam_d=26.0, cam_r=6.0,   # cavity corner radius (<= camera corner radius)
    cam_clear=0.2,           # per side
    cradle_wall=2.0, lip=3.0, lip_t=2.0,
    stem_slot_w=9.0,         # slot in the bottom wall for the camera's stand (stem + ball)
    # TP-Link Tapo C100 / C110 - measured from the reference sleeve that fits this camera
    power_x=15.1,            # DC 5.5x2.1 jack on the BOTTOM of the head, right of centre (seen from outside)
    power_from_lip=15.6,     # jack centre measured from the rear-lip inner face
    power_d=12.0,            # clearance for the plug overmould
    sd_y=(-12.0, 15.5),      # microSD / reset window on the LEFT side (seen from outside)
    sd_from_lip=(1.5, 16.5),
    # magnet system
    mag_d_max=20.0, mag_t_max=5.0,
    cap_wall=1.0, cap_roof_min=1.2, cap_ridge_h=1.5,
    floor=0.8,               # plastic between magnet and glass
    sock_clear=0.2,
    lug_w=1.2, lug_h=1.6, lug_deg=29.0, chan_deg=36.0, twist_deg=40.0, ledge=1.4,
    # plates: every magnet sits ABOVE the camera, so neither plate is ever in the field of view
    outer_base=3.5, inner_base=3.0, plate_margin=0.0,
    sockets=[(38.0, 36.0), (-38.0, 36.0), (18.0, 66.0), (-18.0, 66.0)],
    # hinge
    hinge_dy=10.5,           # axis above the cradle's top outer surface
    hinge_z=16.3,            # axis distance from the glass
    hinge_r=9.5, ear_t=5.5, ear_gap=0.15, knuckle_hw=12.85,
    bolt_d=10.0, bolt_p=1.5, bore_r=5.3,
    head_flats=13.0, head_t=3.0, knob_r=8.5, knob_t=9.0,
    glass_t=4.0,             # only used for the assembly render
)

# ----------------------------------------------------------------------------- 2D / 3D helpers
def rrect(w, h, r, cx=0.0, cy=0.0):
    r = min(r, w / 2 - 1e-3, h / 2 - 1e-3)
    return CS.square((w - 2 * r, h - 2 * r), True).offset(r, JoinType.Round).translate((cx, cy))

def poly(pts):
    pts = list(pts)
    a = 0.5 * sum(pts[i][0] * pts[i - 1][1] - pts[i - 1][0] * pts[i][1] for i in range(len(pts)))
    if a > 0:  # shoelace sign is inverted with this indexing -> ensure CCW
        pts = pts[::-1]
    return CS([pts])

def sector(r, a0, a1, r_in=0.0, n=48):
    a = np.radians(np.linspace(a0, a1, n))
    outer = [(r * math.cos(t), r * math.sin(t)) for t in a]
    inner = [(r_in * math.cos(t), r_in * math.sin(t)) for t in a[::-1]] if r_in > 0 else [(0.0, 0.0)]
    return poly(outer + inner)

def ext(cs, z0, z1):
    return M.extrude(cs, z1 - z0).translate((0, 0, z0))

def yz_to_sketch(cs):
    # sketch for prism_x: (u,v) = (-z, y)
    return cs.transform(np.array([[0.0, -1.0, 0.0], [1.0, 0.0, 0.0]]))

def prism_x(cs_yz, x0, x1):
    """cs_yz is drawn in (y,z) coordinates; extruded along +x from x0 to x1."""
    return M.extrude(yz_to_sketch(cs_yz), x1 - x0).rotate((0, 90, 0)).translate((x0, 0, 0))

def prism_y(cs_xz, y0, y1):
    """cs_xz drawn in (x,z); extruded along +y from y0 to y1."""
    sk = cs_xz.transform(np.array([[1.0, 0.0, 0.0], [0.0, -1.0, 0.0]]))  # (x, -z)
    return M.extrude(sk, y1 - y0).rotate((-90, 0, 0)).translate((0, y0, 0))

def teardrop(r, cy, cz, up=+1):
    """teardrop in (y,z), point toward +z (up=+1) or -z (up=-1): 45 deg self-supporting roof."""
    c = CS.circle(r).translate((cy, cz))
    tip = (cy, cz + up * r * math.sqrt(2))
    s = r / math.sqrt(2)
    tri = poly([(cy - s, cz + up * s), (cy + s, cz + up * s), tip])
    return CS.hull(c + tri)

def to_trimesh(m):
    mesh = m.to_mesh()
    return trimesh.Trimesh(vertices=np.asarray(mesh.vert_properties)[:, :3], faces=np.asarray(mesh.tri_verts), process=False)

def save(m, path):
    # collapse sub-micron sliver triangles from the booleans so float32 STL rounding can't break the mesh
    tm = to_trimesh(m.simplify(1e-3))
    assert tm.is_watertight, path
    tm.export(path)
    back = trimesh.load(path)
    assert back.is_watertight and back.is_winding_consistent, f'{path} not watertight after STL export'
    return back

# ----------------------------------------------------------------------------- printed thread
def thread_section(D, pitch, grow=0.0, n=90):
    """Cross-section of a single-start 60deg thread perpendicular to its axis (ISO-like truncation)."""
    r_maj = D / 2 + grow
    r_min = D / 2 - 0.61343 * pitch + grow
    pts = []
    for i in range(n):
        phi = 2 * math.pi * i / n
        t = (i / n)  # axial position in pitches
        d = min(t, 1 - t)  # distance from crest centre (0..0.5)
        if d <= 1 / 16:
            r = r_maj
        elif d >= 0.5 - 1 / 8:
            r = r_min
        else:
            r = r_maj - (r_maj - r_min) * (d - 1 / 16) / (0.5 - 1 / 8 - 1 / 16)
        pts.append((r * math.cos(phi), r * math.sin(phi)))
    return poly(pts)

def threaded_rod(D, pitch, length, grow=0.0):
    turns = length / pitch
    return M.extrude(thread_section(D, pitch, grow), length, n_divisions=int(turns * 24), twist_degrees=360.0 * turns)  # +CCW with height = right-hand thread

# ----------------------------------------------------------------------------- derived values
def derived(p):
    d = {}
    d['cav_w'] = p['cam_w'] + 2 * p['cam_clear']
    d['cav_h'] = p['cam_h'] + 2 * p['cam_clear']
    d['out_w'] = d['cav_w'] + 2 * p['cradle_wall']
    d['out_h'] = d['cav_h'] + 2 * p['cradle_wall']
    d['ytop'] = d['out_h'] / 2
    d['cap_rc'] = p['mag_d_max'] / 2 + 0.175 + p['cap_wall']            # cap body radius
    d['cap_h'] = p['mag_t_max'] + 0.3 + p['cap_roof_min']               # cap body height (= socket depth)
    d['boss_h'] = p['floor'] + d['cap_h']                                # plate thickness at a socket
    d['sock_r'] = d['cap_rc'] + p['sock_clear']
    d['lug_r'] = d['cap_rc'] + p['lug_w']
    d['groove_r'] = d['lug_r'] + 0.3
    d['z_glass_end'] = d['boss_h'] + p['cap_ridge_h'] + 0.8             # cradle face nearest the glass
    d['cav_d'] = p['cam_d'] + 0.6
    d['z_rear'] = d['z_glass_end'] + d['cav_d'] + p['lip_t']
    d['y_h'] = d['ytop'] + p['hinge_dy']
    d['z_h'] = p['hinge_z']
    d['ear_x0'] = p['knuckle_hw'] + p['ear_gap']
    d['ear_x1'] = d['ear_x0'] + p['ear_t']
    return d

# ----------------------------------------------------------------------------- magnet socket / cap
def socket_cut(p, d, top):
    """Cavity to subtract from a plate whose socket opening is at z=top, floor at z=floor."""
    rs, rg = d['sock_r'], d['groove_r']
    cut = ext(CS.circle(rs), p['floor'], top + 1)
    zg0 = top - p['ledge'] - p['lug_h'] - 0.3
    zg1 = top - p['ledge']
    for i in range(3):
        a = 90 + 120 * i
        cut += ext(sector(rg, a - p['chan_deg'] / 2, a + p['chan_deg'] / 2), zg0, top + 1)            # entry
        cut += ext(sector(rg, a - p['chan_deg'] / 2 - p['twist_deg'], a + p['chan_deg'] / 2), zg0, zg1)  # lock: CLOCKWISE seen from the opening
    return cut

def magnet_cap(p, d, mag_d, mag_t):
    """Cap in installed orientation: rim at z=0 (rests on socket floor), top at cap_h. Print as-is (rim down)."""
    hc = d['cap_h']
    body = ext(CS.circle(d['cap_rc']), 0, hc)
    zl0 = hc - p['ledge'] - p['lug_h'] - 0.15
    for i in range(3):
        a = 90 + 120 * i
        body += ext(sector(d['lug_r'], a - p['lug_deg'] / 2, a + p['lug_deg'] / 2, r_in=d['cap_rc'] - 0.5), zl0, zl0 + p['lug_h'])
    # grip ridge (also shows lock state: ridge points at the lug / entry channel)
    ridge = ext(rrect(3.2, 2 * d['cap_rc'] - 3.0, 1.6), hc, hc + p['cap_ridge_h'])
    body += ridge
    if mag_t > 0:
        body -= ext(CS.circle(mag_d / 2 + 0.175), -1, mag_t + 0.3)
    # small 45 deg lead-in chamfer at the rim
    rc = d['cap_rc']   # 45 deg lead-in chamfer at the rim (cone crosses the wall at z=0.6, inside the cutter)
    ring = ext(CS.circle(rc + 2), 0, 0.7) - M.extrude(CS.circle(rc - 0.6), 0.8, scale_top=((rc + 0.2) / (rc - 0.6),) * 2)
    body -= ring
    return body

def magnet_cap_cluster(p, d, mag_d, mag_t, pitch=None, fit=0.1):
    """Cap holding 7 small magnets (centre + hex ring) in separate snug pockets, for tiny magnets such as 5x3.
    Same outside as magnet_cap, so it fits the same universal socket. All 7 magnets must face the same way."""
    base = magnet_cap(p, d, 0.0, 0.0)              # solid cap body, no single bore
    pitch = pitch or (mag_d + 2 * fit + 0.85)       # 0.85 mm walls between pockets
    centres = [(0.0, 0.0)] + [(pitch * math.cos(math.radians(30 + 60 * k)), pitch * math.sin(math.radians(30 + 60 * k))) for k in range(6)]
    assert pitch + mag_d / 2 + fit + 1.0 < d['cap_rc'], 'cluster does not fit in the cap'
    for c in centres:
        base -= ext(CS.circle(mag_d / 2 + fit, 48).translate(c), -1, mag_t + 0.3)
    return base

# ----------------------------------------------------------------------------- plates
def plate_outline(p, d):
    boss_r = d['sock_r'] + 3.9          # outline 0.6 mm outside the bosses (no coincident walls)
    shape = CS.hull(CS.batch_boolean([CS.circle(boss_r).translate(xy) for xy in p['sockets']], OpType.Add)
                    + CS.square((2 * d['ear_x1'], 1.0), True).translate((0, d['y_h'] - p['hinge_r'] + 0.5)))
    return shape

def plate(p, d, base_t):
    shape = plate_outline(p, d)
    body = ext(shape, 0, base_t)
    for (x, y) in p['sockets']:
        body += ext(CS.circle(d['sock_r'] + 3.3).translate((x, y)), base_t - 1.0, d['boss_h'])
    for (x, y) in p['sockets']:
        body -= socket_cut(p, d, d['boss_h']).translate((x, y, 0))
    return body

def outer_plate(p, d):
    body = plate(p, d, p['outer_base'])
    y_h, z_h, R = d['y_h'], d['z_h'], p['hinge_r']
    ear_prof = CS.hull(CS.circle(R).translate((y_h, z_h)) +
                       CS.square((2 * R, p['outer_base']), False).translate((y_h - R, 0)))
    bore = teardrop(p['bore_r'], y_h, z_h, up=+1)
    for s in (+1, -1):
        x0, x1 = (d['ear_x0'], d['ear_x1']) if s > 0 else (-d['ear_x1'], -d['ear_x0'])
        ear = prism_x(ear_prof, x0, x1) - prism_x(bore, x0 - 1, x1 + 1)
        body += ear
    # captive hex pocket on the -x ear (vertex up -> self supporting)
    rh = (p['head_flats'] + 0.3) / math.sqrt(3)
    # hexagon drawn directly in (y,z) with a vertex pointing to +z (self-supporting roof when printed flat)
    hex_yz = poly([(y_h + rh * math.cos(math.radians(90 + 60 * k)), z_h + rh * math.sin(math.radians(90 + 60 * k))) for k in range(6)])
    body -= prism_x(hex_yz, -d['ear_x1'] - 1, -d['ear_x1'] + p['head_t'] + 0.2)
    return body

def inner_plate(p, d):
    return plate(p, d, p['inner_base'])

# ----------------------------------------------------------------------------- cradle
def cradle(p, d):
    zg, zr = d['z_glass_end'], d['z_rear']
    cav = rrect(d['cav_w'], d['cav_h'], p['cam_r'])
    outer = rrect(d['out_w'], d['out_h'], p['cam_r'] + p['cradle_wall'])
    body = ext(outer, zg, zr)
    # hinge knuckle + 45 deg gusset (prints without support, lip side on the bed)
    y_h, z_h, R, yt = d['y_h'], d['z_h'], p['hinge_r'], d['ytop']
    # 45 deg tangent to the knuckle circle; where it meets the rear (bed) face gives the gusset foot
    y_foot = max(yt, y_h + R * math.sqrt(2) - (zr - z_h))
    kn = CS.hull(CS.circle(R).translate((y_h, z_h)) + poly([(yt - 1.5, zg), (yt, zg), (y_foot, zr), (yt - 1.5, zr)]))
    body += prism_x(kn, -p['knuckle_hw'], p['knuckle_hw'])
    body -= prism_x(teardrop(p['bore_r'], y_h, z_h, up=-1), -p['knuckle_hw'] - 1, p['knuckle_hw'] + 1)
    # camera cavity + rear window (lip)
    body -= ext(cav, zg - 1, zg + d['cav_d'])
    body -= ext(rrect(d['cav_w'] - 2 * p['lip'], d['cav_h'] - 2 * p['lip'], max(p['cam_r'] - p['lip'], 2)), zg, zr + 1)
    # stem / cable slot in the bottom wall, open at the glass end
    hw = p['stem_slot_w'] / 2
    slot = CS.hull(CS.circle(hw).translate((0, zg + d['cav_d'] - hw)) + CS.square((2 * hw, 1), False).translate((-hw, zg - 1)))
    body -= prism_y(slot, -d['out_h'] / 2 - 1, -d['cav_h'] / 2 + 0.5)
    z_lip = zg + d['cav_d']                       # inner face of the rear lip
    # DC power jack hole in the bottom wall (teardrop: point toward the glass end = print top)
    pw = teardrop(p['power_d'] / 2, p['power_x'], z_lip - p['power_from_lip'], up=-1)
    body -= prism_y(pw, -d['out_h'] / 2 - 1, -d['cav_h'] / 2 + 0.5)
    # LEFT side: microSD / reset window, 45 deg chamfered roof toward the glass end (print top)
    y0, y1 = p['sd_y']; z0, z1 = z_lip - p['sd_from_lip'][1], z_lip - p['sd_from_lip'][0]
    c = 5.0   # 45 deg corner chamfers; the remaining ~17 mm roof is a short, easy bridge
    sd = poly([(y0, z1), (y1, z1), (y1, z0 + c), (y1 - c + 1e-3 if y1 - c > y0 + c else (y0 + y1) / 2 + 1e-3, z0), (y0 + c, z0), (y0, z0 + c)])
    body -= prism_x(sd, -d['out_w'] / 2 - 1, -d['cav_w'] / 2 + 0.5)
    # RIGHT side: ventilation window, pointed roof -> no bridging
    zc = zg + d['cav_d'] / 2
    wl, wh = min(16.0, d['cav_d'] - 9), 18.0
    z0, z1 = zc - wl / 2, zc + wl / 2
    win = poly([(-wh / 2, z1), (wh / 2, z1), (wh / 2, z0 + wh / 2), (0, z0), (-wh / 2, z0 + wh / 2)])
    body -= prism_x(win, d['cav_w'] / 2 - 0.5, d['out_w'] / 2 + 1)
    # snap ridges near the glass end (hold the camera when the cradle is tilted)
    tri = poly([(d['cav_w'] / 2 + 0.01, zg + 0.6), (d['cav_w'] / 2 - 0.6, zg + 1.6), (d['cav_w'] / 2 + 0.01, zg + 2.6)])
    for s in (1, -1):
        r = prism_y(tri, -12, 12)
        body += r if s > 0 else r.mirror((1, 0, 0))
    return body

# ----------------------------------------------------------------------------- hinge hardware
def hinge_bolt(p, d):
    """Printed head-down. Head hex (flats=head_flats) then threaded shank."""
    length = 2 * d['ear_x1'] + p['knob_t'] - 0.5 - p['head_t']   # head flush in the -x ear, tip 0.5 inside the knob
    rh = p['head_flats'] / math.sqrt(3)
    head = ext(CS.circle(rh, 6), 0, p['head_t'])  # vertex on +x -> lies along z after placement
    head -= M.extrude(CS.circle(rh + 2), 0.5).translate((0, 0, 0)) - M.extrude(CS.circle(rh - 0.5), 0.5, scale_top=((rh) / (rh - 0.5),) * 2)
    rod = threaded_rod(p['bolt_d'], p['bolt_p'], length, grow=-0.1).translate((0, 0, p['head_t']))
    # 45 deg tip chamfer
    tip = M.cylinder(1.2, p['bolt_d'] / 2 + 1, p['bolt_d'] / 2 + 1).translate((0, 0, p['head_t'] + length - 1.2)) - \
          M.cylinder(1.2, p['bolt_d'] / 2, p['bolt_d'] / 2 - 1.2).translate((0, 0, p['head_t'] + length - 1.2))
    return head + rod - tip, length + p['head_t']

def hinge_knob(p, d):
    t, R = p['knob_t'], p['knob_r']
    n = 10
    prof = CS.circle(R)
    for k in range(n):
        a = 2 * math.pi * k / n
        prof -= CS.circle(1.6).translate(((R + 0.95) * math.cos(a), (R + 0.95) * math.sin(a)))
    knob = ext(prof, 0, t)
    # top edge chamfer
    knob -= ext(CS.circle(R + 3), t - 0.8, t + 1) - M.extrude(CS.circle(R - 0.1), 0.8, scale_top=((R - 0.9) / (R - 0.1),) * 2).translate((0, 0, t - 0.8))
    knob -= threaded_rod(p['bolt_d'], p['bolt_p'], t + 2, grow=+0.15).translate((0, 0, -1))
    # entry countersink
    knob -= M.cylinder(1.0, p['bolt_d'] / 2 + 0.8, p['bolt_d'] / 2 - 0.2).translate((0, 0, -0.001))
    return knob

# ----------------------------------------------------------------------------- assembly helpers
def rot_about_hinge(m, d, deg):
    """deg > 0 : camera looks DOWN (bottom of the cradle swings away from the glass)."""
    return m.translate((0, -d['y_h'], -d['z_h'])).rotate((-deg, 0, 0)).translate((0, d['y_h'], d['z_h']))

def place_bolt(bolt, d, p):
    # bolt built along +z with head at z=0 -> lay along +x starting at the -x ear outer face
    return bolt.rotate((0, 90, 0)).translate((-d['ear_x1'], d['y_h'], d['z_h']))

def place_knob(knob, d):
    return knob.rotate((0, 90, 0)).translate((d['ear_x1'], d['y_h'], d['z_h']))

def place_inner(inner, p):
    # inner plate: glass face at its z=0, sits at z = -glass_t, facing -z
    return inner.mirror((0, 0, 1)).translate((0, 0, -p['glass_t']))

def place_cap_outer(cap, xy, d, p, locked=True):
    return cap.rotate((0, 0, -p['twist_deg'] if locked else 0)).translate((xy[0], xy[1], p['floor']))

# ----------------------------------------------------------------------------- main
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', default=os.path.join(os.path.dirname(__file__), '..'))
    ap.add_argument('--cam-w', type=float); ap.add_argument('--cam-h', type=float); ap.add_argument('--cam-d', type=float)
    ap.add_argument('--checks', action='store_true')
    a = ap.parse_args()
    p = dict(P)
    for k in ('cam_w', 'cam_h', 'cam_d'):
        if getattr(a, k) is not None:
            p[k] = getattr(a, k)
    d = derived(p)
    out = os.path.abspath(a.out)
    os.makedirs(os.path.join(out, 'caps'), exist_ok=True)

    parts = {}
    parts['outer_plate'] = outer_plate(p, d)
    parts['inner_plate'] = inner_plate(p, d)
    parts['cradle'] = cradle(p, d)
    bolt, blen = hinge_bolt(p, d)
    parts['hinge_bolt'] = bolt
    parts['hinge_knob'] = hinge_knob(p, d)

    # print orientations
    printable = {
        'outer_plate': parts['outer_plate'],                                   # glass face down
        'inner_plate': parts['inner_plate'],                                   # glass face down
        'cradle': parts['cradle'].mirror((0, 0, 1)).translate((0, 0, d['z_rear'])),  # rear lip down
        'hinge_bolt': parts['hinge_bolt'],                                     # head down
        'hinge_knob': parts['hinge_knob'],
    }
    info = {}
    for k, m in printable.items():
        tm = save(m, os.path.join(out, f'{k}.stl'))
        info[k] = dict(size=[round(v, 2) for v in tm.extents], volume_cm3=round(tm.volume / 1000, 2))

    caps = {}
    sizes_d = [5, 6, 8, 10, 12, 15, 18, 20]
    sizes_t = [2, 3, 4, 5]
    for md in sizes_d:
        for mt in sizes_t:
            c = magnet_cap(p, d, md, mt)
            save(c, os.path.join(out, 'caps', f'cap_D{md}x{mt}.stl'))
            caps[(md, mt)] = c
    # 7-magnet cluster caps for tiny magnets (5x3: a single one is far too weak through the glass)
    step = 2 * d['lug_r'] + 3
    for (md, mt) in ((5, 2), (5, 3), (6, 3)):
        c = magnet_cap_cluster(p, d, md, mt)
        save(c, os.path.join(out, 'caps', f'cap_D{md}x{mt}_x7.stl'))
        if (md, mt) == (5, 3):
            grid = M()
            for i in range(8):
                grid += c.translate(((i % 4) * step, (i // 4) * step, 0))
            save(grid, os.path.join(out, 'caps', 'cap_D5x3_x7_set_of_8.stl'))
    # a full set for 12x3 magnets: 8 caps on one plate
    grid = M()
    step = 2 * d['lug_r'] + 3
    for i in range(8):
        grid += caps[(12, 3)].translate(((i % 4) * step, (i // 4) * step, 0))
    save(grid, os.path.join(out, 'caps', 'cap_D12x3_set_of_8.stl'))

    info['derived'] = {k: round(v, 3) for k, v in d.items()}
    info['bolt_length_total'] = round(blen, 2)
    with open(os.path.join(out, 'scripts', 'last_build.json'), 'w') as f:
        json.dump(info, f, indent=2)
    print(json.dumps(info, indent=1))

    return p, d, parts, caps

if __name__ == '__main__':
    main()
