#!/bin/bash
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCAD="$DIR/luxury_wall_toothbrush_holder.scad"
RENDERS="$DIR/renders"
mkdir -p "$RENDERS"

echo "1. Rendering 3 Styles Side-by-Side Comparison (Grand 8-in-1)..."
openscad --csglimit=1000000 --camera=0,35,35,58,0,195,1050 --imgsize=1600,900 --colorscheme=Cornfield \
    -D 'edition="grand"' -D 'mode="all_styles"' -o "$RENDERS/rose_gold_3styles_comparison.png" "$SCAD"

echo "2. Rendering Assembled Perspectives with All Cleansers, Toothpastes & Toothbrushes..."
openscad --csglimit=1000000 --camera=0,40,35,58,0,205,680 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'edition="grand"' -D 'style="fluted"' -D 'mode="assembled"' -o "$RENDERS/fluted_assembled_perspective.png" "$SCAD"

openscad --csglimit=1000000 --camera=0,40,35,58,0,205,680 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'edition="grand"' -D 'style="curved"' -D 'mode="assembled"' -o "$RENDERS/curved_assembled_perspective.png" "$SCAD"

openscad --csglimit=1000000 --camera=0,40,35,58,0,205,680 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'edition="grand"' -D 'style="faceted"' -D 'mode="assembled"' -o "$RENDERS/faceted_assembled_perspective.png" "$SCAD"

echo "3. Rendering Multi-Angle Clean Architectural Views (Grand Fluted)..."
openscad --render --csglimit=1000000 --camera=0,50,45,55,0,205,420 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'edition="grand"' -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_top.png" "$SCAD"

openscad --render --csglimit=1000000 --camera=0,65,-10,125,0,210,420 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'edition="grand"' -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_bottom.png" "$SCAD"

openscad --render --csglimit=1000000 --camera=70,40,40,90,0,90,300 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'edition="grand"' -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_side.png" "$SCAD"

openscad --render --csglimit=1000000 --camera=0,65,42,90,0,180,320 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'edition="grand"' -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_front.png" "$SCAD"

openscad --render --csglimit=1000000 --camera=-80,80,60,60,0,225,420 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'edition="grand"' -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_iso_front.png" "$SCAD"

openscad --render --csglimit=1000000 --camera=-80,80,-30,120,0,225,420 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'edition="grand"' -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_iso_under.png" "$SCAD"

echo "4. Rendering Front Tier Ergonomic Detail..."
openscad --render --csglimit=1000000 --camera=0,50,45,65,0,205,300 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'edition="grand"' -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/front_tier_ergo_detail.png" "$SCAD"

echo "5. Rendering Wall Bracket Detail..."
openscad --render --csglimit=1000000 --camera=0,22,5,55,0,45,150 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="bracket"' -o "$RENDERS/wall_bracket_mounting.png" "$SCAD"

echo "6. Rendering 1-Plate Combo Print Bed Layout (Grand Edition)..."
openscad --render --csglimit=1000000 --camera=0,58,35,60,0,205,480 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'edition="grand"' -D 'style="fluted"' -D 'mode="plate"' -o "$RENDERS/print_bed_layout.png" "$SCAD"

echo "All renders completed successfully!"
