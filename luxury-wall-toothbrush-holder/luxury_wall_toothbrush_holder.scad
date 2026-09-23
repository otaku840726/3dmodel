/*
================================================================================
Luxury Wall-Mounted Organizer: 4 Universal Toothbrushes + 2 Toothpastes
(奢華輕奢壁掛式階梯全能置物架 - 前排四電動/普通牙刷通用艙 + 後排雙超大牙膏艙)

Designed specifically for Rose Gold / Silk Metallic FDM 3D Printing:
- 100% Support-Free Printing (Pointed-arch ceilings, 45° conical drains, 0 support alert)
- FULL ELECTRIC TOOTHBRUSH COMPATIBILITY (電動牙刷全相容):
  * Front Tier (H=46mm): 4 Universal Toothbrush Stations with Ø35.5mm inner diameter
    (Fits Oral-B iO/Pro, Philips Sonicare, Xiaomi, USmile, up to Ø34mm handles!)
  * Ergonomic Front U-Scoop Grab Windows (Z=22mm lip, 24mm wide access) for effortless
    one-handed grip and retrieval without fumbling.
  * Dual-Stage Self-Centering Floor: Flat Ø35.5mm landing ring for electric toothbrushes,
    plus 45° conical central funnel (Ø9mm drain) to keep slim manual toothbrushes upright!
- Rear Tier (H=66mm, Depth 56mm): 2 Generous Compartments (50mm x 28mm) for 200g
  family toothpastes, facial cleansers, or extra electric toothbrushes/shavers.
- Modular Slide-in Dovetail Wall Bracket (3M VHB tape flat bed + countersunk screw holes)
- 3 Distinct Luxury Aesthetics in Rose Gold:
    1. "fluted"  - 輕奢羅馬柱豎條紋 (Art Deco Continuous Fluted Columns)
    2. "curved"  - 現代意式極簡流線 (Cascading Organic Streamlines with Accent Grooves)
    3. "faceted" - 幾何菱格鑽石切面 (Architectural Diamond-Cut Facets)

Units: millimeters (mm)
================================================================================
*/

$fn = 36;

// -----------------------------------------------------------------------------
// Parameters & Mode Selection
// -----------------------------------------------------------------------------
// Selected aesthetic style: "fluted" | "curved" | "faceted"
style = "fluted";

// Output mode:
// "holder"     - Main tiered organizer body (for selected style)
// "bracket"    - Wall mounting slide bracket (fits all styles)
// "plate"      - 1-Plate combo (Holder + Bracket on Z=0 bed)
// "assembled"  - Full color assembled wall preview with electric toothbrushes & toothpastes
// "all_styles" - Side-by-side visual comparison of all 3 styles in Rose Gold
mode = "holder";

// -----------------------------------------------------------------------------
// Dimensions & Mechanical Specifications
// -----------------------------------------------------------------------------
w_holder     = 166.0;   // Overall width (X)
d_back       = 40.0;    // Depth of rear tier (Y)
d_front      = 84.0;    // Total depth including front tier (Y)
h_back       = 66.0;    // Rear tier height (Z)
h_front      = 46.0;    // Front tier height (Z)
corner_r     = 12.0;    // Outer corner radius

// Front Toothbrush Sockets (Universal for Electric + Manual)
tb_diam      = 35.5;    // Inner diameter (fits up to Ø34mm electric brush handles)
tb_pitch     = 39.0;    // Center-to-center distance between 4 sockets
tb_y         = 63.0;    // Center Y position of front sockets
tb_lip_h     = 22.0;    // Front U-scoop retaining lip height
tb_u_w       = 24.0;    // Front ergonomic grab window width

// Rear Toothpaste Compartments
tp_w         = 50.0;    // Compartment width (X)
tp_d         = 28.0;    // Compartment depth (Y)
tp_x         = 43.0;    // Center X offset (Left: -43, Right: +43)
tp_y         = 20.0;    // Center Y position
tp_floor_z   = 10.0;    // Interior floor height

