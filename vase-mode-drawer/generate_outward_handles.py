import os
import numpy as np
import trimesh
import manifold3d as m3d
from scipy.spatial import HalfspaceIntersection, ConvexHull

out_dir = "/root/3dmodel/vase-mode-drawer"
os.makedirs(out_dir, exist_ok=True)

outer_pts = [
    (-104.5, -110.5),
    ( 104.5, -110.5),
    ( 104.5,   89.5),
    (  94.5,   99.5),
    ( -94.5,   99.5),
    (-104.5,   89.5),
]
cs_outer = m3d.CrossSection([outer_pts])
mf_base = m3d.Manifold.extrude(cs_outer, 73.0)

def manifold_to_trimesh(mf):
    mesh = mf.to_mesh()
    verts = np.array(mesh.vert_properties)[:, :3]
    faces = np.array(mesh.tri_verts)
    return trimesh.Trimesh(vertices=verts, faces=faces, process=True)

# ==============================================================================
# Version 5: Outward Protruding Top Pocket / Lip Handle (外凸 14mm 頂部開口扣手槽)
# Protrudes in -Y direction from Y = -110.5 to Y = -110.5 - 14.0 = -124.5
# - At Z in [53.0, 73.0]: full protrusion depth d = 14.0 mm (Y down to -124.5)
# - At Z in [39.0, 53.0]: 45-deg bottom ramp from Y = -110.5 (at Z=39) to Y = -124.5 (at Z=53)
# - Side walls angled at 45 deg in XY and following original trapezoidal slope in XZ
# ==============================================================================
d5 = 14.0
x_bot = 35.3047
x_top = 59.1398
slope = (x_top - x_bot) / 20.0
y0 = -110.5

# Let's define the convex polyhedron for the outward boss (overlapping slightly into Y <= -109.5 for clean union):
# 1. Y <= -109.5  (0*x + 1*y + 0*z + 109.5 <= 0)
# 2. Y >= -110.5 - d5  (0*x - 1*y + 0*z - 110.5 - d5 <= 0)
# 3. Z <= 73.0  (0*x + 0*y + 1*z - 73.0 <= 0)
# 4. Bottom 45-deg overhang ramp: as Y goes more negative (below -110.5), Z must increase:
#    At Y = -110.5, Z >= 53.0 - d5 = 39.0
#    At Y = -110.5 - d5, Z >= 53.0
#    So -(Y + 110.5) <= Z - (53.0 - d5)  =>  -Y - Z - 110.5 + 53.0 - d5 <= 0
# 5. Right side wall (45 deg in XY so narrower at Y = -124.5, wider at Y = -110.5):
#    At Y = -110.5, Z = 53.0: X = x_bot + d5 (or X = x_bot at Y = -110.5)
#    Let's set X at Y = -110.5 to be x_bot (35.3047) at Z = 53.0 and x_top (59.1398) at Z = 73.0,
#    OR let the outer face at Y = -124.5 have half-width x_bot (35.3) to x_top (59.1) so the grip is wide and comfortable!
#    Yes! Making X = x_bot at Z=53 on Y=-110.5 means at Y=-124.5 it's still 21.3*2=42.6mm wide at bottom and 90.3mm wide at top,
#    OR making X at Y=-110.5 slightly wider (+d5) makes the front face of the handle match the exact original width (70.6mm to 118.3mm)!
#    Let's make the front-most face (Y = -124.5) have half-width 30.0 mm at Z=53 and 53.8 mm at Z=73 (so at Y=-110.5 it is 44.0 mm to 67.8 mm):
x_base_53 = 42.0 # at Y = -110.5, Z = 53.0 -> at Y = -124.5, Z = 53.0 it is 28.0 (56mm wide), and at Z = 73.0 it is 51.8 (103.6mm wide)
halfspaces_v5 = np.array([
    [ 0.0,  1.0,  0.0,  109.5],                                   # y <= -109.5
    [ 0.0, -1.0,  0.0, -110.5 - d5],                              # y >= -110.5 - d5
    [ 0.0,  0.0,  1.0, -73.0],                                    # z <= 73.0
    [ 0.0, -1.0, -1.0, -110.5 + 53.0 - d5],                       # -y - z - 110.5 + 53 - d5 <= 0
    [ 1.0, -1.0, -slope, -110.5 + slope * 53.0 - x_base_53],      # x - (y + 110.5) - slope*(z - 53) - x_base_53 <= 0
    [-1.0, -1.0, -slope, -110.5 + slope * 53.0 - x_base_53],      # -x - (y + 110.5) - slope*(z - 53) - x_base_53 <= 0
])
interior_pt_v5 = np.array([0.0, -110.5 - d5 * 0.5, 60.0])
hs_v5 = HalfspaceIntersection(halfspaces_v5, interior_pt_v5)
hull_v5 = ConvexHull(hs_v5.intersections)
boss_v5_tm = trimesh.Trimesh(vertices=hs_v5.intersections, faces=hull_v5.simplices, process=True)
boss_v5_tm.fix_normals()
boss_v5_mf = m3d.Manifold(m3d.Mesh(
    vert_properties=np.array(boss_v5_tm.vertices, dtype=np.float32),
    tri_verts=np.array(boss_v5_tm.faces, dtype=np.uint32)
))
mf_v5 = mf_base + boss_v5_mf
tm_v5 = manifold_to_trimesh(mf_v5)
v5_path = os.path.join(out_dir, "Drawer_Vase_v5_Outward_Pocket_Handle_14mm.stl")
tm_v5.export(v5_path)
print("Saved v5:", v5_path, "Watertight:", tm_v5.is_watertight, "Bounds:", tm_v5.bounds.tolist(), "Extents:", tm_v5.extents)

