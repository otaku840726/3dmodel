#!/bin/bash
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCAD="$DIR/luxury_wall_toothbrush_holder.scad"
RENDERS="$DIR/renders"
mkdir -p "$RENDERS"

echo "================================================================="
echo "Rendering Luxury Grand Fluted 4-Color Showcase Images"
echo "================================================================="

echo "1. Rendering Assembled Perspective with User's Real Toothbrush Setup..."
openscad --camera=0,65,30,62,0,210,480 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="assembled"' -o "$RENDERS/fluted_assembled_perspective.png" "$SCAD"

echo "2. Rendering Multi-Angle Clean Architectural Views (Grand Fluted 4-Color)..."
echo "  - Front view showing 7 animal heads & gold fluting colonnade on clean wall..."
openscad --camera=0,65,22,90,0,180,260 --imgsize=1600,900 --colorscheme=Cornfield \
    -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_front.png" "$SCAD"

echo "  - Isometric front view..."
openscad --camera=-50,75,48,60,0,225,380 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_iso_front.png" "$SCAD"

echo "  - Close-up of 7 adorable animal waterdrop prongs..."
openscad --camera=0,75,10,70,0,180,220 --imgsize=1600,900 --colorscheme=Cornfield \
    -D 'mode="holder"' -o "$RENDERS/fluted_animal_prongs_closeup.png" "$SCAD"

echo "  - Close-up of rightmost cat face with refined 3D-printable conformal whiskers..."
openscad --camera=-75,65,7,60,0,215,70 --imgsize=1600,1200 --colorscheme=Cornfield \
    -D 'mode="holder"' -o "$RENDERS/fluted_cat_whisker_closeup.png" "$SCAD"

echo "  - Close-up of adorable 3D sculpted piggy face..."
openscad --camera=50,65,7,60,0,180,70 --imgsize=1600,1200 --colorscheme=Cornfield \
    -D 'mode="holder"' -o "$RENDERS/fluted_pig_closeup.png" "$SCAD"

echo "  - Side view showing 5.5mm -> 11.0mm thickness expansion..."
openscad --camera=75,50,45,90,0,90,260 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_side.png" "$SCAD"

echo "  - Side hook & smooth flank close-up (bumps removed, utility hook integrated)..."
openscad --camera=90,35,24,70,0,100,160 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="holder"' -o "$RENDERS/fluted_side_hook_closeup.png" "$SCAD"

echo "  - Side hook isometric perspective..."
openscad --camera=70,55,30,60,0,135,260 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="holder"' -o "$RENDERS/fluted_side_hook_iso.png" "$SCAD"

echo "  - Top view showing storage wells..."
openscad --camera=0,65,65,45,0,205,320 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_top.png" "$SCAD"

echo "  - Bottom view showing 4 straight-through drainage holes..."
openscad --camera=0,65,-10,125,0,210,480 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="holder"' -o "$RENDERS/fluted_crystalline_bottom.png" "$SCAD"

echo "  - Backplate bottom corner rear ortho view..."
openscad --camera=-100,-10,10,90,0,0,100 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="holder"' -o "$RENDERS/fluted_backplate_corner_rear_ortho.png" "$SCAD"

echo "  - Backplate bottom corner isometric close-up..."
openscad --camera=-100,-15,10,75,0,320,160 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="holder"' -o "$RENDERS/fluted_backplate_corner_closeup.png" "$SCAD"

echo "  - Full rear view (rectangular backplate symmetry)..."
openscad --camera=0,-100,44,90,0,0,300 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="holder"' -o "$RENDERS/rear_full_view.png" "$SCAD"

echo "3. Rendering Standalone Fluted Toothbrush Rack (with Animal Heads)..."
openscad --camera=-40,65,35,60,0,225,280 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="standalone_toothbrush"' -o "$RENDERS/standalone_toothbrush_rack.png" "$SCAD"

echo "4. Rendering Universal Wall Bracket..."
openscad --camera=0,22,5,55,0,45,150 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="bracket"' -o "$RENDERS/wall_bracket_mounting.png" "$SCAD"

echo "5. Rendering 1-Plate Combo Print Bed Layout (Fluted Grand + Bracket)..."
openscad --camera=0,65,45,60,0,205,420 --imgsize=1600,1000 --colorscheme=Cornfield \
    -D 'mode="plate"' -o "$RENDERS/print_bed_layout.png" "$SCAD"

echo "================================================================="
echo "All 4-Color Renders completed successfully!"
echo "================================================================="
