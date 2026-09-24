import manifold3d
import trimesh
import numpy as np
import os
import shutil
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection

# Set font for matplotlib
plt.rcParams['font.sans-serif'] = ['Noto Sans CJK TC', 'DejaVu Sans']
plt.rcParams['axes.unicode_minus'] = False

artifact_dir = "/root/.gemini/antigravity-cli/brain/1c2fd7b6-b6e4-4429-bc18-4a3b25b5bbfb"
repo_dir = "/root/.gemini/antigravity-cli/scratch/repo_3dmodel/fan-lid-spring-latch"

# 1. Load original STL
orig_mesh = trimesh.load('lid.stl')
components = orig_mesh.split()
c0 = components[0] # Base
c1 = components[1] # Original Lid

vp1 = np.ascontiguousarray(c1.vertices, dtype=np.float32)
tv1 = np.ascontiguousarray(c1.faces, dtype=np.uint32)
m1 = manifold3d.Manifold(manifold3d.Mesh(vert_properties=vp1, tri_verts=tv1))

y_c = -70.0 # Center of lid along Y

# Step 1: Clean bottom catch teeth cleanly
trim_w = 26.0
trim_h = 5.0
trim_box_p = manifold3d.Manifold.cube([5.0, trim_w, trim_h], center=True).translate([48.6 - 2.5, y_c, 1.0 + trim_h/2.0])
trim_box_n = manifold3d.Manifold.cube([5.0, trim_w, trim_h], center=True).translate([-(48.6 - 2.5), y_c, 1.0 + trim_h/2.0])
m1_clean = m1 - (trim_box_p + trim_box_n)

# Step 2: Precision narrow slit (slot_w = 0.5 mm)
# User: "彈片的縫要小。然後手把的左右側有多餘的突起"
# 1. Slit narrowed from 1.0mm down to 0.5mm (clean precision clearance gap)
# 2. Rectangular cut through full wall thickness eliminates the jagged sliver spikes to the left and right of handle
tab_w = 12.0
slot_w = 0.5

x_inner = 44.0
x_outer = 56.0
x_len = x_outer - x_inner
x_center = (x_outer + x_inner) / 2.0

y_s1 = y_c - tab_w/2.0 - slot_w/2.0 # -70 - 6.0 - 0.25 = -76.25
y_s2 = y_c + tab_w/2.0 + slot_w/2.0 # -70 + 6.0 + 0.25 = -63.75

z_root = 0.8
z_top = 24.0
z_h = z_top - z_root
z_c = (z_top + z_root) / 2.0

slit_box_p1 = manifold3d.Manifold.cube([x_len, slot_w, z_h], center=True).translate([x_center, y_s1, z_c])
slit_box_p2 = manifold3d.Manifold.cube([x_len, slot_w, z_h], center=True).translate([x_center, y_s2, z_c])
slit_box_n1 = manifold3d.Manifold.cube([x_len, slot_w, z_h], center=True).translate([-x_center, y_s1, z_c])
slit_box_n2 = manifold3d.Manifold.cube([x_len, slot_w, z_h], center=True).translate([-x_center, y_s2, z_c])

all_cutters = slit_box_p1 + slit_box_p2 + slit_box_n1 + slit_box_n2
m_slotted = m1_clean - all_cutters

# Step 3: Flush Model Tab Profile (100% Solid, 5 biting teeth, 45° self-supporting transitions)
pts_flush_tab = [
    [50.10, 16.50], # Outer top rim
    [50.10, 11.80], # Outer wall
    [48.60, 11.80], # Bottom root on flat inner wall
    [48.25, 12.15], # Tooth 1 entry ramp (45° self-supporting)
    [48.25, 12.50], # Tooth 1 apex plateau (0.25mm net interference with 48.50mm base wall)
    [48.55, 12.80], # Valley 1
    [48.25, 13.10], # Tooth 2
    [48.25, 13.40],
    [48.55, 13.70], # Valley 2
    [48.25, 14.00], # Tooth 3
    [48.25, 14.30],
    [48.55, 14.60], # Valley 3
    [48.25, 14.90], # Tooth 4
    [48.25, 15.20],
    [48.55, 15.50], # Valley 4
    [48.25, 15.80], # Tooth 5
    [48.25, 16.10],
    [48.60, 16.45], # 45° top lead-in ramp
    [48.60, 16.50]
][::-1]

