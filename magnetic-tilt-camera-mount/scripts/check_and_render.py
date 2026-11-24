#!/usr/bin/env python3
"""Checks (interference over the tilt range, view obstruction, FDM fits, print-orientation audit of every
exported STL, power-hole side verified on the exported cradle.stl) + preview renders (matplotlib)."""
import os, sys, math, glob
import numpy as np, trimesh, matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
sys.path.insert(0, os.path.dirname(__file__))
import generate as g
from manifold3d import Manifold as M, CrossSection as CS

OUT = os.path.join(os.path.dirname(__file__), '..', 'renders')
os.makedirs(OUT, exist_ok=True)
ROOT = os.path.join(os.path.dirname(__file__), '..')
p, d, _parts = g.build()
outer, inner, cr = _parts['outer_plate'], _parts['inner_plate'], _parts['cradle']
bolt, knob = _parts['hinge_bolt'], _parts['hinge_knob']
bolt_a = g.place_bolt(bolt, d, p); knob_a = g.place_knob(knob, d)
cap = g.magnet_cap(p, d, 12, 3)
caps_o = M(); caps_i = M()
for xy in p['sockets']:
    caps_o += g.place_cap_outer(cap, xy, d, p)
    caps_i += g.place_cap_outer(cap, xy, d, p)
inner_a = g.place_inner(inner + caps_i, p)
# camera dummy (box) + its lens
cam = g.ext(g.rrect(p['cam_w'], p['cam_h'], 8), d['z_glass_end'] + 0.3, d['z_glass_end'] + 0.3 + p['cam_d'])
fixed = outer + caps_o + knob_a

def report():
    print('--- interference (mm^3) ---')
    rows = []
    for ang in range(-2, 91, 2):
        mov = g.rot_about_hinge(cr + cam, d, ang)
        v1 = (mov ^ fixed).volume()
        v2 = (mov ^ bolt_a).volume()
        rows.append((ang, v1, v2))
    for a, v1, v2 in rows:
        if a % 10 == 0 or v1 > 0.01 or v2 > 0.01:
            print(f'tilt {a:3d} deg : cradle vs plate/caps/knob = {v1:8.3f}   cradle vs bolt = {v2:7.3f}')
    print('bolt vs plate (should be ~0):', round((bolt_a ^ outer).volume(), 3), ' knob vs plate:', round((knob_a ^ (outer + caps_o)).volume(), 3))
    print('caps vs plate:', round((caps_o ^ outer).volume(), 4))
    # clearance of the cradle above caps at 0 deg
    print('min gap cradle-outer(0deg):', round(cr.min_gap(outer + caps_o, 5), 3))
    print('min gap knob-caps:', round(knob_a.min_gap(caps_o, 5), 3), ' knob-plate', round(knob_a.min_gap(outer, 5), 3))

def fits():
    print('--- FDM fits (TOL) ---')
    print('tolerances:', g.TOL)
    sx, sy = p['sockets'][0]
    def cap_at(tw, dz=0.0):
        return cap.rotate((0, 0, tw)).translate((sx, sy, p['floor'] + dz))
    free = [round((cap_at(t) ^ outer).volume(), 3) for t in range(0, -41, -5)]
    print('cap turning 0 -> -40 deg (clockwise from the opening), interference:', max(free), '(must be 0)')
    print('cap turned the wrong way (+15 deg), interference:', round((cap_at(15) ^ outer).volume(), 2), '(>0 = blocked)')
    print('cap locked (-40) and pulled out 1.0 mm, interference:', round((cap_at(-40, 1.0) ^ outer).volume(), 2), '(>0 = retained)')
    print('cap unlocked (0) and pulled straight out 3 mm:', round((cap_at(0, 3.0) ^ outer).volume(), 3), '(must be 0 = removable)')
    print('cradle knuckle to ears gap:', round(cr.min_gap(outer, 2), 3), 'mm (TOL hinge_gap', g.TOL['hinge_gap'], ')')
    vs = [round((bolt ^ knob.translate((0, 0, 20 + t))).volume(), 3) for t in np.arange(0, p['bolt_p'], 0.05)]
    print('thread: min interference over one pitch =', min(vs), '(0 = screws together)')
    print('bolt head in pocket interference:', round((bolt_a ^ outer).volume(), 3), ' head turned 5 deg:',
          round((g.place_bolt(bolt.rotate((0, 0, 5)), d, p) ^ outer).volume(), 2), '(>0 = keyed, bolt cannot spin)')

