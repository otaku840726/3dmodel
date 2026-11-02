import os
import numpy as np
import trimesh
import manifold3d as m3d
from shapely.geometry import Polygon

out_dir = "/root/3dmodel/vase-mode-drawer"
os.makedirs(out_dir, exist_ok=True)

# Original parameters:
# X: [-104.5, 104.5] (209.0 mm)
# Y: [-110.5, 99.5]  (210.0 mm)
# Back chamfers: 10x10 mm at Y=99.5, X=+-104.5 -> (+-94.5, 99.5) to (+-104.5, 89.5)
# Z: shifted from [6.0, 79.0] to [0.0, 73.0] (height = 73.0 mm)
# Front notch: Z_orig in [59.0, 79.0] -> Z in [53.0, 73.0]
#   At Z=53.0: X in [-35.3047, 35.3047]
#   At Z=73.0: X in [-59.1398, 59.1398]

outer_pts = [
    (-104.5, -110.5),
    ( 104.5, -110.5),
    ( 104.5,   89.5),
    (  94.5,   99.5),
    ( -94.5,   99.5),
    (-104.5,   89.5),
]

def manifold_to_trimesh(mf):
    mesh = mf.to_mesh()
    verts = np.array(mesh.vert_properties)[:, :3]
    faces = np.array(mesh.tri_verts)
    tm = trimesh.Trimesh(vertices=verts, faces=faces, process=True)
    return tm

# ==============================================================================
# Version 1: Pure Solid Outer Block (完全封閉實心體)
# ==============================================================================
cs_outer = m3d.CrossSection([outer_pts])
mf_v1 = m3d.Manifold.extrude(cs_outer, 73.0)
tm_v1 = manifold_to_trimesh(mf_v1)
v1_path = os.path.join(out_dir, "Drawer_Vase_v1_Pure_Solid.stl")
tm_v1.export(v1_path)
print("Saved v1:", v1_path, "Watertight:", tm_v1.is_watertight, "Extents:", tm_v1.extents)