cs_flush = manifold3d.CrossSection([pts_flush_tab])
m_flush_tab_raw = manifold3d.Manifold.extrude(cs_flush, tab_w)

transform_ribs_p = [
    [1.0, 0.0, 0.0, 0.0],
    [0.0, 0.0, 1.0, y_c - tab_w/2.0],
    [0.0, 1.0, 0.0, 0.0]
]
transform_ribs_n = [
    [-1.0, 0.0, 0.0, 0.0],
    [0.0, 0.0, 1.0, y_c - tab_w/2.0],
    [0.0, 1.0, 0.0, 0.0]
]

flush_tab_p = m_flush_tab_raw.transform(transform_ribs_p)
flush_tab_n = m_flush_tab_raw.transform(transform_ribs_n)

m_flush = m_slotted + flush_tab_p + flush_tab_n

# Step 4: Raised Thumb Tab Model Profile (+2.5mm ergonomic thumb extension, Height = 19.0 mm)
pts_raised_tab = [
    [50.10, 16.50], # Outer rim
    [50.10, 18.30], # Outer handle wall
    [49.60, 19.00], # Outer top bevel
    [49.10, 19.00], # Inner top bevel
    [48.60, 18.30], # Inner handle wall
    [48.60, 16.50]  # Smooth join at rim level
]
cs_raised = manifold3d.CrossSection([pts_raised_tab])
m_raised_raw = manifold3d.Manifold.extrude(cs_raised, tab_w)
raised_p = m_raised_raw.transform(transform_ribs_p)
raised_n = m_raised_raw.transform(transform_ribs_n)

m_raised = m_flush + raised_p + raised_n

def to_trimesh(m):
    mesh_data = m.to_mesh()
    return trimesh.Trimesh(
        vertices=mesh_data.vert_properties,
        faces=mesh_data.tri_verts,
        process=True
    )

mesh_flush = to_trimesh(m_flush)
mesh_raised = to_trimesh(m_raised)

print("\n--- Final Model Verification v6 ---")
print("Flush Tab Version:")
print("  Watertight:", mesh_flush.is_watertight)
print("  Bounds:", np.round(mesh_flush.bounds, 2))
print("  Volume:", round(mesh_flush.volume, 2))

print("Raised Thumb Tab Version:")
print("  Watertight:", mesh_raised.is_watertight)
print("  Bounds:", np.round(mesh_raised.bounds, 2))
print("  Volume:", round(mesh_raised.volume, 2))

# Verify slices for zero gaps and zero floating elements
for name, m in [("Flush", mesh_flush), ("Raised", mesh_raised)]:
    for z in [12.0, 12.5, 13.0, 14.0, 15.0, 15.5, 15.8, 16.0, 16.2, 16.45]:
        path, _ = m.section(plane_origin=[0, -70, z], plane_normal=[0, 0, 1]).to_2D()
        polys = [p for p in path.polygons_full if p.area > 0.01]
        assert len(polys) == 4, f"Slice at Z={z} for {name} has {len(polys)} polygons instead of 4!"
    print(f"  {name}: All slices 100% solid, ZERO floating elements!")

# Combine with Comp 0 to produce complete kits
kit_flush = trimesh.util.concatenate([c0, mesh_flush])
kit_raised = trimesh.util.concatenate([c0, mesh_raised])

# Export local files
mesh_flush.export('lid_spring_flush.stl')
mesh_raised.export('lid_spring_raised_thumb.stl')
kit_flush.export('lid_kit_flush.stl')
kit_raised.export('lid_kit_raised_thumb.stl')