// Wall Bracket & Dovetail
bracket_w    = 46.0;    // Bracket width
bracket_h    = 44.0;    // Bracket height
bracket_th   = 2.2;     // Bracket base plate thickness
dove_th      = 4.6;     // Dovetail wedge thickness
dove_w_top   = 28.0;    // Dovetail top width
dove_w_bot   = 24.0;    // Dovetail bottom width
dove_angle   = 12.0;    // Dovetail overhang angle

// Rose Gold Material Colors
rose_gold_base  = [0.88, 0.58, 0.52];
rose_gold_dark  = [0.76, 0.46, 0.42];
rose_gold_light = [0.95, 0.70, 0.64];
accent_brass    = [0.82, 0.65, 0.38];
wall_tile_color = [0.92, 0.94, 0.95];


// =============================================================================
// 1. WALL BRACKET (免打孔雙用快拆背板)
// =============================================================================
module wall_bracket() {
    difference() {
        union() {
            // Flat base plate (Z = 0 to bracket_th, 100% flat bed contact >1800mm²)
            hull() {
                translate([-bracket_w/2+4, 4, 0]) cylinder(r=4, h=bracket_th);
                translate([ bracket_w/2-4, 4, 0]) cylinder(r=4, h=bracket_th);
                translate([-bracket_w/2+4, bracket_h-4, 0]) cylinder(r=4, h=bracket_th);
                translate([ bracket_w/2-4, bracket_h-4, 0]) cylinder(r=4, h=bracket_th);
            }
            // Male dovetail wedge (Z = bracket_th to bracket_th + dove_th, 100% above Z=0)
            translate([0, bracket_h, bracket_th])
                rotate([90, 0, 0])
                    linear_extrude(height=bracket_h, scale=[dove_w_bot/dove_w_top, 1.0])
                        polygon([
                            [-dove_w_top/2, 0],
                            [-dove_w_top/2 - dove_th*tan(dove_angle), dove_th],
                            [ dove_w_top/2 + dove_th*tan(dove_angle), dove_th],
                            [ dove_w_top/2, 0]
                        ]);
        }
        
        // Countersunk screw holes (conical chamfer widening UPWARDS +Z, 100% self-supporting)
        for (y_screw = [12.0, 32.0]) {
            translate([0, y_screw, -1.0]) {
                cylinder(d=4.2, h=bracket_th + dove_th + 3.0);
                translate([0, 0, bracket_th + dove_th - 2.0])
                    cylinder(r1=4.2/2, r2=8.2/2, h=2.5);
            }
        }
    }
}


// =============================================================================
// 2. INTERNAL CAVITIES & ERGONOMIC INTERFACES (100% SELF-SUPPORTING)
// =============================================================================

// Female dovetail receiver inside holder back (with 45° pointed pyramid roof)
module female_dovetail_cavity() {
    tol = 0.30;
    h_slot = bracket_h;
    w_t = dove_w_top + tol*2;
    w_b = dove_w_bot + tol*2;
    d_s = dove_th + tol;
    w_max = w_b + 2 * d_s * tan(dove_angle);
    apex_h = w_max / 2; // Exact 45° rise to both outer edges

    translate([0, -0.01, -0.5]) {
        // Main dovetail shaft: widens from w_b at top down to w_t at bottom (Z=0)
        // Extruded upwards: from Z=0 (w_t) to Z=h_slot (w_b)
        linear_extrude(height=h_slot, scale=[w_b/w_t, 1.0])
            polygon([
                [-w_t/2, 0],
                [-w_t/2 - d_s*tan(dove_angle), d_s],
                [ w_t/2 + d_s*tan(dove_angle), d_s],
                [ w_t/2, 0]
            ]);
            
        // 45° Pointed Pyramid Roof (100% self-supporting)
        translate([0, 0, h_slot - 0.5])
            hull() {
                linear_extrude(height=0.1)
                    polygon([
                        [-w_b/2, 0],
                        [-w_b/2 - d_s*tan(dove_angle), d_s],
                        [ w_b/2 + d_s*tan(dove_angle), d_s],
                        [ w_b/2, 0]
                    ]);
                translate([0, d_s/2, apex_h])
                    cylinder(r=0.2, h=0.1);
            }
    }
}

