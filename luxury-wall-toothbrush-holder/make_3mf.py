import trimesh
import zipfile
import xml.etree.ElementTree as ET
import os

def create_3mf(stl_files, out_3mf, colors, names):
    print(f"Creating {out_3mf} from {len(stl_files)} color bodies...")
    
    # Load meshes
    meshes = []
    for f in stl_files:
        print(f"  Loading {f}...")
        m = trimesh.load(f)
        meshes.append(m)
        
    # Build 3dmodel.model XML
    lines = [
        '<?xml version="1.0" encoding="UTF-8"?>',
        '<model unit="millimeter" xml:lang="en-US" xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02" xmlns:m="http://schemas.microsoft.com/3dmanufacturing/material/2015/02">',
        '  <metadata name="Title">Luxury Wall Toothbrush Holder 4-Color</metadata>',
        '  <metadata name="Designer">Antigravity Design Team</metadata>',
        '  <resources>',
        '    <m:colorgroup id="1">'
    ]
    for c in colors:
        lines.append(f'      <m:color color="{c}"/>')
    lines.append('    </m:colorgroup>')
    
    # Add each object
    for idx, (m, name) in enumerate(zip(meshes, names)):
        obj_id = idx + 2
        lines.append(f'    <object id="{obj_id}" name="{name}" type="model" pid="1" pindex="{idx}">')
        lines.append('      <mesh>')
        lines.append('        <vertices>')
        for v in m.vertices:
            lines.append(f'          <vertex x="{v[0]:.4f}" y="{v[1]:.4f}" z="{v[2]:.4f}"/>')
        lines.append('        </vertices>')
        lines.append('        <triangles>')
        for f in m.faces:
            lines.append(f'          <triangle v1="{f[0]}" v2="{f[1]}" v3="{f[2]}"/>')
        lines.append('        </triangles>')
        lines.append('      </mesh>')
        lines.append('    </object>')
        
    # Group component object
    group_id = len(meshes) + 2
    lines.append(f'    <object id="{group_id}" name="Luxury_Holder_Grand_Fluted_4Color" type="model">')
    lines.append('      <components>')
    for idx in range(len(meshes)):
        obj_id = idx + 2
        lines.append(f'        <component objectid="{obj_id}"/>')
    lines.append('      </components>')
    lines.append('    </object>')
    lines.append('  </resources>')
    lines.append('  <build>')
    lines.append(f'    <item objectid="{group_id}"/>')
    lines.append('  </build>')
    lines.append('</model>')
    
    model_xml = "\n".join(lines)
    
    content_types = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">\n'
        '  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>\n'
        '  <Default Extension="model" ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml"/>\n'
        '</Types>'
    )
    
    rels = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">\n'
        '  <Relationship Target="/3D/3dmodel.model" Id="rel0" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/>\n'
        '</Relationships>'
    )
    
    with zipfile.ZipFile(out_3mf, 'w', compression=zipfile.ZIP_DEFLATED) as zf:
        zf.writestr('[Content_Types].xml', content_types)
        zf.writestr('_rels/.rels', rels)
        zf.writestr('3D/3dmodel.model', model_xml)
        
    print(f"SUCCESS: {out_3mf} created! Size: {os.path.getsize(out_3mf)/(1024*1024):.2f} MB")

if __name__ == "__main__":
    stls = [
        "luxury_holder_c1_body.stl",
        "luxury_holder_c2_black.stl",
        "luxury_holder_c3_warm.stl",
        "luxury_holder_c4_gold.stl"
    ]
    colors = [
        "#F5F2ECFF", # Color 1: Pearl Warm White
        "#242429FF", # Color 2: Obsidian Black
        "#EFA694FF", # Color 3: Coral Peach Pink
        "#D1A659FF"  # Color 4: Champagne Gold
    ]
    names = [
        "Filament1_PearlWhite_Body",
        "Filament2_CharcoalBlack_Features",
        "Filament3_PeachPink_Accents",
        "Filament4_ChampagneGold_Trim"
    ]
    create_3mf(stls, "luxury_holder_grand_fluted_4color.3mf", colors, names)