# Copy to artifacts directory
mesh_flush.export(f'{artifact_dir}/蓋子_彈片齊平版_單件.stl')
mesh_raised.export(f'{artifact_dir}/蓋子_彈片加高按壓版_單件.stl')
kit_flush.export(f'{artifact_dir}/蓋子9_彈片齊平版_含底座完整套件.stl')
kit_raised.export(f'{artifact_dir}/蓋子9_彈片加高版_含底座完整套件.stl')

# Copy to git repo directory
mesh_flush.export(f'{repo_dir}/fan_lid_spring_flush.stl')
mesh_raised.export(f'{repo_dir}/fan_lid_spring_raised_thumb.stl')
kit_flush.export(f'{repo_dir}/fan_lid_kit_flush.stl')
kit_raised.export(f'{repo_dir}/fan_lid_kit_raised_thumb.stl')
shutil.copy('build_v6_and_render.py', f'{repo_dir}/scripts/generate_lids.py')

print("\nSTLs successfully exported and copied!")

# ==========================================
# Generate Render Images
# ==========================================
print("\nGenerating updated render images...")

# 1. Figure: modified_details.png (4 Panels)
fig = plt.figure(figsize=(16, 13))

# Panel 1: 3D perspective of Tab
ax1 = fig.add_subplot(2, 2, 1, projection='3d')
polys_mod = mesh_raised.vertices[mesh_raised.faces]
ax1.add_collection3d(Poly3DCollection(polys_mod, facecolor='#92c5de', edgecolor='#2166ac', linewidths=0.3, alpha=0.9))
ax1.set_xlim(20, 56)
ax1.set_ylim(-92, -48)
ax1.set_zlim(-1, 21)
ax1.view_init(elev=24, azim=45)
ax1.set_title("1. 側面彈片結構：雙側 0.5mm 微縫切槽 (無多餘尖刺，純側面彈性夾持)", fontsize=11, fontweight='bold')
ax1.set_xlabel('X (mm)')
ax1.set_ylabel('Y (mm)')
ax1.set_zlabel('Z (mm)')

# Panel 2: Front Elevation View (Y vs Z)
ax2 = fig.add_subplot(2, 2, 2)
for edge in mesh_raised.edges_unique:
    pts = mesh_raised.vertices[edge]
    if (pts[:, 0] > 40).all() and (pts[:, 1] > -85).all() and (pts[:, 1] < -55).all():
        ax2.plot(pts[:, 1], pts[:, 2], 'b-', lw=0.6)
ax2.set_xlim(-85, -55)
ax2.set_ylim(-0.5, 21.0)
ax2.set_title("2. 側壁正視圖：0.5mm 精密微切縫，手把兩側完全平順無多餘突起", fontsize=11, fontweight='bold')
ax2.set_xlabel('Y (mm)')
ax2.set_ylabel('Z (mm)')
ax2.grid(True, linestyle=':', alpha=0.6)

# Panel 3: Complete 2-part kit (Bed Layout)
ax3 = fig.add_subplot(2, 2, 3, projection='3d')
polys_kit = kit_raised.vertices[kit_raised.faces]
ax3.add_collection3d(Poly3DCollection(polys_kit, facecolor='#d9d9d9', edgecolor='#444444', linewidths=0.2, alpha=0.8))
ax3.set_xlim(kit_raised.bounds[0, 0]-5, kit_raised.bounds[1, 0]+5)
ax3.set_ylim(kit_raised.bounds[0, 1]-5, kit_raised.bounds[1, 1]+5)
ax3.set_zlim(0, 22)
ax3.view_init(elev=35, azim=45)
ax3.set_title("3. 完整雙件套件：底座 + 彈片蓋子 (維持原座標佈局，可直接切片列印)", fontsize=11, fontweight='bold')
ax3.set_xlabel('X (mm)')
ax3.set_ylabel('Y (mm)')
ax3.set_zlabel('Z (mm)')

