/*
================================================================================
Luxury Wall-Mounted Organizer: 4 Toothbrushes + 2 Toothpastes (Tiered Ergonomic)
(奢華輕奢壁掛式階梯全能置物架 - 前排四牙刷 + 後排雙牙膏)

Designed specifically for Rose Gold / Silk Metallic FDM 3D Printing:
- 100% Support-Free Printing (Pointed-arch ceilings, 45° conical drains, 0 support alert)
- Rear Tier (Tall, 58mm): 2 Generous Compartments for Toothpastes or Electric Toothbrushes
- Front Tier (Low-profile, 30mm): 4 Ergonomic Toothbrush Cradles (34mm spacing, wide funnel)
- Ultra-Smooth Operation: 14mm low front lip + self-centering gravity saddles for effortless blind access
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
// "assembled"  - Full color assembled wall preview with toothbrushes & toothpastes
// "all_styles" - Side-by-side visual comparison of all 3 styles in Rose Gold
mode = "holder";

// -----------------------------------------------------------------------------
// Dimensions & Mechanical Specifications
// -----------------------------------------------------------------------------
w_holder     = 148.0;   // Overall width (X)
d_back       = 34.0;    // Depth of rear toothpaste tier (Y)
d_front      = 64.0;    // Total depth including front toothbrush tier (Y)
h_back       = 58.0;    // Rear tier height (Z)
h_front      = 30.0;    // Front tier height (Z)
corner_r     = 12.0;    // Corner radius

// Wall Bracket & Dovetail
bracket_w    = 56.0;    // Bracket width
bracket_h    = 44.0;    // Bracket height
bracket_th   = 2.2;     // Bracket base plate thickness
dove_th      = 4.6;     // Dovetail wedge thickness
dove_w_top   = 38.0;    // Dovetail top width
dove_w_bot   = 33.0;    // Dovetail bottom width
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
            // Flat base plate (Z = 0 to bracket_th, 100% flat bed contact >2400mm²)
            hull() {
                translate([-bracket_w/2+4, 4, 0]) cylinder(r=4, h=bracket_th);
                translate([ bracket_w/2-4, 4, 0]) cylinder(r=4, h=bracket_th);
                translate([-bracket_w/2+4, bracket_h-4, 0]) cylinder(r=4, h=bracket_th);
                translate([ bracket_w/2-4, bracket_h-4, 0]) cylinder(r=4, h=bracket_th);
            }
            // Male dovetail wedge
            translate([0, 0, bracket_th])
                rotate([-90, 0, 0])
                    linear_extrude(height=bracket_h, scale=[dove_w_top/dove_w_bot, 1.0])
                        polygon([
                            [-dove_w_bot/2, 0],
                            [-dove_w_bot/2 - dove_th*tan(dove_angle), dove_th],
                            [ dove_w_bot/2 + dove_th*tan(dove_angle), dove_th],
                            [ dove_w_bot/2, 0]
                        ]);
        }
        
        // Countersunk screw holes (conical chamfer widening UPWARDS +Z, 100% self-supporting)
        for (z_screw = [12.0, 32.0]) {
            translate([0, z_screw, -1.0]) {
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

// Female dovetail receiver inside holder back (with 45° pointed arch roof)
module female_dovetail_cavity() {
    tol = 0.30;
    h_slot = bracket_h;
    w_t = dove_w_top + tol*2;
    w_b = dove_w_bot + tol*2;
    d_s = dove_th + tol;

    translate([0, -0.01, -0.5]) {
        // Main dovetail shaft
        linear_extrude(height=h_slot, scale=[w_t/w_b, 1.0])
            polygon([
                [-w_b/2, 0],
                [-w_b/2 - d_s*tan(dove_angle), d_s],
                [ w_b/2 + d_s*tan(dove_angle), d_s],
                [ w_b/2, 0]
            ]);
            
        // 45° Pointed Arch Roof on top
        translate([0, 0, h_slot])
            hull() {
                linear_extrude(height=0.1)
                    polygon([
                        [-w_t/2, 0],
                        [-w_t/2 - d_s*tan(dove_angle), d_s],
                        [ w_t/2 + d_s*tan(dove_angle), d_s],
                        [ w_t/2, 0]
                    ]);
                translate([0, d_s/2, d_s/2 + 2.0])
                    cube([w_t - d_s*2, 0.1, 0.1], center=true);
            }
    }
}

// Twin Toothpaste Wells in Rear Tier (Left X=-36, Right X=+36)
module twin_toothpaste_cavities() {
    for (x_pos = [-36.0, 36.0]) {
        translate([x_pos, 17.0, 8.0]) {
            // Generous rectangular well with rounded corners (48mm x 26mm, depth 50mm)
            hull() {
                translate([-18.0, -7.0, 0]) cylinder(r=6.0, h=h_back);
                translate([ 18.0, -7.0, 0]) cylinder(r=6.0, h=h_back);
                translate([-18.0,  7.0, 0]) cylinder(r=6.0, h=h_back);
                translate([ 18.0,  7.0, 0]) cylinder(r=6.0, h=h_back);
            }
            // Sloped self-draining funnel floor
            hull() {
                translate([-18.0, -7.0, 2.0]) cylinder(r=5.0, h=0.1);
                translate([ 18.0, -7.0, 2.0]) cylinder(r=5.0, h=0.1);
                translate([-18.0,  7.0, 2.0]) cylinder(r=5.0, h=0.1);
                translate([ 18.0,  7.0, 2.0]) cylinder(r=5.0, h=0.1);
                translate([0, 0, -9.0]) cylinder(d=8.0, h=0.1);
            }
        }
        // Vertical drainage through-hole
        translate([x_pos, 17.0, -1.0])
            cylinder(d=8.0, h=10.0);
    }
}

// 4 Ergonomic Toothbrush Cradles in Front Tier (X = -51, -17, +17, +51)
module four_ergo_toothbrush_slots() {
    for (x_pos = [-51.0, -17.0, 17.0, 51.0]) {
        translate([x_pos, 0, 0]) {
            // Wide 16mm flared front entry scoop (Height 14mm to 30mm)
            hull() {
                translate([0, d_front + 4.0, 14.0]) cylinder(d=18.0, h=h_front);
                translate([0, 48.0, 14.0]) cylinder(d=9.5, h=h_front);
            }
            
            // Neck channel
            hull() {
                translate([0, 50.0, 14.0]) cylinder(d=9.5, h=h_front);
                translate([0, 47.0, 14.0]) cylinder(d=9.5, h=h_front);
            }
            
            // Rounded saddle seat (diameter 12mm)
            translate([0, 47.0, 14.0]) cylinder(d=12.0, h=h_front);
            
            // 45° conical transition to drainage hole (self-supporting)
            translate([0, 47.0, 9.0])
                cylinder(r1=3.5, r2=6.0, h=5.5);
                
            // Vertical drainage through-hole
            translate([0, 47.0, -1.0])
                cylinder(d=7.0, h=12.0);
        }
    }
}


// =============================================================================
// 3. STYLE 1: 輕奢羅馬柱豎條紋 (FLUTED / REEDED LUXURY)
// =============================================================================
module fluted_contour_tier1_2d(rib_r=1.5, pitch=4.5) {
    r = corner_r;
    w = w_holder;
    d = d_front;
    union() {
        hull() {
            translate([-w/2+r, r]) circle(r=r);
            translate([ w/2-r, r]) circle(r=r);
            translate([-w/2+r, d-r]) circle(r=r);
            translate([ w/2-r, d-r]) circle(r=r);
        }
        for (x = [-w/2+r : pitch : w/2-r]) translate([x, d]) circle(r=rib_r);
        for (y = [r : pitch : d-r]) {
            translate([-w/2, y]) circle(r=rib_r);
            translate([ w/2, y]) circle(r=rib_r);
        }
        for (a = [90:15:180]) translate([-w/2+r + (r)*cos(a), d-r + (r)*sin(a)]) circle(r=rib_r);
        for (a = [0:15:90])   translate([ w/2-r + (r)*cos(a), d-r + (r)*sin(a)]) circle(r=rib_r);
    }
}

module fluted_contour_tier2_2d(rib_r=1.5, pitch=4.5) {
    r = corner_r;
    w = w_holder;
    d = d_back;
    union() {
        hull() {
            translate([-w/2+r, r]) circle(r=r);
            translate([ w/2-r, r]) circle(r=r);
            translate([-w/2+r, d-r]) circle(r=r);
            translate([ w/2-r, d-r]) circle(r=r);
        }
        for (x = [-w/2+r : pitch : w/2-r]) translate([x, d]) circle(r=rib_r);
        for (y = [r : pitch : d-r]) {
            translate([-w/2, y]) circle(r=rib_r);
            translate([ w/2, y]) circle(r=rib_r);
        }
        for (a = [90:15:180]) translate([-w/2+r + (r)*cos(a), d-r + (r)*sin(a)]) circle(r=rib_r);
        for (a = [0:15:90])   translate([ w/2-r + (r)*cos(a), d-r + (r)*sin(a)]) circle(r=rib_r);
    }
}

module holder_tiered_fluted() {
    union() {
        // Lower front tier (Z = 0 to 30mm)
        linear_extrude(height=h_front)
            fluted_contour_tier1_2d();
        // Upper rear tier (Z = 0 to 58mm)
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
        
        // 45° Self-supporting horizontal metallic accent groove on lower tier at Z=15mm
        translate([0, d_front, 15.0])
            rotate([0, 90, 0])
                rotate([0, 0, 45])
                    cube([1.8, 1.8, w*2], center=true);
                    
        // 45° Self-supporting horizontal metallic accent groove on upper tier at Z=44mm
        translate([-w/2, 0, 44.0])
            rotate([90, 0, 0])
                rotate([0, 0, 45])
                    cube([1.8, 1.8, d_back*2], center=true);
        translate([ w/2, 0, 44.0])
            rotate([90, 0, 0])
                rotate([0, 0, 45])
                    cube([1.8, 1.8, d_back*2], center=true);
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
        [-w/2 + 12.0 - extra, d],
        [-w/3, d + extra],
        [-w/6, d - 2.0 + extra],
        [ 0, d + extra],
        [ w/6, d - 2.0 + extra],
        [ w/3, d + extra],
        [ w/2 - 12.0 + extra, d],
        [ w/2 + extra, d - 14.0],
        [ w/2 + extra, 0]
    ]);
}

module faceted_contour_tier2_2d(extra=0) {
    w = w_holder;
    d = d_back;
    polygon([
        [-w/2 - extra, 0],
        [-w/2 - extra, d - 10.0],
        [-w/2 + 10.0 - extra, d],
        [-w/3, d + extra],
        [-w/6, d - 1.5 + extra],
        [ 0, d + extra],
        [ w/6, d - 1.5 + extra],
        [ w/3, d + extra],
        [ w/2 - 10.0 + extra, d],
        [ w/2 + extra, d - 10.0],
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
        
        // Twin Toothpaste Wells in Rear Tier (Left & Right)
        twin_toothpaste_cavities();
        
        // 4 Dedicated Ergonomic Toothbrush Cradles in Front Tier
        four_ergo_toothbrush_slots();
        
        // Clean cut at Z=0 ensuring 100% planar bed adhesion
        translate([0, 0, -50.0]) cube([300.0, 300.0, 100.0], center=true);
    }
}


// =============================================================================
// 7. COLOR ASSEMBLED PREVIEW MODULES
// =============================================================================

// Toothbrush prop for preview
module toothbrush_prop(color_grip=[0.2, 0.7, 0.8]) {
    rotate([0, 0, 0]) {
        // Head
        color([0.95, 0.95, 0.95])
            translate([0, 47.0, 42.0]) {
                hull() {
                    cylinder(d=12.0, h=4.0);
                    translate([0, -8.0, 0]) cylinder(d=10.0, h=4.0);
                }
                // Bristles
                translate([0, -4.0, 4.0]) cube([6.0, 16.0, 10.0], center=true);
            }
        // Neck
        color(color_grip)
            translate([0, 47.0, 14.0])
                cylinder(d=7.0, h=28.0);
        // Handle hanging down
        color(color_grip)
            translate([0, 47.0, -90.0]) {
                cylinder(r1=5.5, r2=4.0, h=104.0);
                sphere(r=5.5);
            }
    }
}

// Toothpaste tube prop for preview
module toothpaste_prop(color_tube=[0.20, 0.55, 0.85]) {
    color(color_tube) {
        // Cap
        cylinder(d=18.0, h=16.0);
        // Tube body
        translate([0, 0, 16.0])
            scale([1.0, 0.60, 1.0])
                cylinder(r1=14.0, r2=16.0, h=65.0);
        // Folded tail
        translate([0, 0, 81.0])
            cube([36.0, 3.0, 12.0], center=true);
    }
}

// Full assembled presentation on bathroom wall tile
module preview_assembled(style_type="fluted") {
    // 1. Luxury Marble / Tile Wall
    color(wall_tile_color)
        translate([0, -3.0, 35.0])
            cube([220.0, 6.0, 240.0], center=true);
            
    // 2. Wall Bracket (mounted to wall)
    color([0.35, 0.35, 0.38])
        translate([0, 0, 4.0])
            rotate([90, 0, 0])
                wall_bracket();
                
    // 3. Main Luxury Holder (Rose Gold)
    color(rose_gold_base)
        luxury_holder(style_type);
        
    // 4. Four Hanging Toothbrushes (X = -51, -17, +17, +51)
    translate([-51.0, 0, 0]) toothbrush_prop([0.25, 0.70, 0.85]); // Toothbrush 1
    translate([-17.0, 0, 0]) toothbrush_prop([0.90, 0.40, 0.50]); // Toothbrush 2
    translate([ 17.0, 0, 0]) toothbrush_prop([0.30, 0.75, 0.45]); // Toothbrush 3
    translate([ 51.0, 0, 0]) toothbrush_prop([0.95, 0.75, 0.20]); // Toothbrush 4
    
    // 5. Two Toothpaste Tubes in Rear Tier
    translate([-36.0, 17.0, 8.0]) toothpaste_prop([0.20, 0.55, 0.85]); // Tube 1 (Blue)
    translate([ 36.0, 17.0, 8.0]) toothpaste_prop([0.85, 0.30, 0.35]); // Tube 2 (Red/White)
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
    // 1-Plate Combo: Holder + Bracket arranged side-by-side at Z=0
    color(rose_gold_base) translate([-35.0, 0, 0]) luxury_holder(style);
    color([0.35, 0.35, 0.38]) translate([70.0, 10.0, 0]) wall_bracket();
} else if (mode == "assembled") {
    // High-fidelity assembled preview on bathroom wall
    preview_assembled(style);
} else if (mode == "all_styles") {
    // Side-by-side visual comparison of all 3 luxury styles
    translate([-180.0, 0, 0]) preview_assembled("fluted");
    translate([   0.0, 0, 0]) preview_assembled("curved");
    translate([ 180.0, 0, 0]) preview_assembled("faceted");
}