# ==============================================================================
# Version 6: Outward Protruding Closed Bar Handle (外凸 14mm 上下 45° 自封閉橫條把手)
# Why? In Vase Mode, Top Shell Layers = 0.
# By sloping outward at 45 deg (Z = 35 to 49), going vertical (Z = 49 to 57),
# and sloping BACK INWARD at 45 deg (Z = 57 to 71) to rejoin the front wall before Z = 73,
# the handle roof closes itself completely at 45 deg without needing top layers,
# and the top rim (Z = 71 to 73) returns to the clean rectangular drawer profile!
# ==============================================================================
d6 = 14.0
z_bot_start = 35.0
z_bot_full  = 35.0 + d6 # 49.0
z_top_full  = 57.0
z_top_end   = 57.0 + d6 # 71.0
x_half_wall = 55.0 # total width on wall = 110 mm; on outer face (Y=-124.5) = 82 mm

halfspaces_v6 = np.array([
    [ 0.0,  1.0,  0.0,  109.5],                   # y <= -109.5
    [ 0.0, -1.0,  0.0, -110.5 - d6],              # y >= -110.5 - d6
    # Bottom 45-deg ramp: at Y = -110.5, Z >= 35.0; at Y = -124.5, Z >= 49.0 => -(Y + 110.5) <= Z - 35.0
    [ 0.0, -1.0, -1.0, -110.5 + z_bot_start],     # -y - z - 110.5 + 35 <= 0
    # Top 45-deg roof ramp: at Y = -124.5, Z <= 57.0; at Y = -110.5, Z <= 71.0 => -(Y + 110.5) <= 71.0 - Z
    [ 0.0, -1.0,  1.0, -110.5 - z_top_end],       # -y + z - 110.5 - 71 <= 0
    # Right 45-deg side wall in XY: X - (Y + 110.5) <= x_half_wall
    [ 1.0, -1.0,  0.0, -110.5 - x_half_wall],
    # Left 45-deg side wall in XY: -X - (Y + 110.5) <= x_half_wall
    [-1.0, -1.0,  0.0, -110.5 - x_half_wall],
])
interior_pt_v6 = np.array([0.0, -110.5 - d6 * 0.5, 53.0])
hs_v6 = HalfspaceIntersection(halfspaces_v6, interior_pt_v6)
hull_v6 = ConvexHull(hs_v6.intersections)
boss_v6_tm = trimesh.Trimesh(vertices=hs_v6.intersections, faces=hull_v6.simplices, process=True)
boss_v6_tm.fix_normals()
boss_v6_mf = m3d.Manifold(m3d.Mesh(
    vert_properties=np.array(boss_v6_tm.vertices, dtype=np.float32),
    tri_verts=np.array(boss_v6_tm.faces, dtype=np.uint32)
))
mf_v6 = mf_base + boss_v6_mf
tm_v6 = manifold_to_trimesh(mf_v6)
v6_path = os.path.join(out_dir, "Drawer_Vase_v6_Outward_Closed_Bar_Handle_14mm.stl")
tm_v6.export(v6_path)
print("Saved v6:", v6_path, "Watertight:", tm_v6.is_watertight, "Bounds:", tm_v6.bounds.tolist(), "Extents:", tm_v6.extents)

for name, tm in [("v5_Outward_Pocket", tm_v5), ("v6_Outward_Closed_Bar", tm_v6)]:
    bad_z = []
    for z in np.linspace(0.5, 72.5, 73):
        s = tm.section(plane_origin=[0, 0, z], plane_normal=[0, 0, 1])
        s2d, _ = s.to_2D()
        polys = s2d.polygons_full
        if len(polys) != 1 or len(polys[0].interiors) != 0:
            bad_z.append((z, len(polys)))
    print(f"Check {name}: {len(bad_z)} problematic layers out of 73.", bad_z)