# Panel 4: Section view showing real assembly (base plate at open rim Z=12.5~16.5)
ax4 = fig.add_subplot(2, 2, 4)
c0_snap = c0.copy().apply_translation([0, -140.0, 12.5])
c1_snap = mesh_raised.copy()

sec_c0 = c0_snap.section(plane_origin=[45, -70, 14.5], plane_normal=[0, 1, 0])
sec_c1 = c1_snap.section(plane_origin=[45, -70, 14.5], plane_normal=[0, 1, 0])

if sec_c0 is not None:
    for i, e in enumerate(sec_c0.entities):
        pts = sec_c0.vertices[e.points]
        ax4.plot(pts[:, 0], pts[:, 2], 'r-', lw=2.2, label='風扇固定底座 (面向牆面安裝)' if i==0 else "")
        ax4.fill(pts[:, 0], pts[:, 2], color='red', alpha=0.18)

if sec_c1 is not None:
    for i, e in enumerate(sec_c1.entities):
        pts = sec_c1.vertices[e.points]
        ax4.plot(pts[:, 0], pts[:, 2], 'b-', lw=1.8, label='改版蓋子 (0.5mm微縫 + 實心咬合齒)' if i==0 else "")
        ax4.fill(pts[:, 0], pts[:, 2], color='blue', alpha=0.15)

# Annotations
ax4.annotate('開口端實心「咬合微齒」(Z=12.1~16.1mm)\n(5道梯形齒深咬層紋，過盈0.25mm強固夾持)',
             xy=(48.25, 14.5), xytext=(43.5, 9.8),
             arrowprops=dict(facecolor='blue', shrink=0.08, width=1.2, headwidth=6),
             fontsize=9, fontweight='bold', bbox=dict(boxstyle="round,pad=0.3", fc="#e6f2ff", ec="blue", lw=0.6))

ax4.annotate('六角柱面向凹槽牆面安裝\n(蓋子蓋上最多齊平，底座不深入蓋子內部)',
             xy=(48.5, 16.5), xytext=(44.0, 18.2),
             arrowprops=dict(facecolor='red', shrink=0.08, width=1.2, headwidth=6),
             fontsize=9, fontweight='bold', bbox=dict(boxstyle="round,pad=0.3", fc="#ffebee", ec="red", lw=0.6))

ax4.annotate('底部完全直通 (無多餘卡筍)\n(完全消除卡死阻礙，平順插拔)',
             xy=(48.6, 2.0), xytext=(44.0, 3.8),
             arrowprops=dict(facecolor='black', shrink=0.08, width=1.2, headwidth=6),
             fontsize=9, fontweight='bold', bbox=dict(boxstyle="round,pad=0.3", fc="#ffffcc", ec="gray", lw=0.6))

ax4.set_xlim(43.5, 53.0)
ax4.set_ylim(-0.5, 20.0)
ax4.set_title("4. 實際裝配咬合截面 (底座開口端齊平夾持，實體咬合無懸空，0.5mm精密微縫)", fontsize=11, fontweight='bold')
ax4.set_xlabel('X (mm)')
ax4.set_ylabel('Z (mm)')
ax4.legend(loc='lower left')
ax4.grid(True, linestyle='--', alpha=0.5)

plt.tight_layout()
fig.savefig('modified_details.png', dpi=180)
fig.savefig(f'{artifact_dir}/modified_details.png', dpi=180)
fig.savefig(f'{repo_dir}/renders/modified_details.png', dpi=180)
print("Saved modified_details.png")

# 2. Figure: comparison_closeup.png (3-Way Comparison)
fig_comp, (ax_orig, ax_v1, ax_v2) = plt.subplots(1, 3, figsize=(18, 6))

ax_orig.set_title("原版 (Original)\n剛性封閉直壁，無彈片，久用震動易脫落", fontsize=11, fontweight='bold')
for edge in c1.edges_unique:
    pts = c1.vertices[edge]
    if (pts[:, 0] > 40).all() and (pts[:, 1] > -90).all() and (pts[:, 1] < -50).all():
        ax_orig.plot(pts[:, 0], pts[:, 1], 'gray', lw=0.7)
