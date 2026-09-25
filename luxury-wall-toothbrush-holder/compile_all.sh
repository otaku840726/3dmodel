#!/bin/bash
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCAD="$DIR/luxury_wall_toothbrush_holder.scad"

echo "================================================================="
echo "Compiling Luxury Grand Fluted Edition (Palazzo Fluting + 7 Animal Faces)"
echo "4-Color AMS / Multi-Material & Single-Color Production Suite"
echo "================================================================="

echo "1. Compiling Unified Monolithic Holder (luxury_holder_grand_fluted.stl)..."
openscad --csglimit=1000000 -D 'mode="holder_monochrome"' -o "$DIR/luxury_holder_grand_fluted.stl" "$SCAD"
cp "$DIR/luxury_holder_grand_fluted.stl" "$DIR/luxury_holder_fluted.stl"

echo "2. Compiling 4 Discrete Color STLs for Bambu Studio / AMS Multi-Material Printing..."
echo "  --> Color 1 (Body): luxury_holder_c1_body.stl"
openscad --csglimit=1000000 -D 'color_export=1' -o "$DIR/luxury_holder_c1_body.stl" "$SCAD"

echo "  --> Color 2 (Black Features): luxury_holder_c2_black.stl"
openscad --csglimit=1000000 -D 'color_export=2' -o "$DIR/luxury_holder_c2_black.stl" "$SCAD"

echo "  --> Color 3 (Peach/Pink Accents): luxury_holder_c3_warm.stl"
openscad --csglimit=1000000 -D 'color_export=3' -o "$DIR/luxury_holder_c3_warm.stl" "$SCAD"

echo "  --> Color 4 (Champagne Gold Trim): luxury_holder_c4_gold.stl"
openscad --csglimit=1000000 -D 'color_export=4' -o "$DIR/luxury_holder_c4_gold.stl" "$SCAD"

echo "3. Packaging 4-Color 3MF Multi-Part Project File (luxury_holder_grand_fluted_4color.3mf)..."
python3 "$DIR/make_3mf.py"

echo "4. Compiling Combo Plate & Standalone Models..."
openscad --csglimit=1000000 -D 'edition="grand"' -D 'style="fluted"' -D 'mode="plate"' -o "$DIR/combo_plate_grand_fluted.stl" "$SCAD"
cp "$DIR/combo_plate_grand_fluted.stl" "$DIR/combo_plate_fluted.stl"

openscad --csglimit=1000000 -D 'edition="grand"' -D 'style="fluted"' -D 'mode="standalone_toothbrush"' -o "$DIR/standalone_toothbrush_fluted.stl" "$SCAD"
openscad --csglimit=1000000 -D 'mode="bracket"' -o "$DIR/wall_bracket.stl" "$SCAD"

echo "================================================================="
echo "All Production Files Compiled and Packaged Successfully!"
echo "================================================================="
