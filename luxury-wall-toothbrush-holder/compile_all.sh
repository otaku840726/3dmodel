#!/bin/bash
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCAD="$DIR/luxury_wall_toothbrush_holder.scad"

echo "=== 1. Compiling Art Deco Diamond Faceted Edition (★ User Selected Primary) ==="
echo "Compiling Grand Faceted Holder..."
openscad --csglimit=1000000 -D 'style="faceted"' -D 'mode="holder"' -o "$DIR/luxury_holder_grand_faceted.stl" "$SCAD"
cp "$DIR/luxury_holder_grand_faceted.stl" "$DIR/luxury_holder_faceted.stl"

echo "Compiling Grand Faceted Combo Plate (Holder + Wall Bracket)..."
openscad --csglimit=1000000 -D 'style="faceted"' -D 'mode="plate"' -o "$DIR/combo_plate_grand_faceted.stl" "$SCAD"
cp "$DIR/combo_plate_grand_faceted.stl" "$DIR/combo_plate_faceted.stl"

echo "Compiling Standalone Faceted Toothbrush Rack (6-Slot)..."
openscad --csglimit=1000000 -D 'style="faceted"' -D 'mode="standalone_toothbrush"' -o "$DIR/standalone_toothbrush_faceted.stl" "$SCAD"

echo "=== 2. Compiling Alternative Architectural Styles ==="
echo "Compiling Grand Fluted Holder..."
openscad --csglimit=1000000 -D 'style="fluted"' -D 'mode="holder"' -o "$DIR/luxury_holder_grand_fluted.stl" "$SCAD"
cp "$DIR/luxury_holder_grand_fluted.stl" "$DIR/luxury_holder_fluted.stl"

echo "Compiling Grand Fluted Combo Plate..."
openscad --csglimit=1000000 -D 'style="fluted"' -D 'mode="plate"' -o "$DIR/combo_plate_grand_fluted.stl" "$SCAD"
cp "$DIR/combo_plate_grand_fluted.stl" "$DIR/combo_plate_fluted.stl"

echo "Compiling Grand Curved Holder..."
openscad --csglimit=1000000 -D 'style="curved"' -D 'mode="holder"' -o "$DIR/luxury_holder_grand_curved.stl" "$SCAD"
cp "$DIR/luxury_holder_grand_curved.stl" "$DIR/luxury_holder_curved.stl"

echo "=== 3. Compiling Universal Wall Bracket ==="
openscad --csglimit=1000000 -D 'mode="bracket"' -o "$DIR/wall_bracket.stl" "$SCAD"

echo "All STLs compiled successfully!"
