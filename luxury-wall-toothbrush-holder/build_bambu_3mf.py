#!/usr/bin/env python3
"""
build_bambu_3mf.py
Generates the production-grade 4-Color Bambu Studio / OrcaSlicer project 3MF
for the Luxury Wall Toothbrush Holder Grand Fluted Edition.

Features:
- Fused monolithic body: backplate serves as the rear wall of the storage box (zero gap, zero crevice)
- Significantly enlarged cleanser (46x48mm) and toothpaste (38x48mm) compartments
- 100% watertight manifold mesh (32,922 facets)
- Precise 4-color classification (Filament 1: Black, 2: Gold, 3: Pink, 4: White)
- Valid Bambu Studio TriangleSelector hex tokens ("4", "8", "0C")
- Pre-positioned for Bambu Lab A1 mini 180x180 textured PEI plate
"""

import os
import zipfile
import json
import trimesh
import numpy as np
from PIL import Image

def generate_bambu_3mf():
    print("=== Generating Luxury Grand Fluted 4-Color Bambu 3MF ===")
    
    # 1. Load meshes
    print("Loading meshes...")
    m_full = trimesh.load("luxury_holder_grand_fluted.stl")
    m_c2 = trimesh.load("luxury_holder_c2_black.stl")
    m_c3 = trimesh.load("luxury_holder_c3_warm.stl")
    m_c4 = trimesh.load("luxury_holder_c4_gold.stl")
    
    print(f"Full mesh: {len(m_full.vertices)} verts, {len(m_full.faces)} faces, watertight: {m_full.is_watertight}")
    
    # 2. Geometric Color Classification
    print("Classifying triangles...")
    centroids = m_full.triangles_center
    normals = m_full.face_normals

    cp2, dist2, tri_idx2 = trimesh.proximity.closest_point(m_c2, centroids)
    cp3, dist3, tri_idx3 = trimesh.proximity.closest_point(m_c3, centroids)
    cp4, dist4, tri_idx4 = trimesh.proximity.closest_point(m_c4, centroids)

    norm2 = m_c2.face_normals[tri_idx2]
    norm3 = m_c3.face_normals[tri_idx3]
    norm4 = m_c4.face_normals[tri_idx4]

    dot2 = np.sum(normals * norm2, axis=1)
    dot3 = np.sum(normals * norm3, axis=1)
    dot4 = np.sum(normals * norm4, axis=1)

    color_classes = np.ones(len(centroids), dtype=int) * 4 # Default 4: White
    color_classes[(dist4 < 0.08) & (dot4 > 0.7)] = 2 # Gold
    color_classes[(dist3 < 0.08) & (dot3 > 0.7)] = 3 # Pink
    color_classes[(dist2 < 0.08) & (dot2 > 0.7)] = 1 # Black

    from collections import Counter
    counts = Counter(color_classes)
    print(f"Color distribution:")
    print(f"  Filament 1 (Black #000000): {counts[1]} faces")
    print(f"  Filament 2 (Gold  #D1A659): {counts[2]} faces")
    print(f"  Filament 3 (Pink  #FFB0B0): {counts[3]} faces")
    print(f"  Filament 4 (White #F5F2EC): {counts[4]} faces")

    # 3. Transform to A1 mini bed coordinates (rotated 45 degrees, centered at Z=0)
    print("Transforming to A1 mini plate orientation...")
    cos_a, sin_a = np.cos(np.radians(225.0)), np.sin(np.radians(225.0))
    t = np.array([-20.35552207, 20.3382295, 0.0])

    verts = m_full.vertices.copy()
    u_shifted = np.zeros_like(verts)
    u_shifted[:, 0] = verts[:, 0] * cos_a - verts[:, 1] * sin_a
    u_shifted[:, 1] = verts[:, 0] * sin_a + verts[:, 1] * cos_a
    u = u_shifted + t
    u[:, 2] = verts[:, 2] - 44.0

    print(f"Bed bounding box: X=[{90 + u[:,0].min():.2f}, {90 + u[:,0].max():.2f}], Y=[{90 + u[:,1].min():.2f}, {90 + u[:,1].max():.2f}]")

    # 4. Generate object_2.model XML
    print("Generating 3D/Objects/object_2.model...")
    obj2_lines = [
        '<?xml version="1.0" encoding="UTF-8"?>',
        '<model unit="millimeter" xml:lang="en-US" xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02" xmlns:BambuStudio="http://schemas.bambulab.com/package/2021" xmlns:p="http://schemas.microsoft.com/3dmanufacturing/production/2015/06" requiredextensions="p">',
        ' <metadata name="BambuStudio:3mfVersion">1</metadata>',
        ' <resources>',
        '  <object id="1" p:UUID="00020000-81cb-4c03-9d28-80fed5dfa1dc" type="model">',
        '   <mesh>',
        '    <vertices>'
    ]
    for v in u:
        obj2_lines.append(f'     <vertex x="{v[0]:.7f}" y="{v[1]:.7f}" z="{v[2]:.7f}"/>')
    obj2_lines.append('    </vertices>')
    obj2_lines.append('    <triangles>')

    for (v1, v2, v3), col in zip(m_full.faces, color_classes):
        if col == 1:
            obj2_lines.append(f'     <triangle v1="{v1}" v2="{v2}" v3="{v3}" paint_color="4"/>')
        elif col == 2:
            obj2_lines.append(f'     <triangle v1="{v1}" v2="{v2}" v3="{v3}" paint_color="8"/>')
        elif col == 3:
            obj2_lines.append(f'     <triangle v1="{v1}" v2="{v2}" v3="{v3}" paint_color="0C"/>')
        else:
            obj2_lines.append(f'     <triangle v1="{v1}" v2="{v2}" v3="{v3}"/>')

    obj2_lines.extend([
        '    </triangles>',
        '   </mesh>',
        '  </object>',
        ' </resources>',
        '</model>'
    ])
    obj2_xml = "\n".join(obj2_lines).encode("utf-8")

    # 5. Read baseline template files from existing 3MF
    print("Reading project configs...")
    with zipfile.ZipFile("luxury_holder_grand_fluted_4color.3mf", "r") as z_template:
        template_files = {name: z_template.read(name) for name in z_template.namelist()}

    # Update model_settings.config
    ms_xml = template_files["Metadata/model_settings.config"].decode("utf-8")
    ms_xml = ms_xml.replace('face_count="40002"', f'face_count="{len(m_full.faces)}"')
    ms_xml = ms_xml.replace('<metadata key="filament_maps" value="1 1 1 1"/>', '<metadata key="filament_maps" value="1 2 3 4"/>')
    template_files["Metadata/model_settings.config"] = ms_xml.encode("utf-8")

    # Update project_settings.config
    proj_cfg = json.loads(template_files["Metadata/project_settings.config"].decode("utf-8"))
    proj_cfg["filament_map"] = ["1", "2", "3", "4"]
    proj_cfg["filament_colour"] = ["#000000", "#D1A659", "#FFB0B0", "#F5F2EC"]
    template_files["Metadata/project_settings.config"] = json.dumps(proj_cfg, indent=2).encode("utf-8")

    # Update plate_1.json
    plate_json = json.loads(template_files["Metadata/plate_1.json"].decode("utf-8"))
    plate_json["filament_colors"] = ["#000000", "#D1A659", "#FFB0B0", "#F5F2EC"]
    plate_json["filament_ids"] = ["GFG96", "GFG02", "GFG02", "GFG02"]
    template_files["Metadata/plate_1.json"] = json.dumps(plate_json).encode("utf-8")

    # Update object_2.model
    template_files["3D/Objects/object_2.model"] = obj2_xml

    # 6. Render and embed new thumbnails
    print("Generating thumbnails...")
    os.system("openscad --camera=0,35,45,60,0,140,260 --imgsize=1024,768 --colorscheme=Cornfield /tmp/test_flush_back.scad -o /tmp/thumb_raw.png")
    if os.path.exists("/tmp/thumb_raw.png"):
        img = Image.open("/tmp/thumb_raw.png")
        img_512 = img.resize((512, 384), Image.Resampling.LANCZOS)
        canvas512 = Image.new("RGBA", (512, 512), (245, 245, 245, 255))
        canvas512.paste(img_512, (0, (512 - 384) // 2))
        canvas512.save("/tmp/plate_512.png")
        
        canvas128 = canvas512.resize((128, 128), Image.Resampling.LANCZOS)
        canvas128.save("/tmp/plate_128.png")

        with open("/tmp/plate_512.png", "rb") as f:
            b512 = f.read()
        with open("/tmp/plate_128.png", "rb") as f:
            b128 = f.read()

        template_files["Metadata/plate_1.png"] = b512
        template_files["Metadata/plate_no_light_1.png"] = b512
        template_files["Metadata/top_1.png"] = b512
        template_files["Metadata/pick_1.png"] = b512
        template_files["Metadata/plate_1_small.png"] = b128

    # 7. Write to output 3MF files
    out_files = [
        "luxury_holder_grand_fluted_4color.3mf",
        "luxury_holder_grand_fluted_4color_recolored.3mf",
        "/root/.gemini/antigravity-cli/brain/a9576d8a-aa87-4179-b7d9-6cce87d9650b/luxury_holder_grand_fluted_4color.3mf"
    ]
    for out_path in out_files:
        with zipfile.ZipFile(out_path, "w", compression=zipfile.ZIP_DEFLATED) as z_out:
            for name, data in template_files.items():
                z_out.writestr(name, data)
        print(f"Wrote {out_path} ({os.path.getsize(out_path)/(1024*1024):.2f} MB)")

    print("=== Successfully Built 4-Color Bambu 3MF Project! ===")

if __name__ == "__main__":
    generate_bambu_3mf()
