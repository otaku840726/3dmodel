#!/bin/bash
set -e
DIR="/root/.gemini/antigravity-cli/scratch/3dmodel/luxury-wall-toothbrush-holder"
SCAD="$DIR/luxury_wall_toothbrush_holder.scad"
RENDERS="$DIR/renders"
mkdir -p "$RENDERS"

echo "Rendering 3 Styles Comparison..."
openscad --csglimit=1000000 --camera=0,30,15,60,0,195,1350 --imgsize=1600,900 --colorscheme=Cornfield \
    -D 'mode="all_styles"' -o "$RENDERS/rose_gold_3styles_comparison.png" "$SCAD"

echo "Rendering Fluted Assembled Perspective (Front-Release Action)..."
openscad --csglimit=1000000 --camera=0,40,15,58,0,205,560 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="assembled"' -o "$RENDERS/fluted_assembled_perspective.png" "$SCAD"

echo "Rendering Curved Assembled Perspective..."
openscad --csglimit=1000000 --camera=0,40,15,58,0,205,560 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="curved"' -D 'mode="assembled"' -o "$RENDERS/curved_assembled_perspective.png" "$SCAD"

echo "Rendering Faceted Assembled Perspective..."
openscad --csglimit=1000000 --camera=0,40,15,58,0,205,560 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="faceted"' -D 'mode="assembled"' -o "$RENDERS/faceted_assembled_perspective.png" "$SCAD"

echo "Rendering Front Tier Multi-Angle Crystalline Views..."
openscad --csglimit=1000000 --camera=0,50,110,35,0,25,320 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_top.png" "$SCAD"

openscad --csglimit=1000000 --camera=0,65,-10,125,0,210,350 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_bottom.png" "$SCAD"

openscad --csglimit=1000000 --camera=65,45,30,90,0,90,260 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_side.png" "$SCAD"

openscad --csglimit=1000000 --camera=0,65,30,90,0,180,260 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_front.png" "$SCAD"

openscad --csglimit=1000000 --camera=-100,100,80,60,0,220,320 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_iso_front.png" "$SCAD"

openscad --csglimit=1000000 --camera=-100,100,-40,115,0,220,320 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_iso_under.png" "$SCAD"

echo "Rendering Front Tier Ergonomic Detail..."
openscad --csglimit=1000000 --camera=0,52,42,65,0,205,260 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/front_tier_ergo_detail.png" "$SCAD"

echo "Rendering Wall Bracket Detail..."
openscad --csglimit=1000000 --camera=0,22,5,55,0,45,150 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="bracket"' -o "$RENDERS/wall_bracket_mounting.png" "$SCAD"

echo "Rendering 1-Plate Combo Print Bed Layout..."
openscad --csglimit=1000000 --camera=0,58,25,60,0,205,400 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="plate"' -o "$RENDERS/print_bed_layout.png" "$SCAD"

echo "All renders completed!"
