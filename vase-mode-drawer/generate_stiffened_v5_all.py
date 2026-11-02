import os
import numpy as np
import trimesh
import manifold3d as m3d

out_dir = "/root/3dmodel/vase-mode-drawer"
os.makedirs(out_dir, exist_ok=True)

def save_ascii_stl(mesh: trimesh.Trimesh, path: str):
    mesh.merge_vertices()
    mesh.update_faces(mesh.nondegenerate_faces())
    mesh.update_faces(mesh.unique_faces())
    mesh.remove_unreferenced_vertices()
    mesh.fix_normals()
    
    assert mesh.is_watertight, f"{path} is not watertight!"
    assert mesh.is_winding_consistent, f"{path} winding is not consistent!"
    assert mesh.is_volume, f"{path} is not a valid volume!"
    
    ascii_str = trimesh.exchange.stl.export_stl_ascii(mesh)
    with open(path, 'w', encoding='ascii') as f:
        f.write(ascii_str)
    print(f"Saved ASCII STL: {os.path.basename(path)} | verts={len(mesh.vertices)}, faces={len(mesh.faces)}, size={os.path.getsize(path)//1024}KB, bounds={np.round(mesh.bounds, 2).tolist()}")

def make_inward_rib_frustum_y_wall(x_center: float, half_w_outer: float, depth: float, z_bot: float, z_top: float, y_wall: float, inward_dir: float):
    u_out = -1.0
    u_in  = depth
    y_out = y_wall + inward_dir * u_out
    y_in  = y_wall + inward_dir * u_in
    
    hw_out = half_w_outer - u_out
    hw_in  = half_w_outer - u_in
    
    zb_out = z_bot + u_out
    zb_in  = z_bot + u_in
    
    if z_top <= 73.0:
        zt_out = z_top - u_out
        zt_in  = z_top - u_in
    else:
        zt_out = 76.0
        zt_in  = 76.0

    verts = np.array([
        [x_center - hw_out, y_out, zb_out],
        [x_center + hw_out, y_out, zb_out],
        [x_center + hw_out, y_out, zt_out],
        [x_center - hw_out, y_out, zt_out],
        [x_center - hw_in,  y_in,  zb_in],
        [x_center + hw_in,  y_in,  zb_in],
        [x_center + hw_in,  y_in,  zt_in],
        [x_center - hw_in,  y_in,  zt_in],
    ], dtype=np.float32)
    
    faces = np.array([
        [0, 3, 2], [0, 2, 1],
        [4, 5, 6], [4, 6, 7],
        [0, 1, 5], [0, 5, 4],
        [1, 2, 6], [1, 6, 5],
        [2, 3, 7], [2, 7, 6],
        [3, 0, 4], [3, 4, 7],
    ], dtype=np.uint32)
    tm = trimesh.Trimesh(vertices=verts, faces=faces, process=True)
    tm.fix_normals()
    return m3d.Manifold(m3d.Mesh(vert_properties=np.array(tm.vertices, dtype=np.float32), tri_verts=np.array(tm.faces, dtype=np.uint32)))

def make_inward_rib_frustum_x_wall(y_center: float, half_w_outer: float, depth: float, z_bot: float, z_top: float, x_wall: float, inward_dir: float):
    u_out = -1.0
    u_in  = depth
    x_out = x_wall + inward_dir * u_out
    x_in  = x_wall + inward_dir * u_in
    
    hw_out = half_w_outer - u_out
    hw_in  = half_w_outer - u_in
    
    zb_out = z_bot + u_out
    zb_in  = z_bot + u_in
    
    if z_top <= 73.0:
        zt_out = z_top - u_out
        zt_in  = z_top - u_in
    else:
        zt_out = 76.0
        zt_in  = 76.0

    verts = np.array([
        [x_out, y_center - hw_out, zb_out],
        [x_out, y_center + hw_out, zb_out],
        [x_out, y_center + hw_out, zt_out],
        [x_out, y_center - hw_out, zt_out],
        [x_in,  y_center - hw_in,  zb_in],
        [x_in,  y_center + hw_in,  zb_in],
        [x_in,  y_center + hw_in,  zt_in],
        [x_in,  y_center - hw_in,  zt_in],
    ], dtype=np.float32)
    
    faces = np.array([
        [0, 3, 2], [0, 2, 1],
        [4, 5, 6], [4, 6, 7],
        [0, 1, 5], [0, 5, 4],
        [1, 2, 6], [1, 6, 5],
        [2, 3, 7], [2, 7, 6],
        [3, 0, 4], [3, 4, 7],
    ], dtype=np.uint32)
    tm = trimesh.Trimesh(vertices=verts, faces=faces, process=True)
    tm.fix_normals()
    return m3d.Manifold(m3d.Mesh(vert_properties=np.array(tm.vertices, dtype=np.float32), tri_verts=np.array(tm.faces, dtype=np.uint32)))

def manifold_to_trimesh(mf):
    mesh = mf.to_mesh()
    verts = np.array(mesh.vert_properties)[:, :3]
    faces = np.array(mesh.tri_verts)
    return trimesh.Trimesh(vertices=verts, faces=faces, process=True)

tm_v5_base = trimesh.load(os.path.join(out_dir, "Drawer_Vase_v5_Outward_Pocket_Handle_14mm_ASCII.stl"), process=True)
mf_v5_base = m3d.Manifold(m3d.Mesh(
    vert_properties=np.array(tm_v5_base.vertices, dtype=np.float32),
    tri_verts=np.array(tm_v5_base.faces, dtype=np.uint32)
))

