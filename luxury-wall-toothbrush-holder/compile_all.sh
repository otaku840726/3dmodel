#!/bin/bash
set -e
DIR="/root/.gemini/antigravity-cli/scratch/3dmodel/luxury-wall-toothbrush-holder"
SCAD="$DIR/luxury_wall_toothbrush_holder.scad"

echo "Compiling Fluted Holder..."
openscad -D 'style="fluted"' -D 'mode="holder"' -o "$DIR/luxury_holder_fluted.stl" "$SCAD"

echo "Compiling Curved Holder..."
openscad -D 'style="curved"' -D 'mode="holder"' -o "$DIR/luxury_holder_curved.stl" "$SCAD"

echo "Compiling Faceted Holder..."
openscad -D 'style="faceted"' -D 'mode="holder"' -o "$DIR/luxury_holder_faceted.stl" "$SCAD"

echo "Compiling Wall Bracket..."
openscad -D 'mode="bracket"' -o "$DIR/wall_bracket.stl" "$SCAD"

echo "Compiling Fluted Cup..."
openscad -D 'style="fluted"' -D 'mode="cup"' -o "$DIR/luxury_cup_fluted.stl" "$SCAD"

echo "Compiling Curved Cup..."
openscad -D 'style="curved"' -D 'mode="cup"' -o "$DIR/luxury_cup_curved.stl" "$SCAD"

echo "Compiling Faceted Cup..."
openscad -D 'style="faceted"' -D 'mode="cup"' -o "$DIR/luxury_cup_faceted.stl" "$SCAD"

echo "Compiling Combo Plate (Fluted)..."
openscad -D 'style="fluted"' -D 'mode="plate"' -o "$DIR/combo_plate_fluted.stl" "$SCAD"

echo "All STLs compiled successfully!"
