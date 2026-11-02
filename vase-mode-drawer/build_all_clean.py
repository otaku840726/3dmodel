import os
import struct
import numpy as np
import trimesh

out_dir = "/root/3dmodel/vase-mode-drawer"
os.makedirs(out_dir, exist_ok=True)

def write_clean_binary_stl(mesh: trimesh.Trimesh, path: str, header_str: str = "MW 1.0 3322546 US"):
    mesh.merge_vertices()
    mesh.update_faces(mesh.nondegenerate_faces())
    mesh.update_faces(mesh.unique_faces())
    mesh.remove_unreferenced_vertices()
    mesh.fix_normals()
    
    assert mesh.is_watertight, f"{path} is not watertight!"
    assert mesh.is_winding_consistent, f"{path} winding not consistent!"
    assert mesh.is_volume, f"{path} is not a valid volume!"
    
    header = header_str.encode('ascii')[:80].ljust(80, b'\x00')
    faces = mesh.faces
    verts = mesh.vertices
    normals = mesh.face_normals
    
    with open(path, 'wb') as f:
        f.write(header)
        f.write(struct.pack('<I', len(faces)))
        for i, face in enumerate(faces):
            n = normals[i]
            v0, v1, v2 = verts[face[0]], verts[face[1]], verts[face[2]]
            f.write(struct.pack('<12fH',
                float(n[0]), float(n[1]), float(n[2]),
                float(v0[0]), float(v0[1]), float(v0[2]),
                float(v1[0]), float(v1[1]), float(v1[2]),
                float(v2[0]), float(v2[1]), float(v2[2]),
                0
            ))
    angles = np.degrees(trimesh.triangles.angles(mesh.triangles))
    print(f"Saved {os.path.basename(path)}: verts={len(verts)}, faces={len(faces)}, watertight={mesh.is_watertight}, min_ang={angles.min():.2f}°, max_ang={angles.max():.2f}°")

# ==============================================================================
# Version 1: Pure Solid (12 vertices, 20 triangles)
# ==============================================================================
v1_verts = np.array([
    [-104.5, -110.5,  0.0], # 0
    [ 104.5, -110.5,  0.0], # 1
    [ 104.5,   89.5,  0.0], # 2
    [  94.5,   99.5,  0.0], # 3
    [ -94.5,   99.5,  0.0], # 4
    [-104.5,   89.5,  0.0], # 5
    [-104.5, -110.5, 73.0], # 6
    [ 104.5, -110.5, 73.0], # 7
    [ 104.5,   89.5, 73.0], # 8
    [  94.5,   99.5, 73.0], # 9
    [ -94.5,   99.5, 73.0], # 10
    [-104.5,   89.5, 73.0], # 11
], dtype=np.float64)

v1_faces = np.array([
    # Bottom (Z=0)
    [0, 5, 2], [0, 2, 1], [5, 4, 3], [5, 3, 2],
    # Top (Z=73)
    [6, 8, 11], [6, 7, 8], [11, 9, 10], [11, 8, 9],
    # Walls
    [0, 6, 11], [0, 11, 5],
    [5, 11, 10], [5, 10, 4],
    [4, 10, 9], [4, 9, 3],
    [3, 9, 8], [3, 8, 2],
    [2, 8, 7], [2, 7, 1],
    [1, 7, 6], [1, 6, 0],
], dtype=np.int64)
tm_v1 = trimesh.Trimesh(vertices=v1_verts, faces=v1_faces, process=False)
write_clean_binary_stl(tm_v1, os.path.join(out_dir, "Drawer_Vase_v1_Pure_Solid.stl"))

