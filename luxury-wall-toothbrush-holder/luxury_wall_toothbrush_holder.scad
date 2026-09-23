/*
================================================================================
Luxury Wall-Mounted Toothbrush & Toothpaste Organizer with Inverted Cup Dock
(奢華輕奢壁掛式全能牙刷置物架 - 帶倒扣磁吸瀝水漱口杯)

Designed specifically for Rose Gold / Silk Metallic FDM 3D Printing:
- 100% Support-Free Printing (Pointed-arch ceilings, 45° conical drains, 0 support alert)
- 4 Dedicated Toothbrush / Razor Suspension Slots (Airy, hygienic)
- Large Central Compartment for Toothpaste / Electric Toothbrush (Sloped self-draining floor)
- Bottom Inverted Rinsing Cup Dock with Magnet Cavity (Dust-proof, rapid drip-dry)
- Modular Slide-in Dovetail Wall Bracket (3M VHB tape recess + hidden screw holes)
- 3 Distinct Luxury Aesthetics:
    1. "fluted"  - 輕奢羅馬柱豎條紋 (Art Deco Continuous Fluted Columns)
    2. "curved"  - 現代意式極簡流線 (Organic Minimalist with Metallic Accent Channel)
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
// "holder"     - Main toothbrush holder body (for selected style)
// "cup"        - Matching luxury rinsing cup
// "bracket"    - Wall mounting slide bracket (fits all styles)
// "plate"      - 1-Plate combo (Holder + Cup + Bracket on Z=0 bed)
// "assembled"  - Full color assembled wall preview with inverted cup & accessories
// "all_styles" - Side-by-side visual comparison of all 3 styles in Rose Gold
mode = "holder";

// -----------------------------------------------------------------------------
// Dimensions & Mechanical Specifications
// -----------------------------------------------------------------------------
w_holder     = 126.0;   // Overall width (X)
d_holder     = 58.0;    // Overall depth from wall (Y)
h_holder     = 56.0;    // Main body height (Z)
corner_r     = 12.0;    // Corner radius

// Central Toothpaste / Electric Toothbrush Caddy
caddy_w      = 44.0;    // Caddy width
caddy_d      = 32.0;    // Caddy depth
caddy_r      = 8.0;     // Caddy corner radius
caddy_floor  = 9.0;     // Bottom floor thickness

// Wall Bracket & Dovetail
bracket_w    = 46.0;    // Bracket width
bracket_h    = 44.0;    // Bracket height
bracket_th   = 2.0;     // Bracket base plate thickness
dove_th      = 4.6;     // Dovetail wedge thickness
dove_w_top   = 31.0;    // Dovetail top width
dove_w_bot   = 26.5;    // Dovetail bottom width
dove_angle   = 15.0;    // Dovetail overhang angle

// Magnet Pocket (Standard 10x2 mm Neodymium disc magnet)
magnet_d     = 10.2;    // Magnet pocket diameter (with tolerance)
magnet_h     = 2.4;     // Magnet pocket depth

// Luxury Cup Dimensions
cup_h        = 88.0;    // Cup height
cup_r_top    = 34.0;    // Rim radius (OD = 68mm)
cup_r_bot    = 25.5;    // Base radius (OD = 51mm)
cup_wall     = 2.2;     // Cup wall thickness
dock_lip_d   = 47.2;    // Inverted docking boss outer diameter
dock_lip_h   = 2.2;     // Inverted docking boss depth

// Rose Gold Material Colors
rose_gold_base  = [0.88, 0.58, 0.52];
rose_gold_dark  = [0.76, 0.46, 0.42];
rose_gold_light = [0.95, 0.70, 0.64];
accent_brass    = [0.82, 0.65, 0.38];
cup_translucent = [0.94, 0.78, 0.74, 0.85];
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
// 2. INTERNAL CAVITIES & MECHANICAL INTERFACES (100% SELF-SUPPORTING)
// =============================================================================

// Female dovetail receiver inside holder back (with 45° self-supporting pointed roof)
module female_dovetail_cavity() {
    tol = 0.30; // 0.30mm sliding tolerance per side
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
            
        // 45° Pointed Arch Roof on top (eliminates horizontal bridging)
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

// Central Toothpaste / Electric Toothbrush Cavity with Sloped Draining Floor
module central_caddy_cavity() {
    translate([0, 32.0, caddy_floor]) {
        hull() {
            translate([-caddy_w/2+caddy_r, -caddy_d/2+caddy_r, 0]) cylinder(r=caddy_r, h=h_holder);
            translate([ caddy_w/2-caddy_r, -caddy_d/2+caddy_r, 0]) cylinder(r=caddy_r, h=h_holder);
            translate([-caddy_w/2+caddy_r,  caddy_d/2-caddy_r, 0]) cylinder(r=caddy_r, h=h_holder);
            translate([ caddy_w/2-caddy_r,  caddy_d/2-caddy_r, 0]) cylinder(r=caddy_r, h=h_holder);
        }
        
        // Sloped drainage funnel floor
        hull() {
            translate([-caddy_w/2+caddy_r, -caddy_d/2+caddy_r, 2.0]) cylinder(r=caddy_r-1, h=0.1);
            translate([ caddy_w/2-caddy_r, -caddy_d/2+caddy_r, 2.0]) cylinder(r=caddy_r-1, h=0.1);
            translate([-caddy_w/2+caddy_r,  caddy_d/2-caddy_r, 2.0]) cylinder(r=caddy_r-1, h=0.1);
            translate([ caddy_w/2-caddy_r,  caddy_d/2-caddy_r, 2.0]) cylinder(r=caddy_r-1, h=0.1);
            translate([0, 0, -caddy_floor - 1.0]) cylinder(d=10.0, h=0.1);
        }
    }
    
    // Bottom weep chimney
    translate([0, 32.0, -1.0])
        cylinder(d=10.0, h=caddy_floor + 3.0);
}

// Toothbrush suspension slot (with funneled lead-in, circular rest pocket, and 45° conical drain)
module toothbrush_slot(x_pos) {
    translate([x_pos, 0, 0]) {
        // Funneled entrance from front face
        hull() {
            translate([0, d_holder + 4.0, 14.0]) cylinder(d=14.0, h=h_holder);
            translate([0, 48.0, 14.0]) cylinder(d=8.2, h=h_holder);
        }
        
        // Neck transition
        hull() {
            translate([0, 48.0, 14.0]) cylinder(d=8.2, h=h_holder);
            translate([0, 38.0, 14.0]) cylinder(d=8.2, h=h_holder);
        }
        
        // Circular resting pocket (holds toothbrush neck securely)
        translate([0, 38.0, 14.0]) cylinder(d=10.8, h=h_holder);
        
        // 45° conical transition to drainage hole (self-supporting)
        translate([0, 38.0, 9.5])
            cylinder(r1=3.0, r2=5.4, h=4.6);
            
        // Vertical drainage through-hole
        translate([0, 38.0, -1.0]) cylinder(d=6.0, h=12.0);
    }
}

// Bottom Inverted Cup Docking Station (with magnet pocket, 45° conical transition & centering ring)
module bottom_cup_dock_cavity() {
    translate([0, 32.0, -0.1]) {
        // Centering entry ring (fits 51.0mm cup base with 0.7mm clearance)
        cylinder(r1=26.2, r2=24.5, h=2.5);
        
        // 45° conical transition (eliminates horizontal bridging)
        translate([0, 0, 2.4])
            cylinder(r1=24.5, r2=12.0, h=6.5);
            
        // Magnet pocket with 45° pointed cone roof
        translate([0, 0, 2.4]) {
            cylinder(d=magnet_d, h=magnet_h);
            translate([0, 0, magnet_h - 0.1])
                cylinder(r1=magnet_d/2, r2=0.1, h=3.6);
        }
        
        // Central weep hole through to caddy
        cylinder(d=10.0, h=16.0);
    }
}


// =============================================================================
// 3. STYLE 1: 輕奢羅馬柱豎條紋 (FLUTED / REEDED LUXURY)
// =============================================================================
module fluted_contour_2d(rib_r=1.5, pitch=4.5) {
    r = corner_r;
    w = w_holder;
    d = d_holder;
    
    union() {
        // Base rounded body contour
        hull() {
            translate([-w/2+r, r]) circle(r=r);
            translate([ w/2-r, r]) circle(r=r);
            translate([-w/2+r, d-r]) circle(r=r);
            translate([ w/2-r, d-r]) circle(r=r);
        }
        
        // Front convex ribs
        for (x = [-w/2+r : pitch : w/2-r]) {
            translate([x, d]) circle(r=rib_r);
        }
        // Left & Right side ribs
        for (y = [r : pitch : d-r]) {
            translate([-w/2, y]) circle(r=rib_r);
            translate([ w/2, y]) circle(r=rib_r);
        }
        // Front-left curved corner ribs
        for (a = [90:15:180]) {
            translate([-w/2+r + (r)*cos(a), d-r + (r)*sin(a)]) circle(r=rib_r);
        }
        // Front-right curved corner ribs
        for (a = [0:15:90]) {
            translate([w/2-r + (r)*cos(a), d-r + (r)*sin(a)]) circle(r=rib_r);
        }
    }
}

module holder_outer_fluted() {
    // 100% Continuous Vertical Fluted Columns (0 Bridges, 0 Overhangs)
    linear_extrude(height=h_holder) fluted_contour_2d();
}


// =============================================================================
// 4. STYLE 2: 現代意式極簡流線 (CURVED STREAMLINE LUXURY)
// =============================================================================
module holder_outer_curved() {
    w = w_holder;
    d = d_holder;
    h = h_holder;
    r = 14.0;

    difference() {
        // Organic rounded body with integrated top waterfall chamfer
        union() {
            // Main body
            hull() {
                translate([-w/2+r, r, 0]) cylinder(r=r, h=h - 2.5);
                translate([ w/2-r, r, 0]) cylinder(r=r, h=h - 2.5);
                translate([-w/2+r, d-r, 0]) cylinder(r=r, h=h - 2.5);
                translate([ w/2-r, d-r, 0]) cylinder(r=r, h=h - 2.5);
            }
            // Top waterfall chamfer cap (45°)
            translate([0, 0, h - 2.5])
                hull() {
                    translate([-w/2+r, r, 0]) cylinder(r1=r, r2=r-2.2, h=2.5);
                    translate([ w/2-r, r, 0]) cylinder(r1=r, r2=r-2.2, h=2.5);
                    translate([-w/2+r, d-r, 0]) cylinder(r1=r, r2=r-2.2, h=2.5);
                    translate([ w/2-r, d-r, 0]) cylinder(r1=r, r2=r-2.2, h=2.5);
                }
        }
        
        // 45° Self-supporting horizontal metallic accent groove at Z=28mm
        translate([0, d, 28.0])
            rotate([0, 90, 0])
                rotate([0, 0, 45])
                    cube([1.8, 1.8, w*2], center=true);
        translate([-w/2, 0, 28.0])
            rotate([90, 0, 0])
                rotate([0, 0, 45])
                    cube([1.8, 1.8, d*2], center=true);
        translate([ w/2, 0, 28.0])
            rotate([90, 0, 0])
                rotate([0, 0, 45])
                    cube([1.8, 1.8, d*2], center=true);
    }
}


// =============================================================================
// 5. STYLE 3: 幾何菱格鑽石切面 (ARCHITECTURAL FACETED / DIAMOND LUXURY)
// =============================================================================
module faceted_contour_2d(extra=0) {
    w = w_holder;
    d = d_holder;
    // Multi-faceted geometric polygon with crisp architectural planes
    polygon([
        [-w/2 - extra, 0],
        [-w/2 - extra, d - 14.0],
        [-w/2 + 10.0 - extra, d],
        [-w/3, d + extra],
        [-w/6, d - 2.0 + extra],
        [ 0, d + extra],
        [ w/6, d - 2.0 + extra],
        [ w/3, d + extra],
        [ w/2 - 10.0 + extra, d],
        [ w/2 + extra, d - 14.0],
        [ w/2 + extra, 0]
    ]);
}

module holder_outer_faceted() {
    w = w_holder;
    d = d_holder;
    h = h_holder;
    
    union() {
        // Main faceted column body
        linear_extrude(height=h - 2.5)
            faceted_contour_2d(0);
            
        // Top architectural geometric chamfer (45°)
        translate([0, 0, h - 2.5])
            linear_extrude(height=2.5, scale=[(w - 3.5)/w, (d - 2.5)/d])
                faceted_contour_2d(0);
    }
}


// =============================================================================
// 6. MASTER HOLDER ASSEMBLY (STYLE SELECTOR + CAVITY SUBTRACTION)
// =============================================================================
module luxury_holder(style_type="fluted") {
    difference() {
        // Outer aesthetic styling
        if (style_type == "fluted") {
            holder_outer_fluted();
        } else if (style_type == "curved") {
            holder_outer_curved();
        } else {
            holder_outer_faceted();
        }
        
        // Dovetail slide-in mounting slot on rear (with 45° pointed roof)
        female_dovetail_cavity();
        
        // Central Toothpaste / Electric Toothbrush caddy
        central_caddy_cavity();
        
        // 4 Dedicated Toothbrush Suspension Slots
        toothbrush_slot(-51.0);  // Left outer slot
        toothbrush_slot(-34.0);  // Left inner slot
        toothbrush_slot( 34.0);  // Right inner slot
        toothbrush_slot( 51.0);  // Right outer slot
        
        // Bottom Inverted Cup Docking Station (with self-supporting 45° ceilings)
        bottom_cup_dock_cavity();
        
        // Clean cut at Z=0 ensuring 100% planar bed adhesion
        translate([0, 0, -50.0]) cube([300.0, 300.0, 100.0], center=true);
    }
}


// =============================================================================
// 7. MATCHING LUXURY RINSING CUP (倒扣奢華瀝水漱口杯)
// =============================================================================
module luxury_cup(style_type="fluted") {
    difference() {
        union() {
            // Main tapered conical body (100% self-supporting draft angles)
            cylinder(r1=cup_r_bot, r2=cup_r_top, h=cup_h);
            
            // Texture matching holder style
            if (style_type == "fluted") {
                // Reeded flutes around middle body
                n_flutes = 32;
                translate([0, 0, 10.0])
                    for (i = [0:n_flutes-1]) {
                        rotate([0, 0, i * 360/n_flutes])
                            translate([(cup_r_bot + cup_r_top)/2 - 0.4, 0, 0])
                                cylinder(r=1.2, h=cup_h - 22.0, $fn=16);
                    }
            } else if (style_type == "curved") {
                // Ergonomic waist curve ring
                translate([0, 0, cup_h * 0.42])
                    rotate_extrude()
                        translate([ (cup_r_bot + cup_r_top)/2 + 0.3, 0 ])
                            circle(r=1.5, $fn=24);
            } else {
                // Faceted lower diamond belt
                n_facets = 16;
                translate([0, 0, 14.0])
                    for (i = [0:n_facets-1]) {
                        rotate([0, 0, i * 360/n_facets])
                            translate([cup_r_bot + 0.4, 0, 0])
                                rotate([0, 25.0, 0])
                                    cube([2.0, 5.0, 16.0], center=true);
                    }
            }
        }
        
        // Smooth interior cavity with generous bottom radius (easy to clean)
        translate([0, 0, 5.0])
            cylinder(r1=cup_r_bot - cup_wall, r2=cup_r_top - cup_wall, h=cup_h + 2.0);
            
        // Solid Flat Base with Centered Conical Magnet Pocket (100% Self-Supporting, 0 Bridges)
        translate([0, 0, -0.1]) {
            cylinder(d=magnet_d, h=magnet_h);
            translate([0, 0, magnet_h - 0.1])
                cylinder(r1=magnet_d/2, r2=0.1, h=3.0);
        }
    }
}


// =============================================================================
// 8. COLOR ASSEMBLED PREVIEW MODULES
// =============================================================================

// Toothbrush prop for preview
module toothbrush_prop(color_grip=[0.2, 0.7, 0.8]) {
    rotate([0, 0, 0]) {
        // Head
        color([0.95, 0.95, 0.95])
            translate([0, 38.0, 42.0]) {
                hull() {
                    cylinder(d=12.0, h=4.0);
                    translate([0, -8.0, 0]) cylinder(d=10.0, h=4.0);
                }
                // Bristles
                translate([0, -4.0, 4.0]) cube([6.0, 16.0, 10.0], center=true);
            }
        // Neck
        color(color_grip)
            translate([0, 38.0, 14.0])
                cylinder(d=7.0, h=28.0);
        // Handle hanging down
        color(color_grip)
            translate([0, 38.0, -90.0]) {
                cylinder(r1=5.5, r2=4.0, h=104.0);
                sphere(r=5.5);
            }
    }
}

// Toothpaste tube prop for preview
module toothpaste_prop() {
    color([0.20, 0.55, 0.85])
        translate([0, 32.0, 10.0]) {
            // Cap
            cylinder(d=18.0, h=18.0);
            // Tube body
            translate([0, 0, 18.0])
                scale([1.0, 0.65, 1.0])
                    cylinder(r1=14.0, r2=16.0, h=70.0);
            // Folded tail
            translate([0, 0, 88.0])
                cube([38.0, 3.0, 14.0], center=true);
        }
}

// Full assembled presentation on bathroom wall tile
module preview_assembled(style_type="fluted") {
    // 1. Luxury Marble / Tile Wall
    color(wall_tile_color)
        translate([0, -3.0, 30.0])
            cube([220.0, 6.0, 240.0], center=true);
            
    // 2. Wall Bracket (mounted to wall)
    color([0.35, 0.35, 0.38])
        translate([0, 0, 4.0])
            rotate([90, 0, 0])
                wall_bracket();
                
    // 3. Main Luxury Holder (Rose Gold)
    color(rose_gold_base)
        luxury_holder(style_type);
        
    // 4. Inverted Rinsing Cup Docked Underneath
    color(rose_gold_light)
        translate([0, 32.0, -cup_h])
            rotate([180, 0, 0])
                translate([0, 0, -cup_h])
                    luxury_cup(style_type);
                    
    // 5. Four Hanging Toothbrushes (precisely aligned in slots X = -51, -34, +34, +51)
    translate([-51.0, 0, 0]) toothbrush_prop([0.25, 0.70, 0.85]); // Outer Left
    translate([-34.0, 0, 0]) toothbrush_prop([0.90, 0.40, 0.50]); // Inner Left
    translate([ 34.0, 0, 0]) toothbrush_prop([0.30, 0.75, 0.45]); // Inner Right
    translate([ 51.0, 0, 0]) toothbrush_prop([0.95, 0.75, 0.20]); // Outer Right
    
    // 6. Central Toothpaste Tube
    toothpaste_prop();
}


// =============================================================================
// 9. OUTPUT SELECTOR
// =============================================================================
if (mode == "holder") {
    // Single Holder for selected style
    color(rose_gold_base) luxury_holder(style);
} else if (mode == "cup") {
    // Single Cup for selected style
    color(rose_gold_light) luxury_cup(style);
} else if (mode == "bracket") {
    // Wall Slide Bracket
    color([0.35, 0.35, 0.38]) wall_bracket();
} else if (mode == "plate") {
    // 1-Plate Combo: Holder + Cup + Bracket arranged side-by-side at Z=0
    color(rose_gold_base) translate([-70.0, 0, 0]) luxury_holder(style);
    color(rose_gold_light) translate([25.0, 30.0, 0]) luxury_cup(style);
    color([0.35, 0.35, 0.38]) translate([85.0, 8.0, 0]) wall_bracket();
} else if (mode == "assembled") {
    // High-fidelity assembled preview on bathroom wall
    preview_assembled(style);
} else if (mode == "all_styles") {
    // Side-by-side visual comparison of all 3 luxury styles
    translate([-160.0, 0, 0]) preview_assembled("fluted");
    translate([   0.0, 0, 0]) preview_assembled("curved");
    translate([ 160.0, 0, 0]) preview_assembled("faceted");
}