# Common container rib layout (7 ribs on Back, Left, Right; 4 flanking + 3 lower + 1 handle-front on Front):
# Depth = 3.5 mm (increases effective wall thickness from 0.7mm to 4.2mm -> ~25x bending stiffness!)
# Outer half-width = 7.0 mm (14mm wide opening, 45-deg side walls -> 7.0mm flat inner face)
v_depth = 3.5
v_hw = 7.0

def add_vertical_container_ribs(mf, z_top_val):
    # Back wall (Y = 99.5, X in [-94.5, 94.5]): 7 ribs at X = -72, -48, -24, 0, 24, 48, 72
    for xc in [-72.0, -48.0, -24.0, 0.0, 24.0, 48.0, 72.0]:
        mf = mf - make_inward_rib_frustum_y_wall(xc, v_hw, v_depth, 3.0, z_top_val, 99.5, -1.0)
    # Left & Right walls (X = +-104.5, Y in [-110.5, 89.5], center = -10.5): 7 ribs at Y = -82.5, -58.5, -34.5, -10.5, 13.5, 37.5, 61.5
    for yc in [-82.5, -58.5, -34.5, -10.5, 13.5, 37.5, 61.5]:
        mf = mf - make_inward_rib_frustum_x_wall(yc, v_hw, v_depth, 3.0, z_top_val, -104.5, 1.0)
        mf = mf - make_inward_rib_frustum_x_wall(yc, v_hw, v_depth, 3.0, z_top_val,  104.5, -1.0)
    # Front wall flanking the handle (X in [-104.5, -52.0] and [52.0, 104.5]): 2 ribs per side at X = -88, -66, +66, +88
    for xc in [-88.0, -66.0, 66.0, 88.0]:
        mf = mf - make_inward_rib_frustum_y_wall(xc, v_hw, v_depth, 3.0, z_top_val, -110.5, 1.0)
    # Front wall below the handle (X in [-52.0, +52.0], Z = 3.0 to 36.0): 3 ribs at X = -32, 0, +32
    for xc in [-32.0, 0.0, 32.0]:
        mf = mf - make_inward_rib_frustum_y_wall(xc, v_hw, v_depth, 3.0, 36.0, -110.5, 1.0)
    # Outward handle front face (Y = -124.5, X in [-38, +38], Z = 55.0 to z_top_val): 1 central rib at X = 0
    mf = mf - make_inward_rib_frustum_y_wall(0.0, 8.0, 2.5, 55.0, z_top_val, -124.5, 1.0)
    return mf

# ==============================================================================
# Version 5A: Classic Shipping Container Vertical Ribs (Boxed at Z=3..70mm, Flat Top Rim Z=70..73mm)
# ==============================================================================
mf_5a = add_vertical_container_ribs(mf_v5_base, 70.0)
tm_5a = manifold_to_trimesh(mf_5a)
path_5a = os.path.join(out_dir, "Drawer_Vase_v5A_Container_Ribs_ASCII.stl")
save_ascii_stl(tm_5a, path_5a)

# ==============================================================================
# Version 5B: Through-Top Shipping Container Vertical Ribs (Runs all the way through Z=73mm top edge)
# ==============================================================================
mf_5b = add_vertical_container_ribs(mf_v5_base, 76.0)
tm_5b = manifold_to_trimesh(mf_5b)
path_5b = os.path.join(out_dir, "Drawer_Vase_v5B_Container_ThroughTop_ASCII.stl")
save_ascii_stl(tm_5b, path_5b)

# ==============================================================================
# Version 5C: Orthogonal Waffle Container Grid (3.5mm Vertical Columns + 2.0mm Horizontal Belts at Z=24, 46, 66)
# ==============================================================================
mf_5c = add_vertical_container_ribs(mf_v5_base, 70.0)
h_depth = 2.0
# Three horizontal stiffening belts at Z = [22..29], [44..51], [63..70]
for zb, zt in [(22.0, 29.0), (44.0, 51.0)]:
    # Back wall
    mf_5c = mf_5c - make_inward_rib_frustum_y_wall(0.0, 88.0, h_depth, zb, zt, 99.5, -1.0)
    # Left & Right walls
    mf_5c = mf_5c - make_inward_rib_frustum_x_wall(-10.5, 92.0, h_depth, zb, zt, -104.5, 1.0)
    mf_5c = mf_5c - make_inward_rib_frustum_x_wall(-10.5, 92.0, h_depth, zb, zt,  104.5, -1.0)
    # Front wall flanking handle
    for xc in [-77.0, 77.0]:
        mf_5c = mf_5c - make_inward_rib_frustum_y_wall(xc, 23.0, h_depth, zb, zt, -110.5, 1.0)
# Plus 1 horizontal belt across the lower front wall at Z = [22..29]
mf_5c = mf_5c - make_inward_rib_frustum_y_wall(0.0, 92.0, h_depth, 22.0, 29.0, -110.5, 1.0)

tm_5c = manifold_to_trimesh(mf_5c)
path_5c = os.path.join(out_dir, "Drawer_Vase_v5C_Container_Grid_Plus_ASCII.stl")
save_ascii_stl(tm_5c, path_5c)

# Verify Vase Mode single-loop requirement across all 73 layers!
for name, tm in [("v5A_Container_Ribs", tm_5a), ("v5B_Container_ThroughTop", tm_5b), ("v5C_Container_Grid_Plus", tm_5c)]:
    bad_z = []
    for z in np.linspace(0.5, 72.5, 73):
        s = tm.section(plane_origin=[0, 0, z], plane_normal=[0, 0, 1])
        s2d, _ = s.to_2D()
        polys = s2d.polygons_full
        if len(polys) != 1 or len(polys[0].interiors) != 0:
            bad_z.append((z, len(polys)))
    print(f"Vase Mode Check {name}: {len(bad_z)} bad layers / 73.", bad_z)