def power_hole_on_exported_stl():
    """Load the STL that will actually be printed, put it back in the installed pose with the inverse of the
    (rigid) print pose, and check the DC hole is BOTTOM-RIGHT and the SD window LEFT, seen from outside."""
    print('--- Tapo C100/C110 openings, checked on the exported cradle.stl ---')
    m = trimesh.load(os.path.join(ROOT, 'cradle.stl'))
    T = np.eye(4); T[2, 3] = -d['z_rear']
    R = trimesh.transformations.rotation_matrix(math.pi, [1, 0, 0])
    m.apply_transform(R @ T)                                   # inverse of rotate(180 about x) + translate
    z_lip = d['z_glass_end'] + d['cav_d']
    zc = z_lip - p['power_from_lip']
    def open_(o, v): return not m.ray.intersects_any([o], [v])[0]
    res = {
        'DC hole bottom-RIGHT (x=+%.1f)' % p['power_x']: open_([p['power_x'], -d['cav_h'] / 2 + 2, zc], [0, -1, 0]),
        'bottom-LEFT mirror position (x=-%.1f) is wall' % p['power_x']: not open_([-p['power_x'], -d['cav_h'] / 2 + 2, zc], [0, -1, 0]),
        'top at x=+%.1f is wall' % p['power_x']: not open_([p['power_x'], d['cav_h'] / 2 - 2, zc], [0, 1, 0]),
        'SD window on the LEFT (x<0)': open_([-d['cav_w'] / 2 + 2, 0, z_lip - 3], [-1, 0, 0]),
        'RIGHT wall closed at the SD window': not open_([d['cav_w'] / 2 - 2, 0, z_lip - 3], [1, 0, 0]),
        'stem slot bottom centre': open_([0, -d['cav_h'] / 2 + 2, z_lip - 8], [0, -1, 0]),
    }
    for k, v in res.items():
        print(('OK   ' if v else 'FAIL ') + k)
    assert all(res.values())

def print_audit():
    """Every exported STL, in the orientation it is saved (= print orientation): overhang area steeper than
    45 deg from vertical and flat downward faces (bridges), ignoring faces on the bed."""
    print('--- print-orientation audit of the exported STLs (area in mm^2, bed faces excluded) ---')
    print(f"{'file':34s} {'>46deg':>8s} {'>55deg':>8s} {'bridge':>8s}  bed contact")
    files = sorted(glob.glob(os.path.join(ROOT, '*.stl'))) + sorted(glob.glob(os.path.join(ROOT, 'caps', '*.stl')))
    worst = 0
    for f in files:
        m = trimesh.load(f); n = m.face_normals; zc = m.triangles_center[:, 2] - m.bounds[0, 2]; a = m.area_faces
        up = zc > 0.05
        # overhang angle from vertical = 90 - (angle between normal and straight down)
        o46 = a[(n[:, 2] < -math.cos(math.radians(90 - 46))) & up].sum()
        o55 = a[(n[:, 2] < -math.cos(math.radians(90 - 55))) & up].sum()
        br = a[(n[:, 2] < -0.995) & up].sum()
        bed = a[(n[:, 2] < -0.995) & ~up].sum()
        worst = max(worst, o55)
        name = os.path.relpath(f, ROOT)
        if not name.startswith('caps/cap_D') or name in ('caps/cap_D12x3.stl', 'caps/cap_D20x5.stl', 'caps/cap_D5x3_x7.stl', 'caps/cap_D6x2.stl') or o46 > 1:
            print(f'{name:34s} {o46:8.1f} {o55:8.1f} {br:8.1f}  {bed:8.0f}')
    print(f'({len(files)} files; worst >55deg area = {worst:.1f} mm^2)')

def tm(m):
    return g.to_trimesh(m)

