#!/bin/bash
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCAD="$DIR/luxury_wall_toothbrush_holder.scad"
RENDERS="$DIR/renders"
mkdir -p "$RENDERS"

echo "================================================================="
echo "Rendering Luxury Grand Fluted Showcase Images"
echo "================================================================="

echo "1. Rendering Assembled Perspective with User's Real Toothbrush Setup..."
openscad --csglimit=1000000 --camera=0,65,30,62,0,210,480 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="assembled"' -o "$RENDERS/fluted_assembled_perspective.png" "$SCAD"

echo "2. Rendering Multi-Angle Clean Architectural Views (Grand Fluted)..."
echo "  - Front view showing all 7 animal heads & diamond crystalline facade..."
openscad --render --csglimit=1000000 --camera=0,65,22,90,0,180,260 --imgsize=1600,900 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_front.png" "$SCAD"

echo "  - Isometric front view..."
openscad --render --csglimit=1000000 --camera=-50,75,48,60,0,225,380 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_iso_front.png" "$SCAD"

echo "  - Side view showing 5.5mm -> 11.0mm thickness expansion..."
openscad --render --csglimit=1000000 --camera=75,50,45,90,0,90,260 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_side.png" "$SCAD"

echo "  - Top view showing storage wells..."
openscad --render --csglimit=1000000 --camera=0,65,65,45,0,205,320 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_top.png" "$SCAD"

echo "  - Bottom view showing 4 straight-through drainage holes..."
openscad --render --csglimit=1000000 --camera=0,65,-10,125,0,210,480 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_bottom.png" "$SCAD"

echo "3. Rendering Close-Up of Animal Waterdrop Prongs..."
openscad --render --csglimit=1000000 --camera=0,75,10,70,0,180,180 --imgsize=1600,900 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="holder"' -o "$RENDERS/fluted_animal_prongs_closeup.png" "$SCAD"

echo "4. Rendering Standalone Fluted Toothbrush Rack (with Animal Heads)..."
openscad --render --csglimit=1000000 --camera=-40,65,35,60,0,225,280 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="standalone_toothbrush"' -o "$RENDERS/standalone_toothbrush_rack.png" "$SCAD"

echo "5. Rendering Universal Wall Bracket..."
openscad --render --csglimit=1000000 --camera=0,22,5,55,0,45,150 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="bracket"' -o "$RENDERS/wall_bracket_mounting.png" "$SCAD"

echo "6. Rendering 1-Plate Combo Print Bed Layout (Fluted Grand + Bracket)..."
openscad --render --csglimit=1000000 --camera=0,65,45,60,0,205,420 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'style="fluted"' -D 'mode="plate"' -o "$RENDERS/print_bed_layout.png" "$SCAD"

echo "================================================================="
echo "All Renders completed successfully!"
echo "================================================================="
