#!/usr/bin/env python3
"""Interference checks over the tilt range + preview renders (matplotlib)."""
import os, sys, math
import numpy as np, trimesh, matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
sys.path.insert(0, os.path.dirname(__file__))
import generate as g
from manifold3d import Manifold as M, CrossSection as CS

OUT = os.path.join(os.path.dirname(__file__), '..', 'renders')
os.makedirs(OUT, exist_ok=True)
p = dict(g.P); d = g.derived(p)

outer = g.outer_plate(p, d); inner = g.inner_plate(p, d); cr = g.cradle(p, d)
bolt, _ = g.hinge_bolt(p, d); knob = g.hinge_knob(p, d)
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
    view_obstruction()
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
          to_view(tm(g.place_inner(inner, p).translate((0, 0, -25)))), to_view(tm(caps_i.mirror((0, 0, 1)).translate((0, 0, -p['glass_t'] - 40))))]
    render(ex, [WHITE, CAPC, WHITE, GREY, GREY, WHITE, CAPC], os.path.join(OUT, 'exploded.png'), [(15, -60)], size=8, titles=['exploded'])
    # single parts (print orientation)
    def rp(m, name, views=((30, -60), (60, 30)), col=WHITE):
        render([tm(m)], [col], os.path.join(OUT, name + '.png'), views, size=4.5)
    rp(outer, 'part_outer_plate'); rp(inner, 'part_inner_plate', ((35, -60), (-50, 30)))
    rp(cr.mirror((0, 0, 1)), 'part_cradle', ((25, -60), (25, 120)))
    rp(cap, 'part_cap_D12x3', ((40, -60), (-45, -60)), CAPC)
    rp(g.magnet_cap_cluster(p, d, 5, 3), 'part_cap_D5x3_x7', ((40, -60), (-55, -60)), CAPC)
    # Tapo C100/C110: power jack hole + stem slot (bottom) and microSD window (left)
    render([to_view(tm(cr))], [WHITE], os.path.join(OUT, 'cradle_power_hole.png'), [(-60, -90), (12, 205)], size=5.5,
           titles=['bottom: DC power hole (right) + stem slot', 'left side: microSD / reset window'])
    # socket close-up
    sock = (outer ^ g.ext(CS.circle(17).translate(p['sockets'][0]), -1, 20))
    rp(sock, 'socket_closeup', ((50, -70), (70, 20)))
    print('renders written')
