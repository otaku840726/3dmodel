import manifold3d
import trimesh
import numpy as np

# 1. Load original STL
orig_mesh = trimesh.load('lid.stl')
components = orig_mesh.split()
c0 = components[0] # Base
c1 = components[1] # Original Lid

vp1 = np.ascontiguousarray(c1.vertices, dtype=np.float32)
tv1 = np.ascontiguousarray(c1.faces, dtype=np.uint32)
m1 = manifold3d.Manifold(manifold3d.Mesh(vert_properties=vp1, tri_verts=tv1))

y_c = -70.0 # Center of lid along Y

# Step 1: Cleanly trim away any old catch teeth/hooks at bottom (X < 48.60, Z in [0.0, 5.5])
# User: "我們不需要卡筍... 你那凸出的卡筍是多餘的" -> 100% removed!
trim_w = 26.0
trim_h = 5.0
trim_box_p = manifold3d.Manifold.cube([5.0, trim_w, trim_h], center=True).translate([48.6 - 2.5, y_c, 1.0 + trim_h/2.0])
trim_box_n = manifold3d.Manifold.cube([5.0, trim_w, trim_h], center=True).translate([-(48.6 - 2.5), y_c, 1.0 + trim_h/2.0])
m1_clean = m1 - (trim_box_p + trim_box_n)

# Step 2: Spring Tab on Lateral Wall (將彈片維持在側面就好)
# Width = 12.0 mm, slit width = 1.0 mm
# Slit cuts through vertical wall thickness (X in [47.5, 56.0])
# Bottom plate (X < 47.5) remains solid (>91% continuous rigid frame)
tab_w = 12.0
slot_w = 1.0
x_inner = 47.5
x_outer = 56.0
x_len = x_outer - x_inner
x_center = (x_outer + x_inner) / 2.0
z_cut_h = 24.0
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

# Step 3: Inner Wall Biting Teeth at Base Contact Zone (Z in [12.2, 16.5])
# User: "底版的六角柱是面向一個有凹槽的牆面。底版安裝到牆面後。蓋子蓋上。最多齊平而已... 咬合的齒位子太低"
# The base plate is at the open rim of the lid (Z in [12.5, 16.5] mm)!
# Biting teeth are positioned right where the base plate outer wall sits (Z in [12.5, 16.5] mm)!
# Protrusion: 0.30mm (apex at X = 48.30 mm, net interference with 48.50mm base wall = 0.20mm)
# 4 horizontal biting ridges + 45° entry lead-in ramp
pts_ribs_top = [
    [48.60, 12.20], # Bottom root on flat inner wall
    [48.60, 16.48], # Open rim
    [48.30, 16.20], # Top lead-in ramp apex
    # Tooth 4
    [48.30, 16.00],
    [48.55, 15.60], # Valley 3
    # Tooth 3
    [48.30, 15.20],
    [48.30, 15.00],
    [48.55, 14.50], # Valley 2
    # Tooth 2
    [48.30, 14.10],
    [48.30, 13.90],
    [48.55, 13.40], # Valley 1
    # Tooth 1
    [48.30, 13.00],
    [48.30, 12.80]
]

cs_ribs = manifold3d.CrossSection([pts_ribs_top])
m_ribs_raw = manifold3d.Manifold.extrude(cs_ribs, tab_w)

transform_ribs_p = [
    [1.0, 0.0, 0.0, 0.0],
    [0.0, 0.0, 1.0, y_c - tab_w/2.0],
    [0.0, 1.0, 0.0, 0.0]
]
ribs_p = m_ribs_raw.transform(transform_ribs_p)

transform_ribs_n = [
    [-1.0, 0.0, 0.0, 0.0],
    [0.0, 0.0, 1.0, y_c - tab_w/2.0],
    [0.0, 1.0, 0.0, 0.0]
]
ribs_n = m_ribs_raw.transform(transform_ribs_n)

# Flush Model (Height = 16.5 mm)
m_flush = m_slotted + ribs_p + ribs_n

# Raised Thumb Tab Version (+2.5mm extension with ergonomic bevel)
pts_thumb = [
    [48.55, 16.45],
    [50.15, 16.45],
    [50.10, 18.50],
    [49.70, 19.00],
    [49.00, 19.00],
    [48.60, 18.50]
]
cs_thumb = manifold3d.CrossSection([pts_thumb])
m_thumb_raw = manifold3d.Manifold.extrude(cs_thumb, tab_w)
thumb_p = m_thumb_raw.transform(transform_ribs_p)
thumb_n = m_thumb_raw.transform(transform_ribs_n)

m_raised = m_flush + thumb_p + thumb_n

def to_trimesh(m):
    mesh_data = m.to_mesh()
    return trimesh.Trimesh(
        vertices=mesh_data.vert_properties,
        faces=mesh_data.tri_verts,
        process=True
    )

mesh_flush = to_trimesh(m_flush)
mesh_raised = to_trimesh(m_raised)

print("\n--- Final Model Verification ---")
print("Flush Tab Version:")
print("  Watertight:", mesh_flush.is_watertight)
print("  Bounds:", np.round(mesh_flush.bounds, 2))
print("  Volume:", round(mesh_flush.volume, 2))

print("Raised Thumb Tab Version:")
print("  Watertight:", mesh_raised.is_watertight)
print("  Bounds:", np.round(mesh_raised.bounds, 2))
print("  Volume:", round(mesh_raised.volume, 2))

# Export STL files
mesh_flush.export('lid_spring_flush.stl')
mesh_raised.export('lid_spring_raised_thumb.stl')

# Combine with Comp 0 to produce complete kits
kit_flush = trimesh.util.concatenate([c0, mesh_flush])
kit_raised = trimesh.util.concatenate([c0, mesh_raised])

kit_flush.export('lid_kit_flush.stl')
kit_raised.export('lid_kit_raised_thumb.stl')

mesh_raised.export('蓋子_彈片加高按壓版_單件.stl')
mesh_flush.export('蓋子_彈片齊平版_單件.stl')
kit_raised.export('蓋子9_彈片加高版_含底座完整套件.stl')
kit_flush.export('蓋子9_彈片齊平版_含底座完整套件.stl')

print("\nSuccessfully generated all refined models!")