# ==============================================================================
# Helper to build recessed front notch solid (used for v2 and v3)
# For a given recess depth `d`:
#   - Below Z = 53.0 - d: recess depth is 0 (full outer polygon)
#   - From Z = 53.0 - d to Z = 53.0: recess depth ramps linearly from 0 to d (45 deg overhang)
#   - From Z = 53.0 to Z = 73.0: recess depth is constant `d`
#   - At any Z where current depth is `cur_d > 0`:
#     The front outer edge at Y = -110.5 has half-width `x_front(Z)`:
#       For Z >= 53.0: x_front(Z) = 35.3047 + (59.1398 - 35.3047) * (Z - 53.0) / 20.0
#       For Z < 53.0:  x_front(Z) = 35.3047 - (53.0 - Z) * (59.1398 - 35.3047) / 20.0 (or constant 35.3047 on outer face)
#     Wait: if we keep the outer face notch bottom edge at Z = 53.0 - d (or Z = 53.0), let's make sure the 3D cutter is a clean convex polyhedron!
# ==============================================================================
def build_recessed_version(depth, filename):
    # Let's construct the recessed solid by slicing or convex hull / lofting exact layers,
    # OR subtracting a clean 6-vertex prism/frustum cutter from mf_v1!
    # Let's check: if we subtract a convex polyhedron cutter from mf_v1:
    # What are the vertices of the cutter so that:
    # 1. On the front plane Y = -110.5:
    #    - At Z = 53.0: X in [-x_bot, +x_bot] where x_bot = 35.3047
    #    - At Z = 73.0: X in [-x_top, +x_top] where x_top = 59.1398
    #    - Bottom ramp starts at Z = 53.0 - depth on Y = -110.5, with X in [-(x_bot - depth), +(x_bot - depth)]
    # 2. On the recessed plane Y = -110.5 + depth:
    #    - At Z = 53.0: X in [-(x_bot - depth), +(x_bot - depth)]
    #    - At Z = 73.0: X in [-(x_top - depth), +(x_top - depth)]
    # Wait: let's check if the side planes and bottom ramp plane meet cleanly!
    # Look at the 4 corners on Z = 53.0 and Z = 73.0:
    # In the plane Z = 53.0:
    #   Front edge (Y = -110.5): X = +- x_bot
    #   Back edge (Y = -110.5 + depth): X = +- (x_bot - depth)
    # In the plane Z = 73.0:
    #   Front edge (Y = -110.5): X = +- x_top
    #   Back edge (Y = -110.5 + depth): X = +- (x_top - depth)
    # Notice that the vector along the top-to-bottom of the side edge on Y = -110.5 is:
    #   dX = x_top - x_bot = 23.8351, dY = 0, dZ = 20.0
    # And on Y = -110.5 + depth:
    #   dX = (x_top - depth) - (x_bot - depth) = 23.8351, dY = 0, dZ = 20.0!
    # They are PARALLEL! So each side wall of the groove is a PERFECT PLANAR QUAD!
    # Now what about the bottom ramp from Z = 53.0 (at Y = -110.5 + depth) down to Z = 53.0 - depth (at Y = -110.5)?
    # Along the side wall planar equation:
    #   x - y - (x_bot + 110.5) = slope * (z - 53.0), where slope = 23.8351 / 20.0
    # At Y = -110.5 and Z = 53.0 - depth:
    #   x_ramp_bot = x_bot - slope * depth!
    # Let's check that! If at (Y = -110.5, Z = 53.0 - depth), X = +- (x_bot - slope * depth),
    # then that point lies ON the exact same side plane AND on the 45-degree bottom ramp plane (Y - (-110.5) = Z - (53.0 - depth))!
    # Let's verify: at Z = 53.0, Y = -110.5 + depth, the point on the side plane has:
    #   X = x_bot - depth.
    # At Z = 53.0 - depth, Y = -110.5, the point on BOTH the side plane and the front face Y = -110.5 has:
    #   X = x_bot - slope * depth!
    # Since both (x_bot - depth, -110.5 + depth, 53.0) and (x_bot - slope*depth, -110.5, 53.0 - depth) lie on the plane Y + 110.5 = Z - (53.0 - depth),
    # the bottom ramp is ALSO A PERFECT PLANAR TRAPZEOID at an exact 45-degree angle in Y-Z!
    
    x_bot = 35.3047
    x_top = 59.1398
    slope = (x_top - x_bot) / 20.0
    y0 = -110.5
    y_eps = -111.5 # extend 1mm forward in -Y for clean boolean subtraction
    
    # Instead of boolean with epsilon, we can construct the exact cutter with points at Y = y0 - 1.0 to Y = y0 + depth
    # Or even simpler: take the convex hull of the 6 exact points on [y0, y0+depth] plus their extensions to y0 - 1.0!
    pts = [
        # At Z = 73.0 + 1.0 (extend 1mm above top for clean cut? No, exact Z=73.0 orhull with Z=73)
        # Let's use exact Z slices or convex hull of cutter!
    ]
    # Wait: since the cutter is a single convex polyhedron, let's check if all 6 vertices on y0..y0+depth form a convex hull!
    # On plane Y + 110.5 = Z - (53.0 - depth) (the 45-deg bottom ramp plane),
    # the cutter is bounded by:
    # 1. Y >= -111.0 (front extension)
    # 2. Y <= -110.5 + depth (back wall of recess)
    # 3. Z <= 74.0 (top extension)
    # 4. Y - Z <= -110.5 - (53.0 - depth)  --> Z >= Y + 110.5 + 53.0 - depth (45-deg bottom ramp)
    # 5. Right side plane: X + (Y + 110.5) - slope * (Z - 53.0) <= x_bot
    # 6. Left side plane: -X + (Y + 110.5) - slope * (Z - 53.0) <= x_bot
    # Look how clean that is! The cutter is the intersection of 6 half-spaces (a convex polyhedron)!
    from scipy.spatial import HalfspaceIntersection, ConvexHull
    # Halfspaces in scipy are A x + b <= 0
    # Variables: [x, y, z]
    halfspaces = np.array([
        [ 0.0, -1.0,  0.0, -111.0],                                   # -y - 111.0 <= 0  => y >= -111.0
        [ 0.0,  1.0,  0.0,  110.5 - depth],                           # y + 110.5 - depth <= 0 => y <= -110.5 + depth
        [ 0.0,  0.0,  1.0, -74.0],                                    # z - 74.0 <= 0 => z <= 74.0
        [ 0.0,  1.0, -1.0,  110.5 + 53.0 - depth],                    # y - z + 110.5 + 53.0 - depth <= 0
        [ 1.0,  1.0, -slope, 110.5 + slope * 53.0 - x_bot],           # x + y + 110.5 - slope*(z - 53) - x_bot <= 0
        [-1.0,  1.0, -slope, 110.5 + slope * 53.0 - x_bot],           # -x + y + 110.5 - slope*(z - 53) - x_bot <= 0
    ])
    interior_pt = np.array([0.0, -110.5 + depth * 0.5, 65.0])
    hs = HalfspaceIntersection(halfspaces, interior_pt)
    hull = ConvexHull(hs.intersections)
    cutter_tm = trimesh.Trimesh(vertices=hs.intersections, faces=hull.simplices, process=True)
    cutter_tm.fix_normals()
    cutter_mf = m3d.Manifold(m3d.Mesh(
        vert_properties=np.array(cutter_tm.vertices, dtype=np.float32),
        tri_verts=np.array(cutter_tm.faces, dtype=np.uint32)
    ))
    res_mf = mf_v1 - cutter_mf
    res_tm = manifold_to_trimesh(res_mf)
    out_path = os.path.join(out_dir, filename)
    res_tm.export(out_path)
    print(f"Saved {filename}: Watertight={res_tm.is_watertight}, Extents={res_tm.extents}")
    return res_tm