def lens_pose(ang):
    # lens assumed at the centre of the camera face
    c = np.array([0, 0, d['z_glass_end'] + 0.3])
    a = math.radians(ang)
    rel = c - np.array([0, d['y_h'], d['z_h']])
    R = np.array([[1, 0, 0], [0, math.cos(-a), -math.sin(-a)], [0, math.sin(-a), math.cos(-a)]])
    pos = R @ rel + np.array([0, d['y_h'], d['z_h']])
    dirv = R @ np.array([0, 0, -1.0])
    return pos, dirv, R

def view_obstruction(hfov=100, vfov=60):
    """fraction of camera rays (inside the FOV) blocked by the plates/caps (not by the cradle itself)."""
    obst = tm(outer + caps_o); obst = trimesh.util.concatenate([obst, tm(inner_a)])
    print('--- view obstruction by plates (HFOV %d, VFOV %d) ---' % (hfov, vfov))
    for ang in (0, 10, 20, 30, 45, 60):
        pos, dv, R = lens_pose(ang)
        us = np.radians(np.linspace(-hfov / 2, hfov / 2, 41)); vs = np.radians(np.linspace(-vfov / 2, vfov / 2, 25))
        dirs = []
        for u in us:
            for v in vs:
                loc = np.array([math.tan(u), math.tan(v), -1.0]); loc /= np.linalg.norm(loc)
                dirs.append(R @ loc)
        dirs = np.array(dirs)
        hit = obst.ray.intersects_any(np.repeat(pos[None], len(dirs), 0) + dirs * 0.5, dirs)
        print(f'tilt {ang:2d}: lens at y={pos[1]:6.1f} z={pos[2]:5.1f} (glass gap)  blocked {100*hit.mean():5.1f}%')

def render(meshes, colors, out, views, size=5.0, titles=None, lims=None):
    fig = plt.figure(figsize=(size * len(views), size))
    allv = np.vstack([m.vertices for m in meshes])
    c = (allv.max(0) + allv.min(0)) / 2; r = (allv.max(0) - allv.min(0)).max() / 2 * 0.85
    light = np.array([0.35, 0.55, 0.75]); light /= np.linalg.norm(light)
    for i, (el, az) in enumerate(views):
        ax = fig.add_subplot(1, len(views), i + 1, projection='3d')
        for m, col in zip(meshes, colors):
            rgb = np.array(matplotlib.colors.to_rgb(col[:7] if isinstance(col, str) else col))
            alpha = 1.0 if not (isinstance(col, str) and len(col) > 7) else int(col[7:], 16) / 255
            sh = 0.30 + 0.70 * np.abs(m.face_normals @ light)
            fc = np.clip(rgb[None] * sh[:, None], 0, 1)
            fc = np.c_[fc, np.full(len(fc), alpha)]
            ax.add_collection3d(Poly3DCollection(m.vertices[m.faces], facecolors=fc, edgecolors='none', linewidths=0))
        ax.set_xlim(c[0] - r, c[0] + r); ax.set_ylim(c[1] - r, c[1] + r); ax.set_zlim(c[2] - r, c[2] + r)
        ax.set_box_aspect((1, 1, 1)); ax.view_init(el, az); ax.set_axis_off()
        if titles: ax.set_title(titles[i], fontsize=12)
    plt.tight_layout(); plt.savefig(out, dpi=110, facecolor='white'); plt.close()

def to_view(m):
    # display frame: x right, y = into the door (-z of assembly), z = up (y of assembly)
    t = m.copy(); t.apply_transform(np.array([[1, 0, 0, 0], [0, 0, -1, 0], [0, 1, 0, 0], [0, 0, 0, 1]], float)); return t

