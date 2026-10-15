
$fn = 80;

// ============================================================================
// V3.0 Ultra-Soft Flat-Track Ball Isolator for 420x420x12mm Birch Board
// - Base: 78 x 78 x 12.0 mm (4x Ø19mm flat steel ball cells + Ø31mm center ring)
// - Spring: Drop-in 0.75mm Ultra-Soft Serpentine Flexure (~0.12 N/mm per corner)
// - Top Cradle: 58mm skirt / 64mm platform + 3mm L-lip for 12mm Birch Board
// - Stroke: +/- 6.5 mm omnidirectional (13.0 mm = 1.3 cm peak-to-peak range)
// ============================================================================

part = "assembly"; // "base", "top", "spring", "assembly", "cutaway"

module rrect(w, d, h, r) {
    hull() {
        for (x = [-w/2 + r, w/2 - r])
            for (y = [-d/2 + r, d/2 - r])
                translate([x, y, 0])
                    cylinder(r=r, h=h);
    }
}

module rrect_chamfer(w, d, h, r, ch_b=0.8, ch_t=0.8) {
    hull() {
        for (x = [-w/2 + r, w/2 - r])
            for (y = [-d/2 + r, d/2 - r])
                translate([x, y, 0]) {
                    if (ch_b > 0)
                        cylinder(r1=r-ch_b, r2=r, h=ch_b);
                    translate([0, 0, ch_b])
                        cylinder(r=r, h=max(0.01, h - ch_b - ch_t));
                    if (ch_t > 0)
                        translate([0, 0, h - ch_t])
                            cylinder(r1=r, r2=r-ch_t, h=ch_t);
                }
    }
}

// ----------------------------------------------------------------------------
// 1. BASE MODULE (board_isolator_base.stl)
// ----------------------------------------------------------------------------
module isolator_base() {
    base_w = 78.0;
    base_h = 12.0;
    wall_t = 3.5;
    inner_w = base_w - 2 * wall_t; // 71.0 mm
    floor_z = 3.5;                 // Flat raceway height Z = 3.5mm
    ball_xy = 20.5;                // 4x Ø8mm steel balls at (+/-20.5, +/-20.5), R=29.0mm

    difference() {
        // Outer body
        rrect_chamfer(base_w, base_w, base_h, 6.0, 0.8, 0.6);

        // Bottom alignment groove for 60x60mm 3mm ACF pad (keeps bottom 100% flat for printing)
        translate([0, 0, -0.01])
            difference() {
                rrect(61.0, 61.0, 0.6, 3.0);
                rrect(58.6, 58.6, 0.7, 2.0);
            }

        // Main internal basin above Z = 5.2mm
        translate([0, 0, 5.2])
            rrect(inner_w, inner_w, base_h, 4.5);

        // 4x Independent Flat-Bottom Rolling Cells for Ø8.0mm Steel Balls
        // Floor at Z = 3.5mm is 100% FLAT HORIZONTAL (zero layer steps!)
        // Diameter = 19.0mm (allows ball center +/-5.5mm -> Top plate moves +/-11.0mm!)
        for (sx = [-1, 1])
            for (sy = [-1, 1])
                translate([sx * ball_xy, sy * ball_xy, floor_z])
                    cylinder(d1=19.0, d2=19.8, h=2.0);

        // Center socket for Drop-in Ultra-Soft Serpentine Spring outer ring (Ø31.4mm)
        translate([0, 0, floor_z]) {
            cylinder(d=31.4, h=3.0);
            // 4 anti-rotation key slots
            for (rot = [0, 90, 180, 270])
                rotate([0, 0, rot])
                    translate([14.5, -2.1, 0])
                        cube([3.0, 4.2, 3.0]);
        }

        // 4x Side Recessed Slots for 3mm ACF Bumper Strips (34mm wide x 1.8mm deep into wall)
        for (rot = [0, 90, 180, 270])
            rotate([0, 0, rot])
                translate([inner_w/2 - 0.1, -17.0, 5.2])
                    cube([1.9, 34.0, base_h]);

        // 4x Corner Coves for Optional Ø10mm Silicone Balls (diagonal soft stops)
        for (sx = [-1, 1])
            for (sy = [-1, 1])
                translate([sx * 32.5, sy * 32.5, 5.2])
                    cylinder(d=10.5, h=base_h);
    }