# ==============================================================================
# Helper for Inward-Recessed Groove/Handle (v2: depth=1.5mm, v3: depth=12.0mm)
# Exact 20-vertex hand-triangulated polyhedron (zero boolean slivers!)
# ==============================================================================
def build_clean_inward_recess(depth: float, filename: str):
    x_bot = 35.5
    x_top = 59.0
    # Use exact clean planar side walls:
    # Let the recessed inner face at Y = -110.5 + depth have:
    #   At Z = 53.0: X = +-(x_bot - depth)
    #   At Z = 73.0: X = +-(x_top - depth)
    # And on the outer front wall Y = -110.5:
    #   At Z = 73.0: X = +-x_top
    #   At Z = 53.0 - depth (bottom of 45-deg ramp):
    #     To keep the side wall 100% planar, the vector from (x_bot - depth, -110.5 + depth, 53.0) to (x_top - depth, -110.5 + depth, 73.0)
    #     is dX = x_top - x_bot, dY = 0, dZ = 20.0 (slope s = (x_top - x_bot)/20.0).
    #     And the vector from (x_bot - depth, -110.5 + depth, 53.0) to (x_top, -110.5, 73.0)
    #     is dX = x_top - x_bot + depth, dY = -depth, dZ = 20.0.
    #     So on that exact plane, at Y = -110.5 and Z = 53.0 - depth:
    #     X = x_bot - s * depth!
    s = (x_top - x_bot) / 20.0
    x_ramp_bot = round(x_bot - s * depth, 4)
    x_in_bot = round(x_bot - depth, 4)
    x_in_top = round(x_top - depth, 4)
    y_in = round(-110.5 + depth, 4)
    z_ramp_bot = round(53.0 - depth, 4)

    verts = np.array([
        [-104.5, -110.5,  0.0], # 0
        [ 104.5, -110.5,  0.0], # 1
        [ 104.5,   89.5,  0.0], # 2
        [  94.5,   99.5,  0.0], # 3
        [ -94.5,   99.5,  0.0], # 4
        [-104.5,   89.5,  0.0], # 5
        [-104.5, -110.5, 73.0], # 6
        [ -x_top, -110.5, 73.0], # 7
        [ -x_in_top, y_in, 73.0], # 8
        [  x_in_top, y_in, 73.0], # 9
        [  x_top, -110.5, 73.0], # 10
        [ 104.5, -110.5, 73.0], # 11
        [ 104.5,   89.5, 73.0], # 12
        [  94.5,   99.5, 73.0], # 13
        [ -94.5,   99.5, 73.0], # 14
        [-104.5,   89.5, 73.0], # 15
        [ -x_ramp_bot, -110.5, z_ramp_bot], # 16
        [  x_ramp_bot, -110.5, z_ramp_bot], # 17
        [ -x_in_bot, y_in, 53.0], # 18
        [  x_in_bot, y_in, 53.0], # 19
    ], dtype=np.float64)

    faces = np.array([
        # Bottom (Z=0)
        [0, 5, 2], [0, 2, 1], [5, 4, 3], [5, 3, 2],
        # Top (Z=73): polygon is [6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
        [6, 7, 15], [7, 8, 15], [8, 14, 15],
        [8, 9, 14], [9, 13, 14],
        [9, 12, 13], [9, 10, 12], [10, 11, 12],
        # Outer walls (Left, Back-Left, Back, Back-Right, Right)
        [0, 6, 15], [0, 15, 5],
        [5, 15, 14], [5, 14, 4],
        [4, 14, 13], [4, 13, 3],
        [3, 13, 12], [3, 12, 2],
        [2, 12, 11], [2, 11, 1],
        # Front wall (Y = -110.5): polygon [0, 1, 11, 10, 17, 16, 7, 6]
        [0, 16, 6], [16, 7, 6],
        [0, 1, 16], [1, 17, 16],
        [1, 11, 17], [17, 11, 10],
        # Recess bottom 45-deg ramp [16, 17, 19, 18]
        [16, 17, 19], [16, 19, 18],
        # Recess left wall [16, 18, 8, 7]
        [16, 18, 8], [16, 8, 7],
        # Recess right wall [17, 10, 9, 19]
        [17, 10, 9], [17, 9, 19],
        # Recess back wall [18, 19, 9, 8]
        [18, 19, 9], [18, 9, 8],
    ], dtype=np.int64)
    tm = trimesh.Trimesh(vertices=verts, faces=faces, process=False)
    write_clean_binary_stl(tm, os.path.join(out_dir, filename))
    return tm

build_clean_inward_recess(1.5, "Drawer_Vase_v2_Shallow_Groove_1.5mm.stl")
build_clean_inward_recess(12.0, "Drawer_Vase_v3_Recessed_Handle_12mm.stl")

# ==============================================================================
# Version 5: Outward Top-Open Pocket Handle (+14mm) - Exact 20 vertices, 36 triangles
# ==============================================================================
v5_faces_sym = np.array([
    # Bottom (Z=0)
    [0, 5, 2], [0, 2, 1], [5, 4, 3], [5, 3, 2],
    # Top (Z=73)
    [6, 7, 15], [7, 14, 15], [7, 10, 14], [10, 13, 14], [10, 12, 13], [10, 11, 12],
    [7, 8, 9], [7, 9, 10],
    # Outer walls
    [0, 6, 15], [0, 15, 5],
    [5, 15, 14], [5, 14, 4],
    [4, 14, 13], [4, 13, 3],
    [3, 13, 12], [3, 12, 2],
    [2, 12, 11], [2, 11, 1],
    # Front wall (Y=-110.5)
    [0, 16, 6], [16, 7, 6],
    [0, 1, 16], [1, 17, 16],
    [1, 11, 17], [17, 11, 10],
    # Outward handle faces
    [16, 17, 19], [16, 19, 18],
    [16, 18, 8], [16, 8, 7],
    [17, 10, 9], [17, 9, 19],
    [18, 19, 9], [18, 9, 8],
], dtype=np.int64)

