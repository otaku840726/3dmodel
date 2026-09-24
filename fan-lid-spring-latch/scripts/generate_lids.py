import manifold3d
import trimesh
import numpy as np

# 1. Load original STL
orig_mesh = trimesh.load('lid.stl')
components = orig_mesh.split()
c0 = components[0] # Base (Comp 0)
c1 = components[1] # Lid (Comp 1)

print("Original Comp 0 bounds:", c0.bounds)
print("Original Comp 1 bounds:", c1.bounds)

# Convert Comp 1 to Manifold
vp1 = np.ascontiguousarray(c1.vertices, dtype=np.float32)
tv1 = np.ascontiguousarray(c1.faces, dtype=np.uint32)
m1 = manifold3d.Manifold(manifold3d.Mesh(vert_properties=vp1, tri_verts=tv1))

# Design Parameters
slot_w = 1.2    # Slit width in mm
tab_w = 16.0    # Tab width in mm
y_c = -70.0     # Center of latch along Y
x_inner = 35.0  # Slit extends to X=35.0 (leaves 5mm solid frame to opening at X=30)
x_outer = 57.0  # Slit extends beyond outer wing (X=55.1)
x_len = x_outer - x_inner
x_center = (x_outer + x_inner) / 2.0
z_cut_h = 24.0  # Full height cut
z_cut_c = 10.0

y_s1 = y_c - tab_w/2.0 - slot_w/2.0
y_s2 = y_c + tab_w/2.0 + slot_w/2.0

# 1. Slit cutters
slit_p1 = manifold3d.Manifold.cube([x_len, slot_w, z_cut_h], center=True).translate([x_center, y_s1, z_cut_c])
slit_p2 = manifold3d.Manifold.cube([x_len, slot_w, z_cut_h], center=True).translate([x_center, y_s2, z_cut_c])
slit_n1 = manifold3d.Manifold.cube([x_len, slot_w, z_cut_h], center=True).translate([-x_center, y_s1, z_cut_c])
slit_n2 = manifold3d.Manifold.cube([x_len, slot_w, z_cut_h], center=True).translate([-x_center, y_s2, z_cut_c])

# Stress relief cylinder at inner end
relief_r = slot_w / 2.0 # 0.6 mm radius
cyl_p1 = manifold3d.Manifold.cylinder(z_cut_h, relief_r, relief_r, 20).translate([x_inner, y_s1, -2.0])
cyl_p2 = manifold3d.Manifold.cylinder(z_cut_h, relief_r, relief_r, 20).translate([x_inner, y_s2, -2.0])
cyl_n1 = manifold3d.Manifold.cylinder(z_cut_h, relief_r, relief_r, 20).translate([-x_inner, y_s1, -2.0])
cyl_n2 = manifold3d.Manifold.cylinder(z_cut_h, relief_r, relief_r, 20).translate([-x_inner, y_s2, -2.0])

all_cutters = slit_p1 + slit_p2 + slit_n1 + slit_n2 + cyl_p1 + cyl_p2 + cyl_n1 + cyl_n2
m_slotted = m1 - all_cutters

# 2. Lead-in chamfer for tooth (at Z=2.0 to 3.2, X from 47.1 to 48.6)
tri_pts = [[47.1, 2.0], [48.6, 2.0], [48.6, 3.2]]
cs_chamfer = manifold3d.CrossSection([tri_pts])
m_chamfer_raw = manifold3d.Manifold.extrude(cs_chamfer, tab_w)

transform_chamfer_p = [
    [1.0, 0.0, 0.0, 0.0],
    [0.0, 0.0, 1.0, y_c - tab_w/2.0],
    [0.0, 1.0, 0.0, 0.0]
]
chamfer_p = m_chamfer_raw.transform(transform_chamfer_p)

transform_chamfer_n = [
    [-1.0, 0.0, 0.0, 0.0],
    [0.0, 0.0, 1.0, y_c - tab_w/2.0],
    [0.0, 1.0, 0.0, 0.0]
]
chamfer_n = m_chamfer_raw.transform(transform_chamfer_n)

# Model 1: Flush spring tab version (Height = 16.5 mm)
m_flush = m_slotted + chamfer_p + chamfer_n

# Model 2: Raised thumb press tab version (Height = 19.0 mm, +2.5 mm extension with beveled top)
pts_thumb = [
    [48.6, 16.5],
    [50.1, 16.5],
    [50.1, 18.5],
    [49.7, 19.0],
    [49.0, 19.0],
    [48.6, 18.5]
]
cs_thumb = manifold3d.CrossSection([pts_thumb])
m_thumb_raw = manifold3d.Manifold.extrude(cs_thumb, tab_w)

transform_thumb_p = [
    [1.0, 0.0, 0.0, 0.0],
    [0.0, 0.0, 1.0, y_c - tab_w/2.0],
    [0.0, 1.0, 0.0, 0.0]
]
thumb_p = m_thumb_raw.transform(transform_thumb_p)

transform_thumb_n = [
    [-1.0, 0.0, 0.0, 0.0],
    [0.0, 0.0, 1.0, y_c - tab_w/2.0],
    [0.0, 1.0, 0.0, 0.0]
]
thumb_n = m_thumb_raw.transform(transform_thumb_n)

m_raised = m_flush + thumb_p + thumb_n

# Function to convert manifold to trimesh
def to_trimesh(m):
    mesh_data = m.to_mesh()
    return trimesh.Trimesh(
        vertices=mesh_data.vert_properties,
        faces=mesh_data.tri_verts,
        process=True
    )

mesh_flush = to_trimesh(m_flush)
mesh_raised = to_trimesh(m_raised)

print("Flush version:")
print("  Watertight:", mesh_flush.is_watertight)
print("  Bounds:", mesh_flush.bounds)
print("  Volume:", mesh_flush.volume)

print("Raised thumb tab version (Recommended):")
print("  Watertight:", mesh_raised.is_watertight)
print("  Bounds:", mesh_raised.bounds)
print("  Volume:", mesh_raised.volume)

# Export individual lids
mesh_flush.export('lid_spring_flush.stl')
mesh_raised.export('lid_spring_raised_thumb.stl')

# Combine with Comp 0 to produce complete kits matching the original 2-body structure of 蓋子9.stl
kit_flush = trimesh.util.concatenate([c0, mesh_flush])
kit_raised = trimesh.util.concatenate([c0, mesh_raised])

kit_flush.export('lid_kit_flush.stl')
kit_raised.export('lid_kit_raised_thumb.stl')

# Also save user-friendly named files in Traditional Chinese
mesh_raised.export('蓋子_彈片加高按壓版_單件.stl')
mesh_flush.export('蓋子_彈片齊平版_單件.stl')
kit_raised.export('蓋子9_彈片加高版_含底座完整套件.stl')
kit_flush.export('蓋子9_彈片齊平版_含底座完整套件.stl')

print("\nSuccessfully generated all STL files!")