    // Raised retaining rim around center spring socket (OD=34.6mm, ID=31.4mm, Z=5.1 to 7.0mm)
    // Clearly separated from the 4 ball cells (R_outer = 17.3mm vs R_ball_inner = 29.0 - 9.9 = 19.1mm -> 1.8mm solid gap!)
    translate([0, 0, 5.1])
        difference() {
            cylinder(d=34.6, h=1.9);
            translate([0, 0, -0.1])
                cylinder(d=31.4, h=2.2);
            for (rot = [0, 90, 180, 270])
                rotate([0, 0, rot])
                    translate([14.5, -2.1, -0.1])
                        cube([3.0, 4.2, 2.2]);
        }
}

// ----------------------------------------------------------------------------
// 2. DROP-IN ULTRA-SOFT SERPENTINE SPRING (board_isolator_spring.stl)
//    Wall thickness = 0.75mm -> ~0.12 N/mm ultra-low horizontal stiffness!
// ----------------------------------------------------------------------------
module serpentine_quadrant() {
    t = 0.75; // 2 thin perimeters -> feather-soft!
    h = 3.2;
    // Connects outer ring ID (r=13.5) to center hub (r=4.6)
    translate([11.8, -t/2, 0]) cube([2.0, t, h]);
    translate([11.8, -7.8, 0]) cube([t, 7.8 + t/2, h]);
    translate([8.8, -7.8, 0]) cube([3.0 + t, t, h]);
    translate([8.8, -7.8, 0]) cube([t, 15.6, h]);
    translate([5.8, 7.8 - t, 0]) cube([3.0 + t, t, h]);
    translate([5.8, -t/2, 0]) cube([t, 7.8 + t/2, h]);
    translate([4.0, -t/2, 0]) cube([2.2, t, h]);
}

module isolator_spring() {
    h_ring = 3.2;
    pin_h = 8.4; // Reaches from Z=3.5mm up to Z=11.9mm (engages Top Plate socket Z=11.5..15.0)
    union() {
        // Outer Ring (OD = 31.0mm, ID = 27.2mm) + 4 keys
        difference() {
            union() {
                cylinder(d=31.0, h=h_ring);
                for (rot = [0, 90, 180, 270])
                    rotate([0, 0, rot])
                        translate([14.0, -1.8, 0])
                            cube([3.1, 3.6, h_ring]);
            }
            translate([0, 0, -0.1])
                cylinder(d=27.2, h=h_ring + 0.2);
        }

        // 4 Ultra-Soft Serpentine Flexure Arms
        for (rot = [0, 90, 180, 270])
            rotate([0, 0, rot])
                serpentine_quadrant();

        // Center Hub + Upward Hex Coupling Pin
        cylinder(d=9.2, h=h_ring);
        translate([0, 0, h_ring - 0.1]) {
            cylinder(d=8.2, h=pin_h - h_ring - 1.0, $fn=6);
            translate([0, 0, pin_h - h_ring - 1.0])
                cylinder(d1=8.2, d2=6.6, h=1.1, $fn=6);
        }
    }
}

// ----------------------------------------------------------------------------
// 3. TOP CRADLE MODULE (board_isolator_top.stl)
//    Bottom face (Z=0 when printed) is 100% FLAT HORIZONTAL on PEI build plate!
//    Top platform has a true L-shaped corner pocket open to +X and +Y for the Birch Board!
// ----------------------------------------------------------------------------
module isolator_top() {
    skirt_w = 58.0;     // Inside 71.0mm basin -> +/- 6.5mm (13.0mm = 1.3cm) stroke!
    cradle_w = 64.0;    // Upper platform width (-32 to +32)
    plate_h = 7.5;      // Solid carrier thickness (leaves 1.8mm solid floor above center socket!)
    lip_h = 8.5;        // Corner lip height (grips 12mm thick Birch Board)
    lip_t = 3.5;        // 3.5mm thick L-shaped outer retaining wall along -X and -Y edges

