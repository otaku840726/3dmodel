import manifold3d
import trimesh
import numpy as np

# 1. Load original STL
orig_mesh = trimesh.load('lid.stl')
components = orig_mesh.split()
c0 = components[0] # Base
c1 = components[1] # Original Lid

print("Original Comp 0 bounds:", c0.bounds)
print("Original Comp 1 bounds:", c1.bounds)

vp1 = np.ascontiguousarray(c1.vertices, dtype=np.float32)
tv1 = np.ascontiguousarray(c1.faces, dtype=np.uint32)
m1 = manifold3d.Manifold(manifold3d.Mesh(vert_properties=vp1, tri_verts=tv1))

y_c = -70.0 # Center of lid along Y

# Step 1: Cleanly trim away the old oversized 1.5mm tooth (X < 48.60, Z between 1.0 and 4.5)
trim_w = 24.0
trim_h = 3.5 # Z in [1.0, 4.5]
trim_box_p = manifold3d.Manifold.cube([5.0, trim_w, trim_h], center=True).translate([48.6 - 2.5, y_c, 1.0 + trim_h/2.0])
trim_box_n = manifold3d.Manifold.cube([5.0, trim_w, trim_h], center=True).translate([-(48.6 - 2.5), y_c, 1.0 + trim_h/2.0])
m1_clean = m1 - (trim_box_p + trim_box_n)

# Step 2: Parametric Spring Cutters
# Refined parameters addressing user feedback:
# 1) Reduce tab area: slit depth into floor cut reduced from 13.6mm to 3.6mm (x_inner=45.0 instead of 35.0)
# 2) Stiff, responsive cantilever arm: tab width = 12.0 mm (centered at Y=-70)
# 3) Slit width = 1.0 mm with stress-relief fillet radiuses
tab_w = 12.0
slot_w = 1.0
x_inner = 45.0  # Cut extends into floor by only 3.6mm past inner wall (leaves 15.0mm solid floor frame!)
x_outer = 56.0  # Outer edge extends cleanly past outer wall/wing
x_len = x_outer - x_inner
x_center = (x_outer + x_inner) / 2.0
z_cut_h = 24.0  # Full height vertical cut
z_cut_c = 10.0

y_s1 = y_c - tab_w/2.0 - slot_w/2.0
y_s2 = y_c + tab_w/2.0 + slot_w/2.0

slit_p1 = manifold3d.Manifold.cube([x_len, slot_w, z_cut_h], center=True).translate([x_center, y_s1, z_cut_c])
slit_p2 = manifold3d.Manifold.cube([x_len, slot_w, z_cut_h], center=True).translate([x_center, y_s2, z_cut_c])
slit_n1 = manifold3d.Manifold.cube([x_len, slot_w, z_cut_h], center=True).translate([-x_center, y_s1, z_cut_c])
slit_n2 = manifold3d.Manifold.cube([x_len, slot_w, z_cut_h], center=True).translate([-x_center, y_s2, z_cut_c])

relief_r = slot_w / 2.0
cyl_p1 = manifold3d.Manifold.cylinder(z_cut_h, relief_r, relief_r, 20).translate([x_inner, y_s1, -2.0])
cyl_p2 = manifold3d.Manifold.cylinder(z_cut_h, relief_r, relief_r, 20).translate([x_inner, y_s2, -2.0])
cyl_n1 = manifold3d.Manifold.cylinder(z_cut_h, relief_r, relief_r, 20).translate([-x_inner, y_s1, -2.0])
cyl_n2 = manifold3d.Manifold.cylinder(z_cut_h, relief_r, relief_r, 20).translate([-x_inner, y_s2, -2.0])

all_cutters = slit_p1 + slit_p2 + slit_n1 + slit_n2 + cyl_p1 + cyl_p2 + cyl_n1 + cyl_n2
m_slotted = m1_clean - all_cutters

# Step 3: Precision-engineered Catch Tooth
# Protrusion: 0.55mm inward (Apex at X = 48.05 mm)
# Net engagement with base outer wall (48.50mm): 0.45mm
# Fits perfectly within base 1.0mm chamfer (47.50 to 48.50mm)
# Winding CCW: [X, Z]
pts_tooth = [
    [48.60, 1.00], # Base at floor level
    [48.60, 3.20], # Top lead-in ramp start
    [48.05, 1.70], # Tooth apex top
    [48.05, 1.50]  # Tooth apex bottom (undercut lock angle)
]
cs_tooth = manifold3d.CrossSection([pts_tooth])
m_tooth_raw = manifold3d.Manifold.extrude(cs_tooth, tab_w)

transform_tooth_p = [
    [1.0, 0.0, 0.0, 0.0],
    [0.0, 0.0, 1.0, y_c - tab_w/2.0],
    [0.0, 1.0, 0.0, 0.0]
]
tooth_p = m_tooth_raw.transform(transform_tooth_p)

transform_tooth_n = [
    [-1.0, 0.0, 0.0, 0.0],
    [0.0, 0.0, 1.0, y_c - tab_w/2.0],
    [0.0, 1.0, 0.0, 0.0]
]
tooth_n = m_tooth_raw.transform(transform_tooth_n)

# Model 1: Flush spring tab version (Height = 16.5 mm)
m_flush = m_slotted + tooth_p + tooth_n

# Model 2: Raised thumb press tab version (Height = 19.0 mm, +2.5 mm extension with ergonomic bevel)
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

# Convert to trimesh
def to_trimesh(m):
    mesh_data = m.to_mesh()
    return trimesh.Trimesh(
        vertices=mesh_data.vert_properties,
        faces=mesh_data.tri_verts,
        process=True
    )

mesh_flush = to_trimesh(m_flush)
mesh_raised = to_trimesh(m_raised)

print("\n--- Model Verification ---")
print("Flush Tab Version:")
print("  Watertight:", mesh_flush.is_watertight)
print("  Bounds:", np.round(mesh_flush.bounds, 2))
print("  Volume:", round(mesh_flush.volume, 2))

print("Raised Thumb Tab Version (User Preferred):")
print("  Watertight:", mesh_raised.is_watertight)
print("  Bounds:", np.round(mesh_raised.bounds, 2))
print("  Volume:", round(mesh_raised.volume, 2))

# Export individual lids
mesh_flush.export('lid_spring_flush.stl')
mesh_raised.export('lid_spring_raised_thumb.stl')

# Combine with Comp 0 to produce complete kits matching the original 2-body structure of 蓋子9.stl
kit_flush = trimesh.util.concatenate([c0, mesh_flush])
kit_raised = trimesh.util.concatenate([c0, mesh_raised])

kit_flush.export('lid_kit_flush.stl')
kit_raised.export('lid_kit_raised_thumb.stl')

# Save Traditional Chinese named copies
mesh_raised.export('蓋子_彈片加高按壓版_單件.stl')
mesh_flush.export('蓋子_彈片齊平版_單件.stl')
kit_raised.export('蓋子9_彈片加高版_含底座完整套件.stl')
kit_flush.export('蓋子9_彈片齊平版_含底座完整套件.stl')

print("\nSuccessfully generated all refined STL files!")