// Twin Oversized Toothpaste Wells in Rear Tier (Left X=-43, Right X=+43)
module twin_toothpaste_cavities() {
    for (x_pos = [-tp_x, tp_x]) {
        translate([x_pos, tp_y, tp_floor_z]) {
            // Generous rounded rectangular well (50mm x 28mm, depth 56mm)
            hull() {
                translate([-tp_w/2 + 7.0, -tp_d/2 + 7.0, 0]) cylinder(r=7.0, h=h_back);
                translate([ tp_w/2 - 7.0, -tp_d/2 + 7.0, 0]) cylinder(r=7.0, h=h_back);
                translate([-tp_w/2 + 7.0,  tp_d/2 - 7.0, 0]) cylinder(r=7.0, h=h_back);
                translate([ tp_w/2 - 7.0,  tp_d/2 - 7.0, 0]) cylinder(r=7.0, h=h_back);
            }
            // Sloped self-draining funnel floor (12° slope)
            hull() {
                translate([-tp_w/2 + 7.0, -tp_d/2 + 7.0, 3.0]) cylinder(r=6.0, h=0.1);
                translate([ tp_w/2 - 7.0, -tp_d/2 + 7.0, 3.0]) cylinder(r=6.0, h=0.1);
                translate([-tp_w/2 + 7.0,  tp_d/2 - 7.0, 3.0]) cylinder(r=6.0, h=0.1);
                translate([ tp_w/2 - 7.0,  tp_d/2 - 7.0, 3.0]) cylinder(r=6.0, h=0.1);
                translate([0, 0, -tp_floor_z - 0.1]) cylinder(d=9.0, h=0.1);
            }
        }
        // Vertical drainage through-hole
        translate([x_pos, tp_y, -1.0])
            cylinder(d=9.0, h=tp_floor_z + 2.0);
    }
}

// 4 Universal Toothbrush Stations in Front Tier (X = -58.5, -19.5, +19.5, +58.5)
module four_universal_toothbrush_sockets() {
    for (i = [0:3]) {
        x_pos = (i - 1.5) * tb_pitch; // -58.5, -19.5, 19.5, 58.5
        
        translate([x_pos, tb_y, 0]) {
            // 1. Main Cylindrical Cavity (Ø35.5mm, floor at Z=8.0mm)
            translate([0, 0, 8.0])
                cylinder(d=tb_diam, h=h_front - 8.0 + 2.0);
                
            // 2. Dual-Stage Self-Centering Floor inside cavity:
            // 45° conical funnel inside cavity for slim manual toothbrushes
            translate([0, 0, 8.0])
                cylinder(r1=4.5, r2=9.0, h=4.5);
                
            // 3. Top Funnel Entry Chamfer (45° lead-in for blind drop-in)
            translate([0, 0, h_front - 2.5])
                cylinder(r1=tb_diam/2, r2=tb_diam/2 + 2.5, h=2.6);
                
            // 4. Ergonomic Flared Front Cradle Scoop (Smooth, zero sharp edges)
            translate([0, 0, tb_lip_h]) {
                hull() {
                    // Lower rounded bottom of cradle scoop (smooth cylinder along Y)
                    translate([0, 6.0, 5.0])
                        rotate([-90, 0, 0]) cylinder(d=26.0, h=d_front - tb_y + 4.0);
                    // Upper flared opening (widening to 33mm at front face)
                    translate([0, 0, h_front - tb_lip_h + 2.0])
                        linear_extrude(height=0.1)
                            polygon([
                                [-13.5, 0],
                                [-16.5, d_front - tb_y + 5.0],
                                [ 16.5, d_front - tb_y + 5.0],
                                [ 13.5, 0]
                            ]);
                }
            }
                
            // 5. Center Drainage Weep Hole (Ø9.0mm straight through to bed)
            translate([0, 0, -1.0])
                cylinder(d=9.0, h=10.0);
        }
    }
}


