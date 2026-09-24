#!/bin/bash
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCAD="$DIR/luxury_wall_toothbrush_holder.scad"
RENDERS="$DIR/renders"
mkdir -p "$RENDERS"

echo "1. Rendering 3 Styles Side-by-Side Comparison..."
openscad --csglimit=1000000 --camera=0,45,40,58,0,195,1200 --imgsize=1600,900 --colorscheme=Cornfield \
    -D 'mode="all_styles"' -o "$RENDERS/rose_gold_3styles_comparison.png" "$SCAD"

echo "2. Rendering Assembled Perspectives with User's Real Toothbrush Setup..."
openscad --csglimit=1000000 --camera=0,65,30,62,0,210,480 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="faceted"' -D 'mode="assembled"' -o "$RENDERS/faceted_assembled_perspective.png" "$SCAD"

openscad --csglimit=1000000 --camera=0,65,30,62,0,210,480 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="assembled"' -o "$RENDERS/fluted_assembled_perspective.png" "$SCAD"

openscad --csglimit=1000000 --camera=0,65,30,62,0,210,480 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="curved"' -D 'mode="assembled"' -o "$RENDERS/curved_assembled_perspective.png" "$SCAD"

echo "3. Rendering Multi-Angle Clean Architectural Views (Art Deco Faceted)..."
openscad --render --csglimit=1000000 --camera=0,65,65,45,0,205,320 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="faceted"' -D 'mode="holder"' -o "$RENDERS/faceted_crystalline_top.png" "$SCAD"

openscad --render --csglimit=1000000 --camera=0,65,-10,125,0,210,480 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="faceted"' -D 'mode="holder"' -o "$RENDERS/faceted_crystalline_bottom.png" "$SCAD"

openscad --render --csglimit=1000000 --camera=75,50,45,90,0,90,260 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="faceted"' -D 'mode="holder"' -o "$RENDERS/faceted_crystalline_side.png" "$SCAD"

openscad --render --csglimit=1000000 --camera=0,65,40,90,0,180,300 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="faceted"' -D 'mode="holder"' -o "$RENDERS/faceted_crystalline_front.png" "$SCAD"

openscad --render --csglimit=1000000 --camera=-60,75,55,60,0,225,400 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="faceted"' -D 'mode="holder"' -o "$RENDERS/faceted_crystalline_iso_front.png" "$SCAD"

echo "4. Rendering Standalone Toothbrush Rack..."
openscad --render --csglimit=1000000 --camera=-40,65,35,60,0,225,280 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="faceted"' -D 'mode="standalone_toothbrush"' -o "$RENDERS/standalone_toothbrush_rack.png" "$SCAD"

echo "5. Rendering Wall Bracket Detail..."
openscad --render --csglimit=1000000 --camera=0,22,5,55,0,45,150 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="bracket"' -o "$RENDERS/wall_bracket_mounting.png" "$SCAD"

echo "6. Rendering 1-Plate Combo Print Bed Layout (Faceted Edition)..."
openscad --render --csglimit=1000000 --camera=0,65,45,60,0,205,420 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="faceted"' -D 'mode="plate"' -o "$RENDERS/print_bed_layout.png" "$SCAD"

echo "All renders completed successfully!"