ax_orig.set_xlim(40, 56)
ax_orig.set_ylim(-85, -55)
ax_orig.set_aspect('equal')
ax_orig.grid(True, linestyle=':', alpha=0.5)
ax_orig.set_xlabel('X (mm)')
ax_orig.set_ylabel('Y (mm)')

ax_v1.set_title("先前底扣版 (理解有誤)\n切縫過寬(1.0mm)且兩側留有突起尖刺", fontsize=11, fontweight='bold', color='#b2182b')
v1_loaded = trimesh.load('comp1_modified_v1.stl')
for edge in v1_loaded.edges_unique:
    pts = v1_loaded.vertices[edge]
    if (pts[:, 0] > 33).all() and (pts[:, 1] > -90).all() and (pts[:, 1] < -50).all():
        ax_v1.plot(pts[:, 0], pts[:, 1], '#d6604d', lw=0.7)
ax_v1.set_xlim(33, 56)
ax_v1.set_ylim(-85, -55)
ax_v1.set_aspect('equal')
ax_v1.grid(True, linestyle=':', alpha=0.5)
ax_v1.set_xlabel('X (mm)')
ax_v1.set_ylabel('Y (mm)')

ax_v2.set_title("最新改良版 (0.5mm 精密微切縫 + 去除多餘突起)\n縫隙縮小至 0.5mm，手把兩側完全平順平齊，咬合牢固", fontsize=11, fontweight='bold', color='#2166ac')
for edge in mesh_raised.edges_unique:
    pts = mesh_raised.vertices[edge]
    if (pts[:, 0] > 33).all() and (pts[:, 1] > -90).all() and (pts[:, 1] < -50).all():
        ax_v2.plot(pts[:, 0], pts[:, 1], '#2166ac', lw=0.8)
ax_v2.set_xlim(33, 56)
ax_v2.set_ylim(-85, -55)
ax_v2.set_aspect('equal')
ax_v2.grid(True, linestyle=':', alpha=0.5)
ax_v2.set_xlabel('X (mm)')
ax_v2.set_ylabel('Y (mm)')

plt.tight_layout()
fig_comp.savefig('comparison_closeup.png', dpi=180)
fig_comp.savefig(f'{artifact_dir}/comparison_closeup.png', dpi=180)
fig_comp.savefig(f'{repo_dir}/renders/comparison_closeup.png', dpi=180)
print("Saved comparison_closeup.png")

# 3. Figure: isometric_view.png
fig_iso = plt.figure(figsize=(10, 8))
ax_iso = fig_iso.add_subplot(1, 1, 1, projection='3d')
polys_raised = mesh_raised.vertices[mesh_raised.faces]
ax_iso.add_collection3d(Poly3DCollection(polys_raised, facecolor='#6baed6', edgecolor='#08519c', linewidths=0.2, alpha=0.85))
ax_iso.set_xlim(-56, 56)
ax_iso.set_ylim(-122, -18)
ax_iso.set_zlim(0, 22)
ax_iso.view_init(elev=28, azim=-125)
ax_iso.set_title("風扇蓋側面彈片咬合改良版 (0.5mm 精密微切縫，兩側平順無突起，長效咬合)", fontsize=12, fontweight='bold')
ax_iso.set_xlabel('X (mm)')
ax_iso.set_ylabel('Y (mm)')
ax_iso.set_zlabel('Z (mm)')
plt.tight_layout()
fig_iso.savefig('isometric_view.png', dpi=180)
fig_iso.savefig(f'{artifact_dir}/isometric_view.png', dpi=180)
fig_iso.savefig(f'{repo_dir}/renders/isometric_view.png', dpi=180)
print("Saved isometric_view.png")

print("\nAll tasks in build_v6 completed successfully!")
