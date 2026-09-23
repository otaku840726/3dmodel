#!/bin/bash
set -e
DIR="/root/.gemini/antigravity-cli/scratch/3dmodel/luxury-wall-toothbrush-holder"
SCAD="$DIR/luxury_wall_toothbrush_holder.scad"
RENDERS="$DIR/renders"

echo "Rendering 3 Styles Comparison..."
openscad --camera=0,35,95,62,0,195,1480 --imgsize=1600,900 --colorscheme=Cornfield \
    -D 'mode="all_styles"' -o "$RENDERS/rose_gold_3styles_comparison.png" "$SCAD"

echo "Rendering Fluted Assembled Perspective (with Electric Toothbrushes)..."
openscad --camera=0,45,100,58,0,205,680 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="assembled"' -o "$RENDERS/fluted_assembled_perspective.png" "$SCAD"

echo "Rendering Curved Assembled Perspective..."
openscad --camera=0,45,100,58,0,205,680 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="curved"' -D 'mode="assembled"' -o "$RENDERS/curved_assembled_perspective.png" "$SCAD"

echo "Rendering Faceted Assembled Perspective..."
openscad --camera=0,45,100,58,0,205,680 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="faceted"' -D 'mode="assembled"' -o "$RENDERS/faceted_assembled_perspective.png" "$SCAD"

echo "Rendering Front Tier Ergonomic Detail (Flared Cradles & Electric Brush Sockets)..."
openscad --camera=0,58,28,66,0,205,290 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/front_tier_ergo_detail.png" "$SCAD"

echo "Rendering Wall Bracket Detail..."
openscad --camera=0,22,5,55,0,45,150 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="bracket"' -o "$RENDERS/wall_bracket_mounting.png" "$SCAD"

echo "Rendering 1-Plate Combo Print Bed Layout..."
openscad --camera=0,68,25,60,0,205,440 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="plate"' -o "$RENDERS/print_bed_layout.png" "$SCAD"

echo "All renders completed!"
