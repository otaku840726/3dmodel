/*
================================================================================
Luxury Wall-Mounted Organizer: Front-Release Toothbrush Cradles + Twin Toothpastes
(奢華輕奢壁掛式全能置物架 - 前推前取懸掛牙刷座 + 後排雙超大牙膏艙)

Designed specifically for Rose Gold / Silk Metallic FDM 3D Printing:
- 100% Support-Free Printing (Pointed-arch ceilings, 45° self-supporting corbels, 0 support alert)
- DIRECT FRONT INSERTION & RETRIEVAL (直接從前方推入與取出，無須上下抬放):
  * Front Tier (H=48mm): 4 Front-Loading Cantilevered Cradles (X = -54, -18, +18, +54)
    holding toothbrushes at the upper neck / brush head transition.
  * Direct Horizontal Action: Push horizontally to dock, pull horizontally forward to release!
    Zero vertical clearance required — ideal under mirror cabinets and shelves!
  * Universal Fit: Accommodates thick electric toothbrush necks (Oral-B iO/Pro, Sonicare,
    Xiaomi) in the 13.5mm saddle with 24mm flared lead-in, and manual toothbrushes in the
    inner 8.5mm rear notch.
  * 360° Open Air Drip: Handles hang freely in open air; zero standing water, zero mold!
- Rear Tier (H=66mm, Depth 56mm): 2 Generous Compartments (50mm x 26mm) for 200g
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
// "holder"     - Main front-release organizer body (for selected style)
// "bracket"    - Wall mounting slide bracket (fits all styles)
// "plate"      - 1-Plate combo (Holder + Bracket on Z=0 bed)
// "assembled"  - Full color assembled wall preview with front-hung electric toothbrushes & toothpastes
// "all_styles" - Side-by-side visual comparison of all 3 styles in Rose Gold
mode = "holder";

// -----------------------------------------------------------------------------
// Dimensions & Mechanical Specifications
// -----------------------------------------------------------------------------
w_holder     = 160.0;   // Overall width (X)
d_back       = 36.0;    // Depth of rear toothpaste tier (Y)
d_front      = 68.0;    // Total depth to tip of front cantilevered cradles (Y)
h_back       = 66.0;    // Rear tier height (Z)
h_fork       = 48.0;    // Front fork landing level (Z)
corner_r     = 10.0;    // Outer corner radius

// Front Toothbrush Stations (X = -54, -18, +18, +54)
tb_pitch     = 36.0;    // Center-to-center pitch
tb_throat_w  = 13.5;    // Throat width for electric brush necks
tb_entrance_w= 24.0;    // Flared front entry width
tb_saddle_y  = 52.0;    // Center Y position of cradle saddle
tb_inner_w   = 8.5;     // Inner rear notch width for slim manual toothbrushes

// Rear Toothpaste Compartments
tp_w         = 50.0;    // Compartment width (X)
tp_d         = 26.0;    // Compartment depth (Y)
tp_x         = 40.0;    // Center X offset (Left: -40, Right: +40)
tp_y         = 18.0;    // Center Y position
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
// 2. INTERNAL CAVITIES & FRONT-RELEASE CRADLE SLOTS (100% SELF-SUPPORTING)
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

// Twin Oversized Toothpaste Wells in Rear Tier (Left X=-40, Right X=+40)
module twin_toothpaste_cavities() {
    for (x_pos = [-tp_x, tp_x]) {
        translate([x_pos, tp_y, tp_floor_z]) {
            // Rounded rectangular well (48mm x 26mm, depth 56mm)
            hull() {
                translate([-tp_w/2 + 6.0, -tp_d/2 + 6.0, 0]) cylinder(r=6.0, h=h_back);
                translate([ tp_w/2 - 6.0, -tp_d/2 + 6.0, 0]) cylinder(r=6.0, h=h_back);
                translate([-tp_w/2 + 6.0,  tp_d/2 - 6.0, 0]) cylinder(r=6.0, h=h_back);
                translate([ tp_w/2 - 6.0,  tp_d/2 - 6.0, 0]) cylinder(r=6.0, h=h_back);
            }
            // Sloped self-draining funnel floor (12° slope)
            hull() {
                translate([-tp_w/2 + 6.0, -tp_d/2 + 6.0, 3.0]) cylinder(r=5.0, h=0.1);
                translate([ tp_w/2 - 6.0, -tp_d/2 + 6.0, 3.0]) cylinder(r=5.0, h=0.1);
                translate([-tp_w/2 + 6.0,  tp_d/2 - 6.0, 3.0]) cylinder(r=5.0, h=0.1);
                translate([ tp_w/2 - 6.0,  tp_d/2 - 6.0, 3.0]) cylinder(r=5.0, h=0.1);
                translate([0, 0, -tp_floor_z - 0.1]) cylinder(d=8.0, h=0.1);
            }
        }
        // Vertical drainage through-hole
        translate([x_pos, tp_y, -1.0])
            cylinder(d=8.0, h=tp_floor_z + 2.0);
    }
}

// 4 Front-Release Cantilevered Fork Slots (X = -54, -18, +18, +54)
module four_front_release_slots() {
    for (i = [0:3]) {
        x_pos = (i - 1.5) * tb_pitch; // -54, -18, 18, 54
        
        translate([x_pos, 0, 0]) {
            // 1. Through-slot from front (horizontal insertion/removal)
            // Throat for electric brush neck
            hull() {
                translate([0, tb_saddle_y, h_fork - 10.0])
                    cylinder(d=tb_throat_w, h=30.0);
                translate([0, d_front + 4.0, h_fork - 10.0])
                    cylinder(d=tb_throat_w, h=30.0);
            }
            
            // 2. Wide Flared 45° Front Mouth (24mm wide entry at front face)
            translate([0, d_front - 2.0, h_fork - 10.0])
                hull() {
                    translate([0, 0, 0])
                        cube([tb_throat_w, 0.1, 30.0], center=true);
                    translate([0, 8.0, 0])
                        cube([tb_entrance_w, 0.1, 30.0], center=true);
                }
                
            // 3. Inner Notch for Slim Manual Toothbrushes (8.5mm wide at deepest point)
            hull() {
                translate([0, tb_saddle_y - 6.0, h_fork - 10.0])
                    cylinder(d=tb_inner_w, h=30.0);
                translate([0, tb_saddle_y, h_fork - 10.0])
                    cylinder(d=tb_inner_w, h=30.0);
            }
            
            // 4. Contoured Landing Saddle (3.0mm deep recess at tb_saddle_y)
            translate([0, tb_saddle_y, h_fork - 3.0])
                cylinder(r1=tb_throat_w/2, r2=20.0/2, h=3.1);
                
            // 5. Smooth 45° Front Exit Ramp (enables effortless forward slide-out)
            hull() {
                translate([0, tb_saddle_y + 1.0, h_fork - 3.0])
                    cube([tb_throat_w, 0.1, 3.1], center=true);
                translate([0, tb_saddle_y + 5.0, h_fork])
                    cube([tb_throat_w, 0.1, 0.1], center=true);
            }
        }
    }
}


// =============================================================================
// 3. SOLID GEOMETRY BUILDER (45° SELF-SUPPORTING CORBEL ARMS)
// =============================================================================

// Base solid body with rear tier and 4 forward cantilevered corbel arms
module base_holder_structure() {
    w = w_holder;
    r = corner_r;
    
    union() {
        // 1. Rear Tier Solid Block (Y = 0 to d_back, Z = 0 to h_back)
        hull() {
            translate([-w/2+r, r, 0]) cylinder(r=r, h=h_back);
            translate([ w/2-r, r, 0]) cylinder(r=r, h=h_back);
            translate([-w/2+r, d_back-r, 0]) cylinder(r=r, h=h_back);
            translate([ w/2-r, d_back-r, 0]) cylinder(r=r, h=h_back);
        }
        
        // 2. Continuous Backrest Baffle below rear tier
        hull() {
            translate([-w/2+r, r, 0]) cylinder(r=r, h=h_fork);
            translate([ w/2-r, r, 0]) cylinder(r=r, h=h_fork);
            translate([-w/2+r, d_back, 0]) cube([0.1, 0.1, h_fork]);
            translate([ w/2-r, d_back, 0]) cube([0.1, 0.1, h_fork]);
        }
        
        // 3. Four Forward Cantilevered Corbel Arms (45° Underside slope, 100% self-supporting)
        for (i = [0:3]) {
            x_pos = (i - 1.5) * tb_pitch; // -54, -18, 18, 54
            
            translate([x_pos, 0, 0]) {
                hull() {
                    // Arm root at rear tier front face (Y = d_back)
                    // Slopes down from Z=h_fork to Z=h_fork - (d_front - d_back) = 16.0mm
                    translate([0, d_back, 16.0])
                        cube([31.0, 0.1, h_fork - 16.0], center=true);
                    translate([0, d_back, h_fork/2])
                        cube([31.0, 0.1, h_fork], center=true);
                        
                    // Arm cantilever tip at front (Y = d_front)
                    translate([-31.0/2 + 4.0, d_front - 4.0, h_fork - 8.0])
                        cylinder(r=4.0, h=8.0);
                    translate([ 31.0/2 - 4.0, d_front - 4.0, h_fork - 8.0])
                        cylinder(r=4.0, h=8.0);
                }
            }
        }
    }
}


// =============================================================================
// 4. THREE AESTHETIC STYLES (ROSE GOLD SILK OPTIMIZED)
// =============================================================================

// STYLE 1: 輕奢羅馬柱豎條紋 (FLUTED / REEDED LUXURY)
module holder_style_fluted() {
    w = w_holder;
    r = corner_r;
    pitch = 4.8;
    rib_r = 1.4;
    
    union() {
        base_holder_structure();
        
        // Vertical decorative flutes along rear tier sides and front face
        for (x = [-w/2+r : pitch : w/2-r]) {
            // Above fork level (Z = h_fork to h_back)
            translate([x, d_back, h_fork])
                cylinder(r=rib_r, h=h_back - h_fork);
        }
        for (y = [r : pitch : d_back-r]) {
            translate([-w/2, y, 0]) cylinder(r=rib_r, h=h_back);
            translate([ w/2, y, 0]) cylinder(r=rib_r, h=h_back);
        }
        
        // Architectural reeded ribs on the sides of each cantilever arm
        for (i = [0:3]) {
            x_pos = (i - 1.5) * tb_pitch;
            for (y = [d_back + 4.0 : pitch : d_front - 4.0]) {
                z_bot = 16.0 + (y - d_back); // follows 45° corbel slope
                translate([x_pos - 15.5, y, z_bot])
                    cylinder(r=rib_r, h=h_fork - z_bot);
                translate([x_pos + 15.5, y, z_bot])
                    cylinder(r=rib_r, h=h_fork - z_bot);
            }
        }
    }
}

// STYLE 2: 現代意式極簡流線 (CURVED STREAMLINE LUXURY)
module holder_style_curved() {
    w = w_holder;
    
    difference() {
        base_holder_structure();
        
        // 45° Self-supporting horizontal metallic accent groove on rear tier at Z=56mm
        translate([-w/2, 0, 56.0])
            rotate([90, 0, 0])
                rotate([0, 0, 45])
                    cube([1.8, 1.8, d_back*2], center=true);
        translate([ w/2, 0, 56.0])
            rotate([90, 0, 0])
                rotate([0, 0, 45])
                    cube([1.8, 1.8, d_back*2], center=true);
        translate([0, d_back, 56.0])
            rotate([0, 90, 0])
                rotate([0, 0, 45])
                    cube([1.8, 1.8, w*2], center=true);
                    
        // Top edge waterfall chamfer
        translate([0, 0, h_back])
            rotate([0, 90, 0])
                rotate([0, 0, 45])
                    cube([2.5, 2.5, w*2], center=true);
    }
}

// STYLE 3: 幾何菱格鑽石切面 (ARCHITECTURAL FACETED / DIAMOND LUXURY)
module holder_style_faceted() {
    difference() {
        base_holder_structure();
        
        // Faceted angular cuts on the outer top corners
        translate([-w_holder/2, 0, h_back])
            rotate([0, 45, 0])
                cube([10.0, d_back*3, 10.0], center=true);
        translate([ w_holder/2, 0, h_back])
            rotate([0, 45, 0])
                cube([10.0, d_back*3, 10.0], center=true);
    }
}


// =============================================================================
// 5. MASTER HOLDER ASSEMBLY
// =============================================================================
module luxury_holder(style_type="fluted") {
    difference() {
        // Outer styling
        if (style_type == "fluted") {
            holder_style_fluted();
        } else if (style_type == "curved") {
            holder_style_curved();
        } else {
            holder_style_faceted();
        }
        
        // Dovetail slide-in mounting slot on rear (with 45° pointed roof)
        female_dovetail_cavity();
        
        // Twin Oversized Toothpaste Wells in Rear Tier (Left & Right)
        twin_toothpaste_cavities();
        
        // 4 Front-Release Cantilevered Fork Slots
        four_front_release_slots();
        
        // Clean cut at Z=0 ensuring 100% planar bed adhesion
        translate([0, 0, -50.0]) cube([400.0, 400.0, 100.0], center=true);
    }
}


// =============================================================================
// 6. COLOR ASSEMBLED PREVIEW MODULES
// =============================================================================

// High-fidelity Electric Toothbrush Prop (Hanging by the upper neck)
module electric_toothbrush_prop(color_handle=[0.95, 0.95, 0.97], color_accent=[0.88, 0.58, 0.52]) {
    // Origin is at the resting cradle position (Z=h_fork - 3.0 = 45.0, Y=tb_saddle_y = 52.0)
    translate([0, tb_saddle_y, h_fork - 3.0]) {
        // 1. Hanging Handle Body (Ø29mm base, hanging down into open air)
        color(color_handle)
            translate([0, 0, -135.0])
                cylinder(d1=29.0, d2=27.0, h=135.0);
                
        // 2. Base Ring / Metallic Accent
        color(color_accent)
            translate([0, 0, -133.0])
                cylinder(d=29.2, h=4.0);
                
        // 3. Power Button & LED Ring
        color(color_accent)
            translate([0, 14.0, -50.0])
                rotate([90, 0, 0])
                    cylinder(d=9.0, h=2.0);
                    
        // 4. Mode Indicator LED dots
        color([0.2, 0.8, 1.0])
            for (z_led = [-85.0, -77.0, -69.0])
                translate([0, 14.0, z_led])
                    rotate([90, 0, 0])
                        cylinder(d=2.0, h=2.0);
                        
        // 5. Metal Shaft Top Collar (rests inside the cradle saddle)
        color([0.8, 0.8, 0.85])
            translate([0, 0, 0])
                cylinder(d1=16.0, d2=11.5, h=8.0);
                
        // 6. Brush Head Neck (extends upwards)
        color(color_handle)
            translate([0, 0, 8.0])
                cylinder(d1=10.5, d2=7.0, h=55.0);
                
        // 7. Brush Head & Bristles
        color(color_handle)
            translate([0, 0, 63.0]) {
                hull() {
                    cylinder(d=11.0, h=16.0);
                    translate([0, 3.0, 8.0]) cylinder(d=8.0, h=8.0);
                }
            }
        // Bristles (Blue + White)
        color([0.3, 0.6, 0.9])
            translate([0, 8.0, 71.0])
                rotate([90, 0, 0])
                    cylinder(d=10.0, h=6.0);
    }
}

// Manual Toothbrush Prop (Hanging by the neck below the head)
module manual_toothbrush_prop(color_grip=[0.2, 0.7, 0.8]) {
    translate([0, tb_saddle_y, h_fork - 3.0]) {
        // Handle hanging down
        color(color_grip)
            translate([0, 0, -115.0]) {
                cylinder(d1=11.0, d2=13.0, h=115.0);
                sphere(d=11.0);
            }
        // Slender Neck inside cradle
        color(color_grip)
            translate([0, 0, 0])
                cylinder(d=6.5, h=25.0);
        // Head & Bristles above
        color([0.95, 0.95, 0.95])
            translate([0, 0, 25.0]) {
                hull() {
                    cylinder(d=12.0, h=4.0);
                    translate([0, -8.0, 0]) cylinder(d=10.0, h=4.0);
                }
                // Bristles
                translate([0, -4.0, 4.0]) cube([6.0, 16.0, 10.0], center=true);
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
                cylinder(r1=15.0, r2=17.0, h=80.0);
        // Folded tail
        translate([0, 0, 98.0])
            cube([40.0, 4.0, 14.0], center=true);
    }
}

// Full assembled presentation on bathroom wall tile
module preview_assembled(style_type="fluted") {
    // 1. Luxury Marble / Tile Wall
    color(wall_tile_color)
        translate([0, -3.0, 15.0])
            cube([240.0, 6.0, 260.0], center=true);
            
    // 2. Wall Bracket (mounted to wall)
    color([0.35, 0.35, 0.38])
        translate([0, 0, 4.0])
            rotate([90, 0, 0])
                wall_bracket();
                
    // 3. Main Luxury Holder (Rose Gold)
    color(rose_gold_base)
        luxury_holder(style_type);
        
    // 4. Four Hanging Toothbrushes (Front-Loaded!)
    // Station 1: White/Rose-Gold Electric Toothbrush (e.g. Sonicare)
    translate([-54.0, 0, 0]) electric_toothbrush_prop([0.96, 0.96, 0.96], rose_gold_base);
    // Station 2: Matte Black Electric Toothbrush (e.g. Oral-B iO)
    translate([-18.0, 0, 0]) electric_toothbrush_prop([0.22, 0.22, 0.25], accent_brass);
    // Station 3: Pastel Pink Electric Toothbrush
    translate([ 18.0, 0, 0]) electric_toothbrush_prop([0.94, 0.82, 0.84], rose_gold_base);
    // Station 4: Ergonomic Manual Toothbrush
    translate([ 54.0, 0, 0]) manual_toothbrush_prop([0.25, 0.70, 0.85]);
    
    // 5. Two Toothpaste Tubes in Rear Tier
    translate([-tp_x, tp_y, tp_floor_z]) toothpaste_prop([0.20, 0.55, 0.85]); // Tube 1 (Blue)
    translate([ tp_x, tp_y, tp_floor_z]) toothpaste_prop([0.85, 0.30, 0.35]); // Tube 2 (Red/White)
}


// =============================================================================
// 7. OUTPUT SELECTOR
// =============================================================================
if (mode == "holder") {
    // Single Holder for selected style
    color(rose_gold_base) luxury_holder(style);
} else if (mode == "bracket") {
    // Wall Slide Bracket
    color([0.35, 0.35, 0.38]) wall_bracket();
} else if (mode == "plate") {
    // 1-Plate Combo: Compact 160mm x 116mm footprint at Z=0
    color(rose_gold_base) luxury_holder(style);
    color([0.35, 0.35, 0.38]) translate([0, 72.0, 0]) wall_bracket();
} else if (mode == "assembled") {
    // High-fidelity assembled preview on bathroom wall
    preview_assembled(style);
} else if (mode == "all_styles") {
    // Side-by-side visual comparison of all 3 luxury styles
    translate([-190.0, 0, 0]) preview_assembled("fluted");
    translate([   0.0, 0, 0]) preview_assembled("curved");
    translate([ 190.0, 0, 0]) preview_assembled("faceted");
}