// =============================================================================
// 3. STYLE 1: 輕奢羅馬柱豎條紋 (FLUTED / REEDED LUXURY)
// =============================================================================
module fluted_contour_tier1_2d(rib_r=1.5, pitch=4.8) {
    r = corner_r;
    w = w_holder;
    d = d_front;
    union() {
        // Base rounded outline
        hull() {
            translate([-w/2+r, r]) circle(r=r);
            translate([ w/2-r, r]) circle(r=r);
            translate([-w/2+r, d-r]) circle(r=r);
            translate([ w/2-r, d-r]) circle(r=r);
        }
        // Front face vertical flutes
        for (x = [-w/2+r : pitch : w/2-r]) translate([x, d]) circle(r=rib_r);
        // Left and Right side flutes
        for (y = [r : pitch : d-r]) {
            translate([-w/2, y]) circle(r=rib_r);
            translate([ w/2, y]) circle(r=rib_r);
        }
        // Front corner flutes
        for (a = [90:15:180]) translate([-w/2+r + (r)*cos(a), d-r + (r)*sin(a)]) circle(r=rib_r);
        for (a = [0:15:90])   translate([ w/2-r + (r)*cos(a), d-r + (r)*sin(a)]) circle(r=rib_r);
    }
}

module fluted_contour_tier2_2d(rib_r=1.5, pitch=4.8) {
    r = corner_r;
    w = w_holder;
    d = d_back;
    union() {
        // Base rounded outline
        hull() {
            translate([-w/2+r, r]) circle(r=r);
            translate([ w/2-r, r]) circle(r=r);
            translate([-w/2+r, d-r]) circle(r=r);
            translate([ w/2-r, d-r]) circle(r=r);
        }
        // Side flutes on upper tier
        for (y = [r : pitch : d-r]) {
            translate([-w/2, y]) circle(r=rib_r);
            translate([ w/2, y]) circle(r=rib_r);
        }
        // Rear step face flutes (ribs sit flush against step)
        for (x = [-w/2+r : pitch : w/2-r]) translate([x, d]) circle(r=rib_r);
        // Rear step corner flutes
        for (a = [90:15:180]) translate([-w/2+r + (r)*cos(a), d-r + (r)*sin(a)]) circle(r=rib_r);
        for (a = [0:15:90])   translate([ w/2-r + (r)*cos(a), d-r + (r)*sin(a)]) circle(r=rib_r);
    }
}

module holder_tiered_fluted() {
    union() {
        // Lower front tier (Z = 0 to 46mm)
        linear_extrude(height=h_front)
            fluted_contour_tier1_2d();
        // Upper rear tier (Z = 0 to 66mm)
        linear_extrude(height=h_back)
            fluted_contour_tier2_2d();
    }
}


// =============================================================================
// 4. STYLE 2: 現代意式極簡流線 (CURVED STREAMLINE LUXURY)
// =============================================================================
module holder_tiered_curved() {
    w = w_holder;
    r = 14.0;
    