    difference() {
        union() {
            // Lower floating piston (Z=0 to 4.2mm, 58x58mm)
            rrect_chamfer(skirt_w, skirt_w, 4.2, 5.0, 0.4, 0.0);

            // Flare out to 64x64mm upper platform (Z=4.0 to 7.5mm)
            hull() {
                translate([0, 0, 4.0])
                    rrect(skirt_w, skirt_w, 0.2, 5.0);
                translate([0, 0, plate_h - 0.5])
                    rrect(cradle_w, cradle_w, 0.5, 5.0);
            }

            // L-shaped Corner Retaining Lip along -X and -Y outer edges
            translate([0, 0, plate_h - 0.1]) {
                difference() {
                    rrect_chamfer(cradle_w, cradle_w, lip_h + 0.1, 5.0, 0.0, 0.8);
                    // Cut out the entire inner area from x = (-32 + 3.5 = -28.5) to +40
                    // and y = (-32 + 3.5 = -28.5) to +40 so the Birch Board corner drops right in!
                    hull() {
                        translate([-cradle_w/2 + lip_t + 2.0, -cradle_w/2 + lip_t + 2.0, -0.1])
                            cylinder(r=2.0, h=lip_h + 1.0);
                        translate([cradle_w/2 + 5.0, -cradle_w/2 + lip_t + 2.0, -0.1])
                            cylinder(r=2.0, h=lip_h + 1.0);
                        translate([-cradle_w/2 + lip_t + 2.0, cradle_w/2 + 5.0, -0.1])
                            cylinder(r=2.0, h=lip_h + 1.0);
                        translate([cradle_w/2 + 5.0, cradle_w/2 + 5.0, -0.1])
                            cylinder(r=2.0, h=lip_h + 1.0);
                    }
                }
            }
        }

        // Blind Center Hex Socket on underside (Z=0 to Z=5.7mm, leaving 1.8mm solid top deck!)
        // Ends with a 45-degree conical roof so it prints 100% support-free!
        translate([0, 0, -0.05]) {
            cylinder(d=8.8, h=3.2, $fn=6);
            translate([0, 0, 3.15])
                cylinder(d1=8.8, d2=0.0, h=2.6, $fn=6);
        }
    }
}

// ----------------------------------------------------------------------------
// ASSEMBLY & CUTAWAY VIEWS
// ----------------------------------------------------------------------------
module full_assembly() {
    // 1. Base (Z = 0 to 12.0mm)
    color([0.22, 0.25, 0.30])
        isolator_base();

    // 2. 4x Ø8.0mm Steel Balls sitting on flat floor Z = 3.5mm -> top of balls at Z = 11.5mm
    color([0.85, 0.88, 0.92])
        for (sx = [-1, 1])
            for (sy = [-1, 1])
                translate([sx * 20.5, sy * 20.5, 3.5 + 4.0])
                    sphere(d=8.0);

    // 3. Drop-in Ultra-Soft Serpentine Spring sitting at Z = 3.6mm
    color([0.20, 0.78, 0.55])
        translate([0, 0, 3.6])
            isolator_spring();

    // 4. Optional 4x Ø10mm Silicone Balls in corner pockets
    color([0.95, 0.35, 0.30, 0.85])
        for (sx = [-1, 1])
            for (sy = [-1, 1])
                translate([sx * 32.5, sy * 32.5, 5.2 + 5.0])
                    sphere(d=10.0);

    // 5. Top Cradle resting directly on top of the Ø8.0mm Steel Balls at Z = 11.5mm!
    color([0.92, 0.65, 0.20])
        translate([0, 0, 11.5])
            isolator_top();
}

if (part == "base") {
    isolator_base();
} else if (part == "spring") {
    isolator_spring();
} else if (part == "top") {
    isolator_top();
} else if (part == "assembly") {
    full_assembly();
} else if (part == "cutaway") {
    // Diagonal cutaway at 45 degrees so the cut plane slices right through:
    // - the (-20.5, -20.5) and (+20.5, +20.5) Steel Ball rolling cells, AND
    // - the Center Serpentine Spring & Hex Coupling Pin!
    difference() {
        full_assembly();
        rotate([0, 0, 45])
            translate([-80, -100, -10])
                cube([160, 100, 60]);
    }
}
