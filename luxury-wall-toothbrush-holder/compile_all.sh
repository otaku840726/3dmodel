#!/bin/bash
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCAD="$DIR/luxury_wall_toothbrush_holder.scad"

echo "================================================================="
echo "Compiling Luxury Grand Fluted Edition (Palazzo Fluted + Diamond Facade + 7 Animal Faces)"
echo "================================================================="

echo "1. Compiling Grand Fluted Holder (luxury_holder_grand_fluted.stl)..."
openscad --csglimit=1000000 -D 'edition="grand"' -D 'style="fluted"' -D 'mode="holder"' -o "$DIR/luxury_holder_grand_fluted.stl" "$SCAD"
cp "$DIR/luxury_holder_grand_fluted.stl" "$DIR/luxury_holder_fluted.stl"

echo "2. Compiling Grand Fluted 1-Plate Combo (combo_plate_grand_fluted.stl)..."
openscad --csglimit=1000000 -D 'edition="grand"' -D 'style="fluted"' -D 'mode="plate"' -o "$DIR/combo_plate_grand_fluted.stl" "$SCAD"
cp "$DIR/combo_plate_grand_fluted.stl" "$DIR/combo_plate_fluted.stl"

echo "3. Compiling Standalone Fluted Toothbrush Rack (standalone_toothbrush_fluted.stl)..."
openscad --csglimit=1000000 -D 'edition="grand"' -D 'style="fluted"' -D 'mode="standalone_toothbrush"' -o "$DIR/standalone_toothbrush_fluted.stl" "$SCAD"

echo "4. Compiling Universal Wall Bracket (wall_bracket.stl)..."
openscad --csglimit=1000000 -D 'mode="bracket"' -o "$DIR/wall_bracket.stl" "$SCAD"

echo "================================================================="
echo "All Target STLs compiled successfully!"
echo "================================================================="