if __name__ == '__main__':
    report()
    fits()
    view_obstruction()
    power_hole_on_exported_stl()
    print_audit()
    if '--no-render' in sys.argv: sys.exit()
    WHITE, GREY, GLASS, CAPC, CAMC = '#e9e4d8', '#9aa3ad', '#9fd3e6', '#d9534f', '#3a3f45'
    glass = g.ext(g.rrect(150, 150, 2), -p['glass_t'], 0).translate((0, 0, 0))
    for ang, name in ((0, 'assembly_tilt0'), (30, 'assembly_tilt30')):
        mov = g.rot_about_hinge(cr, d, ang); camm = g.rot_about_hinge(cam, d, ang)
        ms = [to_view(tm(x)) for x in (outer, caps_o, knob_a, bolt_a, mov, camm, inner_a)]
        render(ms, [WHITE, CAPC, GREY, GREY, WHITE, CAMC, WHITE], os.path.join(OUT, name + '.png'),
               [(18, -55), (10, -8), (25, 130)], titles=[f'tilt {ang}° - outside', f'tilt {ang}° - side', 'from inside the printer'])
    # tilt sweep side view
    ms = [to_view(tm(outer)), to_view(tm(knob_a)), to_view(tm(inner_a))]
    cols = [WHITE, GREY, WHITE]
    for ang, col in ((0, '#e9e4d8'), (25, '#f0ad4e'), (50, '#5bc0de')):
        ms.append(to_view(tm(g.rot_about_hinge(cr, d, ang)))); cols.append(col)
    render(ms, cols, os.path.join(OUT, 'tilt_range_side.png'), [(0, 0)], size=7, titles=['tilt 0° / 25° / 50° (side view)'])
    # exploded
    ex = [to_view(tm(outer)), to_view(tm(caps_o.translate((0, 0, 14)))), to_view(tm(cr.translate((0, 0, 40)))),
          to_view(tm(bolt_a.translate((-30, 0, 40)))), to_view(tm(knob_a.translate((30, 0, 40)))),
          to_view(tm(g.place_inner(inner, p).translate((0, 0, -25)))), to_view(tm(g.place_inner(caps_i, p).translate((0, 0, -40))))]
    render(ex, [WHITE, CAPC, WHITE, GREY, GREY, WHITE, CAPC], os.path.join(OUT, 'exploded.png'), [(15, -60)], size=8, titles=['exploded'])
    # single parts (print orientation)
    def rp(m, name, views=((30, -60), (60, 30)), col=WHITE):
        render([tm(m)], [col], os.path.join(OUT, name + '.png'), views, size=4.5)
    rp(outer, 'part_outer_plate'); rp(inner, 'part_inner_plate', ((35, -60), (-50, 30)))
    rp(g.cradle_print_pose(cr, d), 'part_cradle', ((25, -60), (25, 120)))
    rp(g.bolt_print_pose(bolt, p), 'part_bolt_print_flat', ((25, -60), (0, -90)), GREY)
    rp(g.cap_print_pose(cap, d), 'part_cap_D12x3', ((-45, -60), (40, -60)), CAPC)
    rp(g.cap_print_pose(g.magnet_cap_cluster(p, d, 5, 3), d), 'part_cap_D5x3_x7', ((-45, -60), (40, -60)), CAPC)
    rp(g.fit_coupon(p, d), 'test_fit_coupon', ((40, -60), (70, 20)), WHITE)
    # Tapo C100/C110: power jack hole + stem slot (bottom) and microSD window (left)
    render([to_view(tm(cr))], [WHITE], os.path.join(OUT, 'cradle_power_hole.png'), [(-60, -90), (12, 205)], size=5.5,
           titles=['bottom: DC power hole (right) + stem slot', 'left side: microSD / reset window'])
    # socket close-up
    sock = (outer ^ g.ext(CS.circle(17).translate(p['sockets'][0]), -1, 20))
    rp(sock, 'socket_closeup', ((50, -70), (70, 20)))
    # every exported STL in its print orientation, side by side on the bed
    lay, x = [], 0
    for f, col in (('outer_plate.stl', WHITE), ('cradle.stl', WHITE), ('hinge_bolt.stl', GREY), ('hinge_knob.stl', GREY), ('caps/cap_D12x3.stl', CAPC)):
        m = trimesh.load(os.path.join(ROOT, f)); m.apply_translation([-m.bounds[0][0] + x, -m.bounds[0][1], -m.bounds[0][2]])
        x = m.bounds[1][0] + 8; lay.append((m, col))
    render([m for m, _ in lay], [c for _, c in lay], os.path.join(OUT, 'print_layout.png'), [(28, -70)], size=9,
           titles=['print orientation: every part flat on the bed, no supports'])
    print('renders written')