    difference() {
        union() {
            // Front lower tier
            hull() {
                translate([-w/2+r, r, 0]) cylinder(r=r, h=h_front - 2.5);
                translate([ w/2-r, r, 0]) cylinder(r=r, h=h_front - 2.5);
                translate([-w/2+r, d_front-r, 0]) cylinder(r=r, h=h_front - 2.5);
                translate([ w/2-r, d_front-r, 0]) cylinder(r=r, h=h_front - 2.5);
            }
            translate([0, 0, h_front - 2.5])
                hull() {
                    translate([-w/2+r, r, 0]) cylinder(r1=r, r2=r-2.2, h=2.5);
                    translate([ w/2-r, r, 0]) cylinder(r1=r, r2=r-2.2, h=2.5);
                    translate([-w/2+r, d_front-r, 0]) cylinder(r1=r, r2=r-2.2, h=2.5);
                    translate([ w/2-r, d_front-r, 0]) cylinder(r1=r, r2=r-2.2, h=2.5);
                }
                
            // Rear upper tier
            hull() {
                translate([-w/2+r, r, 0]) cylinder(r=r, h=h_back - 2.5);
                translate([ w/2-r, r, 0]) cylinder(r=r, h=h_back - 2.5);
                translate([-w/2+r, d_back-r, 0]) cylinder(r=r, h=h_back - 2.5);
                translate([ w/2-r, d_back-r, 0]) cylinder(r=r, h=h_back - 2.5);
            }
            translate([0, 0, h_back - 2.5])
                hull() {
                    translate([-w/2+r, r, 0]) cylinder(r1=r, r2=r-2.2, h=2.5);
                    translate([ w/2-r, r, 0]) cylinder(r1=r, r2=r-2.2, h=2.5);
                    translate([-w/2+r, d_back-r, 0]) cylinder(r1=r, r2=r-2.2, h=2.5);
                    translate([ w/2-r, d_back-r, 0]) cylinder(r1=r, r2=r-2.2, h=2.5);
                }
        }
        
        // 45° Self-supporting horizontal metallic accent groove on lower tier at Z=20mm
        translate([0, d_front, 20.0])
            rotate([0, 90, 0])
                rotate([0, 0, 45])
                    cube([2.0, 2.0, w*2], center=true);
                    
        // 45° Self-supporting horizontal metallic accent groove on upper tier at Z=52mm
        translate([-w/2, 0, 52.0])
            rotate([90, 0, 0])
                rotate([0, 0, 45])
                    cube([2.0, 2.0, d_back*2], center=true);
        translate([ w/2, 0, 52.0])
            rotate([90, 0, 0])
                rotate([0, 0, 45])
                    cube([2.0, 2.0, d_back*2], center=true);
    }
}


// =============================================================================
// 5. STYLE 3: 幾何菱格鑽石切面 (ARCHITECTURAL FACETED / DIAMOND LUXURY)
// =============================================================================
module faceted_contour_tier1_2d(extra=0) {
    w = w_holder;
    d = d_front;
    polygon([
        [-w/2 - extra, 0],
        [-w/2 - extra, d - 14.0],
        [-w/2 + 14.0 - extra, d],
        [-w/3, d + extra],
        [-w/6, d - 2.0 + extra],
        [ 0, d + extra],
        [ w/6, d - 2.0 + extra],
        [ w/3, d + extra],
        [ w/2 - 14.0 + extra, d],
        [ w/2 + extra, d - 14.0],
        [ w/2 + extra, 0]
    ]);
}

module faceted_contour_tier2_2d(extra=0) {
    w = w_holder;
    d = d_back;
    polygon([
        [-w/2 - extra, 0],
        [-w/2 - extra, d - 12.0],
        [-w/2 + 12.0 - extra, d],
        [-w/3, d + extra],
        [-w/6, d - 1.5 + extra],
        [ 0, d + extra],
        [ w/6, d - 1.5 + extra],
        [ w/3, d + extra],
        [ w/2 - 12.0 + extra, d],
        [ w/2 + extra, d - 12.0],
        [ w/2 + extra, 0]
    ]);
}

module holder_tiered_faceted() {
    w = w_holder;
    union() {
        // Lower front tier
        linear_extrude(height=h_front - 2.5)
            faceted_contour_tier1_2d(0);
        translate([0, 0, h_front - 2.5])
            linear_extrude(height=2.5, scale=[(w - 3.5)/w, (d_front - 2.5)/d_front])
                faceted_contour_tier1_2d(0);
                