v5_verts = np.array([
    [-104.5, -110.5,  0.0], # 0
    [ 104.5, -110.5,  0.0], # 1
    [ 104.5,   89.5,  0.0], # 2
    [  94.5,   99.5,  0.0], # 3
    [ -94.5,   99.5,  0.0], # 4
    [-104.5,   89.5,  0.0], # 5
    [-104.5, -110.5, 73.0], # 6
    [ -52.0, -110.5, 73.0], # 7
    [ -38.0, -124.5, 73.0], # 8
    [  38.0, -124.5, 73.0], # 9
    [  52.0, -110.5, 73.0], # 10
    [ 104.5, -110.5, 73.0], # 11
    [ 104.5,   89.5, 73.0], # 12
    [  94.5,   99.5, 73.0], # 13
    [ -94.5,   99.5, 73.0], # 14
    [-104.5,   89.5, 73.0], # 15
    [ -52.0, -110.5, 39.0], # 16
    [  52.0, -110.5, 39.0], # 17
    [ -38.0, -124.5, 53.0], # 18
    [  38.0, -124.5, 53.0], # 19
], dtype=np.float64)
tm_v5 = trimesh.Trimesh(vertices=v5_verts, faces=v5_faces_sym, process=False)
write_clean_binary_stl(tm_v5, os.path.join(out_dir, "Drawer_Vase_v5_Outward_Pocket_Handle_14mm.stl"))

# ==============================================================================
# Version 6: Outward Self-Closed Bar Handle (+14mm) - Exact 20 vertices, 36 triangles
# ==============================================================================
v6_verts = np.array([
    [-104.5, -110.5,  0.0], # 0
    [ 104.5, -110.5,  0.0], # 1
    [ 104.5,   89.5,  0.0], # 2
    [  94.5,   99.5,  0.0], # 3
    [ -94.5,   99.5,  0.0], # 4
    [-104.5,   89.5,  0.0], # 5
    [-104.5, -110.5, 73.0], # 6
    [ 104.5, -110.5, 73.0], # 7
    [ 104.5,   89.5, 73.0], # 8
    [  94.5,   99.5, 73.0], # 9
    [ -94.5,   99.5, 73.0], # 10
    [-104.5,   89.5, 73.0], # 11
    # Handle base on Y = -110.5:
    [ -55.0, -110.5, 35.0], # 12 (bottom-left)
    [  55.0, -110.5, 35.0], # 13 (bottom-right)
    [  55.0, -110.5, 71.0], # 14 (top-right)
    [ -55.0, -110.5, 71.0], # 15 (top-left)
    # Handle outer face on Y = -124.5:
    [ -41.0, -124.5, 49.0], # 16 (bottom-left)
    [  41.0, -124.5, 49.0], # 17 (bottom-right)
    [  41.0, -124.5, 57.0], # 18 (top-right)
    [ -41.0, -124.5, 57.0], # 19 (top-left)
], dtype=np.float64)

v6_faces = np.array([
    # Bottom (Z=0)
    [0, 5, 2], [0, 2, 1], [5, 4, 3], [5, 3, 2],
    # Top (Z=73)
    [6, 8, 11], [6, 7, 8], [11, 9, 10], [11, 8, 9],
    # Side & Back walls
    [0, 6, 11], [0, 11, 5],
    [5, 11, 10], [5, 10, 4],
    [4, 10, 9], [4, 9, 3],
    [3, 9, 8], [3, 8, 2],
    [2, 8, 7], [2, 7, 1],
    # Front wall around handle [12, 13, 14, 15] inside [0, 1, 7, 6]:
    [0, 1, 13], [0, 13, 12],
    [1, 7, 14], [1, 14, 13],
    [7, 6, 15], [7, 15, 14],
    [6, 0, 12], [6, 12, 15],
    # Handle 5 faces:
    [12, 13, 17], [12, 17, 16], # Bottom 45-deg slope
    [16, 17, 18], [16, 18, 19], # Front vertical face
    [19, 18, 14], [19, 14, 15], # Top 45-deg roof slope
    [12, 16, 19], [12, 19, 15], # Left 45-deg slope
    [13, 14, 18], [13, 18, 17], # Right 45-deg slope
], dtype=np.int64)
tm_v6 = trimesh.Trimesh(vertices=v6_verts, faces=v6_faces, process=False)
write_clean_binary_stl(tm_v6, os.path.join(out_dir, "Drawer_Vase_v6_Outward_Closed_Bar_Handle_14mm.stl"))

# Also rewrite v4 header cleanly
tm_v4 = trimesh.load(os.path.join(out_dir, "Drawer_Vase_v4_DoubleWall_Open_Notch.stl"), process=True)
write_clean_binary_stl(tm_v4, os.path.join(out_dir, "Drawer_Vase_v4_DoubleWall_Open_Notch.stl"))
