#!/bin/bash
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCAD="$DIR/luxury_wall_toothbrush_holder.scad"

echo "=== 1. Compiling Grand Edition (8-in-1 Suite: 2 Cleansers + 2 Toothpastes + 4 Toothbrushes) ==="
echo "Compiling Grand Fluted Holder..."
openscad --csglimit=1000000 -D 'edition="grand"' -D 'style="fluted"' -D 'mode="holder"' -o "$DIR/luxury_holder_grand_fluted.stl" "$SCAD"
cp "$DIR/luxury_holder_grand_fluted.stl" "$DIR/luxury_holder_fluted.stl"

echo "Compiling Grand Curved Holder..."
openscad --csglimit=1000000 -D 'edition="grand"' -D 'style="curved"' -D 'mode="holder"' -o "$DIR/luxury_holder_grand_curved.stl" "$SCAD"
cp "$DIR/luxury_holder_grand_curved.stl" "$DIR/luxury_holder_curved.stl"

echo "Compiling Grand Faceted Holder..."
openscad --csglimit=1000000 -D 'edition="grand"' -D 'style="faceted"' -D 'mode="holder"' -o "$DIR/luxury_holder_grand_faceted.stl" "$SCAD"
cp "$DIR/luxury_holder_grand_faceted.stl" "$DIR/luxury_holder_faceted.stl"

echo "Compiling Grand Combo Plate (Holder + Wall Bracket)..."
openscad --csglimit=1000000 -D 'edition="grand"' -D 'style="fluted"' -D 'mode="plate"' -o "$DIR/combo_plate_grand_fluted.stl" "$SCAD"
cp "$DIR/combo_plate_grand_fluted.stl" "$DIR/combo_plate_fluted.stl"

echo "=== 2. Compiling Compact Edition (6-in-1 Suite: 2 Toothpastes + 4 Toothbrushes) ==="
echo "Compiling Compact Fluted Holder..."
openscad --csglimit=1000000 -D 'edition="compact"' -D 'style="fluted"' -D 'mode="holder"' -o "$DIR/luxury_holder_compact_fluted.stl" "$SCAD"

echo "Compiling Compact Combo Plate..."
openscad --csglimit=1000000 -D 'edition="compact"' -D 'style="fluted"' -D 'mode="plate"' -o "$DIR/combo_plate_compact_fluted.stl" "$SCAD"

echo "=== 3. Compiling Universal Wall Bracket ==="
openscad --csglimit=1000000 -D 'mode="bracket"' -o "$DIR/wall_bracket.stl" "$SCAD"

echo "All STLs compiled successfully!"