        // Upper rear tier
        linear_extrude(height=h_back - 2.5)
            faceted_contour_tier2_2d(0);
        translate([0, 0, h_back - 2.5])
            linear_extrude(height=2.5, scale=[(w - 3.5)/w, (d_back - 2.5)/d_back])
                faceted_contour_tier2_2d(0);
    }
}


// =============================================================================
// 6. MASTER HOLDER ASSEMBLY (STYLE SELECTOR + CAVITY SUBTRACTION)
// =============================================================================
module luxury_holder(style_type="fluted") {
    difference() {
        // Outer aesthetic styling
        if (style_type == "fluted") {
            holder_tiered_fluted();
        } else if (style_type == "curved") {
            holder_tiered_curved();
        } else {
            holder_tiered_faceted();
        }
        
        // Dovetail slide-in mounting slot on rear (with 45° pointed roof)
        female_dovetail_cavity();
        
        // Twin Oversized Toothpaste Wells in Rear Tier (Left & Right)
        twin_toothpaste_cavities();
        
        // 4 Universal Toothbrush Stations in Front Tier (Electric + Manual)
        four_universal_toothbrush_sockets();
        
        // Clean cut at Z=0 ensuring 100% planar bed adhesion
        translate([0, 0, -50.0]) cube([400.0, 400.0, 100.0], center=true);
    }
}


// =============================================================================
// 7. COLOR ASSEMBLED PREVIEW MODULES
// =============================================================================

// High-fidelity Electric Toothbrush Prop
module electric_toothbrush_prop(color_handle=[0.95, 0.95, 0.97], color_accent=[0.88, 0.58, 0.52]) {
    translate([0, 0, 8.0]) {
        // 1. Main Handle Body (Ø29mm base, height 135mm)
        color(color_handle)
            cylinder(d1=29.0, d2=27.0, h=135.0);
            
        // 2. Base Ring / Metallic Accent
        color(color_accent)
            translate([0, 0, 2.0])
                cylinder(d=29.2, h=4.0);
                
        // 3. Power Button & LED Ring
        color(color_accent)
            translate([0, 14.0, 85.0])
                rotate([90, 0, 0])
                    cylinder(d=9.0, h=2.0);
                    
        // 4. Mode Indicator LED dots
        color([0.2, 0.8, 1.0])
            for (z_led = [50.0, 58.0, 66.0])
                translate([0, 14.0, z_led])
                    rotate([90, 0, 0])
                        cylinder(d=2.0, h=2.0);
                        
        // 5. Metal Shaft Top Collar
        color([0.8, 0.8, 0.85])
            translate([0, 0, 135.0])
                cylinder(d1=16.0, d2=12.0, h=8.0);
                
        // 6. Brush Head Neck
        color(color_handle)
            translate([0, 0, 143.0])
                cylinder(d1=10.0, d2=7.0, h=65.0);
                
        // 7. Brush Head & Bristles
        color(color_handle)
            translate([0, 0, 208.0]) {
                hull() {
                    cylinder(d=11.0, h=16.0);
                    translate([0, 3.0, 8.0]) cylinder(d=8.0, h=8.0);
                }
            }
        // Bristles (White + Blue)
        color([0.3, 0.6, 0.9])
            translate([0, 8.0, 216.0])
                rotate([90, 0, 0])
                    cylinder(d=10.0, h=6.0);
    }
}

// Manual Toothbrush Prop
module manual_toothbrush_prop(color_grip=[0.2, 0.7, 0.8]) {
    translate([0, 0, 8.0]) {
        // Neck & Head
        color([0.95, 0.95, 0.95])
            translate([0, 0, 140.0]) {
                hull() {
                    cylinder(d=12.0, h=4.0);
                    translate([0, -8.0, 0]) cylinder(d=10.0, h=4.0);
                }
                // Bristles
                translate([0, -4.0, 4.0]) cube([6.0, 16.0, 10.0], center=true);
            }
        // Slender Neck
        color(color_grip)
            translate([0, 0, 100.0])
                cylinder(d=6.5, h=40.0);
        // Handle
        color(color_grip) {
            cylinder(d1=11.0, d2=13.0, h=100.0);
            sphere(d=11.0);
        }
    }
}