tm_v2 = build_recessed_version(1.5, "Drawer_Vase_v2_Shallow_Groove_1.5mm.stl")
tm_v3 = build_recessed_version(12.0, "Drawer_Vase_v3_Recessed_Handle_12mm.stl")

# ==============================================================================
# Version 4: Double-Wall Vase Mode with Original Open Notch & 0.15mm Front Micro-Seam
# ==============================================================================
orig_path = '/root/.gemini/antigravity-cli/brain/937d36ba-9653-4326-86de-314a018538f5/.user_uploaded/media_1793526817006_8904b6f0.stl'
tm_orig = trimesh.load(orig_path)
# Shift Z by -6.0 so base is at Z = 0.0
tm_orig.apply_translation([0.0, 0.0, -6.0])

mf_orig = m3d.Manifold(m3d.Mesh(
    vert_properties=np.array(tm_orig.vertices, dtype=np.float32),
    tri_verts=np.array(tm_orig.faces, dtype=np.uint32)
))

# Cut a 0.15mm micro-seam at X in [-0.075, +0.075], Y in [-111.0, -104.0], Z in [2.0, 53.5]
# Wait: between Z=2.0 and Z=5.0 (orig Z=8.0 to 11.0), the inner bottom fillet curves from Y=-105.5 to Y=-108.5.
# Extending the cutter to Y = -104.0 ensures it cleanly connects the outer wall (Y=-110.5) to the inner cavity all the way down to Z=2.0!
seam_half = 0.075 # 0.15mm total gap
cs_seam = m3d.CrossSection([[
    (-seam_half, -111.0),
    ( seam_half, -111.0),
    ( seam_half, -104.0),
    (-seam_half, -104.0),
]])
mf_seam = m3d.Manifold.extrude(cs_seam, 52.0).translate([0.0, 0.0, 2.0])
mf_v4 = mf_orig - mf_seam
tm_v4 = manifold_to_trimesh(mf_v4)
v4_path = os.path.join(out_dir, "Drawer_Vase_v4_DoubleWall_Open_Notch.stl")
tm_v4.export(v4_path)
print("Saved v4:", v4_path, "Watertight:", tm_v4.is_watertight, "Extents:", tm_v4.extents)

# Verify cross-sections for all 4 models across Z from 0.5 to 72.5
for name, tm in [("v1_Pure_Solid", tm_v1), ("v2_Shallow_Groove", tm_v2), ("v3_Recessed_Handle", tm_v3), ("v4_DoubleWall_Open_Notch", tm_v4)]:
    bad_z = []
    for z in np.linspace(0.5, 72.5, 73):
        s = tm.section(plane_origin=[0, 0, z], plane_normal=[0, 0, 1])
        s2d, _ = s.to_2D()
        polys = s2d.polygons_full
        if len(polys) != 1 or len(polys[0].interiors) != 0:
            bad_z.append((z, len(polys), [len(p.interiors) for p in polys]))
    print(f"Check {name}: {len(bad_z)} problematic layers out of 73.", bad_z[:5])