// Toothpaste Tube Prop
module toothpaste_prop(color_tube=[0.20, 0.55, 0.85]) {
    color(color_tube) {
        // Cap
        cylinder(d=22.0, h=18.0);
        // Tube body
        translate([0, 0, 18.0])
            scale([1.1, 0.65, 1.0])
                cylinder(r1=16.0, r2=18.0, h=85.0);
        // Folded tail
        translate([0, 0, 103.0])
            cube([42.0, 4.0, 14.0], center=true);
    }
}

// Full assembled presentation on bathroom wall tile
module preview_assembled(style_type="fluted") {
    // 1. Luxury Marble / Tile Wall
    color(wall_tile_color)
        translate([0, -3.0, 50.0])
            cube([240.0, 6.0, 260.0], center=true);
            
    // 2. Wall Bracket (mounted to wall)
    color([0.35, 0.35, 0.38])
        translate([0, 0, 4.0])
            rotate([90, 0, 0])
                wall_bracket();
                
    // 3. Main Luxury Holder (Rose Gold)
    color(rose_gold_base)
        luxury_holder(style_type);
        
    // 4. Four Toothbrush Stations (Showing Electric Toothbrushes + Manual Toothbrushes)
    // Station 1: White/Rose-Gold Electric Toothbrush (e.g. Sonicare)
    translate([-58.5, tb_y, 0]) electric_toothbrush_prop([0.96, 0.96, 0.96], rose_gold_base);
    // Station 2: Matte Black Electric Toothbrush (e.g. Oral-B iO)
    translate([-19.5, tb_y, 0]) electric_toothbrush_prop([0.22, 0.22, 0.25], accent_brass);
    // Station 3: Pastel Pink Electric Toothbrush
    translate([ 19.5, tb_y, 0]) electric_toothbrush_prop([0.94, 0.82, 0.84], rose_gold_base);
    // Station 4: Ergonomic Manual Toothbrush
    translate([ 58.5, tb_y, 0]) manual_toothbrush_prop([0.25, 0.70, 0.85]);
    
    // 5. Two Toothpaste Tubes in Rear Tier
    translate([-tp_x, tp_y, tp_floor_z]) toothpaste_prop([0.20, 0.55, 0.85]); // Tube 1 (Blue)
    translate([ tp_x, tp_y, tp_floor_z]) toothpaste_prop([0.85, 0.30, 0.35]); // Tube 2 (Red/White)
}


// =============================================================================
// 8. OUTPUT SELECTOR
// =============================================================================
if (mode == "holder") {
    // Single Holder for selected style
    color(rose_gold_base) luxury_holder(style);
} else if (mode == "bracket") {
    // Wall Slide Bracket
    color([0.35, 0.35, 0.38]) wall_bracket();
} else if (mode == "plate") {
    // 1-Plate Combo: Compact 166mm x 136mm layout (fits all standard beds, including 180x180 and 220x220)
    color(rose_gold_base) luxury_holder(style);
    color([0.35, 0.35, 0.38]) translate([0, 92.0, 0]) wall_bracket();
} else if (mode == "assembled") {
    // High-fidelity assembled preview on bathroom wall
    preview_assembled(style);
} else if (mode == "all_styles") {
    // Side-by-side visual comparison of all 3 luxury styles
    translate([-200.0, 0, 0]) preview_assembled("fluted");
    translate([   0.0, 0, 0]) preview_assembled("curved");
    translate([ 200.0, 0, 0]) preview_assembled("faceted");
}
