/*
================================================================================
Luxury Wall-Mounted Organizer: Front-Release Anti-Drop Toothbrush Berths + Twin Toothpastes
(奢華輕奢壁掛式全能置物架 - 前推前取防掉落懸掛牙刷座 + 後排雙超大牙膏艙)

Designed specifically for Rose Gold / Silk Metallic FDM 3D Printing:
- 100% Support-Free Printing (Pointed-arch ceilings, 45° self-supporting corbels, 0 support alert)
- PROPER PRECISION APERTURES & ANTI-DROP RETENTION CUPS (精密開孔與防掉落沉孔結構):
  * Monolithic Continuous Shelf (一體式輕奢平整展台, W=160mm, H=46mm)
  * Dual-Format Dedicated Berths (左側雙電動 + 右側雙手動，共4個獨立懸掛位):
    - Berths 1 & 2 (Left, X = -54, -18): Electric Toothbrushes (Oral-B iO/Pro, Sonicare, Xiaomi)
      * Slot Throat: 10.5mm with 16mm flared front lead-in
      * Through Hole: Ø12.8mm (prevents handle collar drop-through)
      * Retention Cup: Ø18.5mm, 4.5mm deep (seats handle collar, locked from forward falling)
    - Berths 3 & 4 (Right, X = +18, +54): Manual Toothbrushes (Colgate, Oral-B, Darlie, Curaprox)
      * Slot Throat: 7.0mm with 12mm flared front lead-in
      * Through Hole: Ø8.8mm
      * Retention Cup: Ø13.5mm, 4.5mm deep (seats brush head transition)
      * 100% Anti-Drop: Throat (7.0mm) is MUCH narrower than brush head (11.5-13mm) and
        handle (11-14mm). Toothbrush CANNOT fall forward, slip out, or slide down!
  * Direct Front Insertion & Retrieval (直接從前方推入與取出):
    Zero vertical clearance required — effortlessly slide in/out under low mirror cabinets!
  * 360° Open Air Drip: Handles hang freely in open air; zero standing water, zero mold!
- Rear Tier (H=66mm, Depth 56mm): 2 Generous Compartments (50mm x 26mm) for 200g
  family toothpastes, facial cleansers, or extra electric toothbrushes/shavers.
- Modular Slide-in Dovetail Wall Bracket (3M VHB tape flat bed + countersunk screw holes)
- 3 Distinct Luxury Aesthetics in Rose Gold:
    1. "fluted"  - 輕奢羅馬柱豎條紋 + 珠寶級密鋪鑽石網格展台 (Fluted Columns + Diamond Mesh Deck)
    2. "curved"  - 現代意式極簡流線 (Cascading Organic Streamlines with Accent Grooves)
    3. "faceted" - 幾何菱格切面 + 密鋪鑽石網格展台 (Architectural Faceted + Diamond Mesh Deck)

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
// "assembled"  - Full color assembled wall preview with toothbrushes & toothpastes
// "all_styles" - Side-by-side visual comparison of all 3 styles in Rose Gold
mode = "holder";

// -----------------------------------------------------------------------------
// Dimensions & Mechanical Specifications
// -----------------------------------------------------------------------------
w_holder     = 160.0;   // Overall width (X)
d_back       = 36.0;    // Depth of rear toothpaste tier (Y)
d_front      = 68.0;    // Depth of front continuous shelf (Y)
h_back       = 66.0;    // Rear tier height (Z)
h_shelf      = 46.0;    // Front shelf top surface level (Z)
corner_r     = 10.0;    // Outer corner radius

// Toothbrush Stations (X = -54, -18, +18, +54, Y = 52.0)
tb_pitch     = 36.0;    // Center-to-center pitch
tb_hole_y    = 52.0;    // Y coordinate of hole center

// Electric Toothbrush Stations (Stations 1 & 2: X = -54, -18)
tb_elec_slot     = 10.5;    // Throat width for electric brush neck
tb_elec_hole     = 12.8;    // Through hole diameter
tb_elec_cup      = 18.5;    // Recessed retention cup diameter
tb_elec_mouth    = 23.0;    // Flared front entry width (generous blind docking target)
tb_elec_y_throat = 60.5;    // Y coordinate where trumpet flare joins throat slot

// Manual Toothbrush Stations (Stations 3 & 4: X = +18, +54)
tb_manu_slot     = 7.0;     // Throat width for manual brush neck (neck 5.5mm slides in easily)
tb_manu_hole     = 8.8;     // Through hole diameter
tb_manu_cup      = 13.5;    // Recessed retention cup diameter (holds head base, throat 7mm prevents fall!)
tb_manu_mouth    = 20.0;    // Flared front entry width (generous blind docking target)
tb_manu_y_throat = 57.5;    // Y coordinate where trumpet flare joins throat slot

cup_depth    = 4.5;     // Depth of recessed retention cup

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
// 2. INTERNAL CAVITIES & PRECISION APERTURES
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

// Twin Oversized Toothpaste Wells with 360° Aeration Flutes & Triple High-Flow Ports
module twin_toothpaste_cavities() {
    for (x_pos = [-tp_x, tp_x]) {
        translate([x_pos, tp_y, 0]) {
            // 1. Main Well Cavity (48mm x 26mm, interior depth 56mm from Z = tp_floor_z to h_back)
            translate([0, 0, tp_floor_z]) {
                hull() {
                    translate([-tp_w/2 + 6.0, -tp_d/2 + 6.0, 0]) cylinder(r=6.0, h=h_back);
                    translate([ tp_w/2 - 6.0, -tp_d/2 + 6.0, 0]) cylinder(r=6.0, h=h_back);
                    translate([-tp_w/2 + 6.0,  tp_d/2 - 6.0, 0]) cylinder(r=6.0, h=h_back);
                    translate([ tp_w/2 - 6.0,  tp_d/2 - 6.0, 0]) cylinder(r=6.0, h=h_back);
                }
            }
            
            // 2. Interior Wall Vertical Aeration Flutes (360° Anti-Sticking Chimney Channels)
            // 100% invisible from outside; allows continuous convection around tube body
            for (x_f = [-18.0 : 6.0 : 18.0]) {
                // Front interior wall flutes
                translate([x_f, tp_d/2, tp_floor_z])
                    cylinder(r=1.2, h=h_back);
                // Back interior wall flutes
                translate([x_f, -tp_d/2, tp_floor_z])
                    cylinder(r=1.2, h=h_back);
            }
            for (y_f = [-6.0, 6.0]) {
                // Left interior wall flutes
                translate([-tp_w/2, y_f, tp_floor_z])
                    cylinder(r=1.2, h=h_back);
                // Right interior wall flutes
                translate([ tp_w/2, y_f, tp_floor_z])
                    cylinder(r=1.2, h=h_back);
            }
            
            // 3. Triple High-Flow Vertical Drainage & Aeration Ports (>155mm² open air draft)
            // Center port: Ø10mm through-hole + 45° conical intake bowl (Ø18mm down to Ø10mm)
            translate([0, 0, -1.0])
                cylinder(d=10.0, h=tp_floor_z + 2.0);
            translate([0, 0, tp_floor_z - 0.01])
                cylinder(r1=10.0/2, r2=18.0/2, h=4.0);
                
            // Left port: Ø7mm through-hole + 45° conical intake bowl (Ø13mm down to Ø7mm)
            translate([-14.0, 0, -1.0])
                cylinder(d=7.0, h=tp_floor_z + 2.0);
            translate([-14.0, 0, tp_floor_z - 0.01])
                cylinder(r1=7.0/2, r2=13.0/2, h=3.0);
                
            // Right port: Ø7mm through-hole + 45° conical intake bowl (Ø13mm down to Ø7mm)
            translate([ 14.0, 0, -1.0])
                cylinder(d=7.0, h=tp_floor_z + 2.0);
            translate([ 14.0, 0, tp_floor_z - 0.01])
                cylinder(r1=7.0/2, r2=13.0/2, h=3.0);
        }
    }
}

// 4 Precision Toothbrush Apertures & Anti-Drop Retention Berths with Tangential Trumpet Horns
module four_precision_berths() {
    for (i = [0:3]) {
        x_pos = (i - 1.5) * tb_pitch; // -54, -18, +18, +54
        is_electric = (i < 2);        // Left 2 = Electric, Right 2 = Manual
        
        slot_w   = is_electric ? tb_elec_slot     : tb_manu_slot;
        hole_d   = is_electric ? tb_elec_hole     : tb_manu_hole;
        cup_d    = is_electric ? tb_elec_cup      : tb_manu_cup;
        mouth_w  = is_electric ? tb_elec_mouth    : tb_manu_mouth;
        y_throat = is_electric ? tb_elec_y_throat : tb_manu_y_throat;
        
        delta_y = d_front - y_throat;
        delta_x = mouth_w/2 - slot_w/2;
        R = (delta_x*delta_x + delta_y*delta_y) / (2 * delta_y);
        y_center = d_front - R;
        
        translate([x_pos, 0, 0]) {
            // 1. Through Hole: Vertical drainage all the way through corbel to open air
            translate([0, tb_hole_y, -5.0])
                cylinder(d=hole_d, h=h_shelf + 15.0);
                
            // 2. Tangential Trumpet Horn Opening (100% C1 continuous tangency, ZERO sharp right angles)
            translate([0, 0, -5.0])
                linear_extrude(height = h_shelf + 15.0) {
                    difference() {
                        union() {
                            // Parallel throat slot
                            translate([-slot_w/2, tb_hole_y])
                                square([slot_w, y_throat - tb_hole_y + 0.05]);
                            // Raw wedge
                            polygon([
                                [-slot_w/2, y_throat],
                                [-mouth_w/2, d_front],
                                [-mouth_w/2, d_front + 5.0],
                                [ mouth_w/2, d_front + 5.0],
                                [ mouth_w/2, d_front],
                                [ slot_w/2, y_throat]
                            ]);
                            // Extension past d_front for clean cutting
                            translate([-mouth_w/2, d_front - 0.01])
                                square([mouth_w, 5.0]);
                        }
                        // Subtract tangential circular arcs to create organic curved trumpet walls
                        translate([-mouth_w/2, y_center]) circle(r=R);
                        translate([ mouth_w/2, y_center]) circle(r=R);
                    }
                }
                
            // 3. Recessed Concave Retention Cup with Diamond Bezel Chamfer
            translate([0, tb_hole_y, h_shelf - cup_depth])
                cylinder(r1=hole_d/2, r2=cup_d/2, h=cup_depth + 0.1);
            // 12-sided faceted jewel bezel chamfer (clean cut through mesh to open air)
            translate([0, tb_hole_y, h_shelf - 1.0])
                cylinder(r1=cup_d/2, r2=cup_d/2 + 2.0, h=4.0, $fn=12);
        }
    }
}


// =============================================================================
// 3. SOLID GEOMETRY BUILDER (MONOLITHIC CONTINUOUS ARCHITECTURAL CORBEL)
// =============================================================================

// Base solid body with rear tier and continuous front shelf with 45° corbel underneath
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
        
        // 2. Monolithic Continuous Front Shelf with 45° Architectural Corbel Underneath
        // 100% self-supporting overhang (slopes up from Z=8mm at back to Z=40mm at front)
        hull() {
            // Corbel base root along rear tier (Y = d_back, Z = 8 to h_shelf)
            translate([-w/2+r, d_back, 8.0])
                cube([w - r*2, 0.1, h_shelf - 8.0]);
                
            // Front shelf edge (Y = d_front - r, Z = h_shelf - 6 to h_shelf)
            translate([-w/2+r, d_front-r, h_shelf - 6.0])
                cylinder(r=r, h=6.0);
            translate([ w/2-r, d_front-r, h_shelf - 6.0])
                cylinder(r=r, h=6.0);
        }
    }
}


// =============================================================================
// 4. THREE AESTHETIC STYLES (ROSE GOLD SILK OPTIMIZED)
// =============================================================================

// Bounding mask of the front shelf (for trimming diamond mesh cleanly to outer contour)
module shelf_top_mask(extra_h=2.0) {
    w = w_holder;
    r = corner_r;
    hull() {
        translate([-w/2+r, d_back, h_shelf - 0.2])
            cube([w - r*2, 0.1, extra_h + 0.4]);
        translate([-w/2+r, d_front-r, h_shelf - 0.2])
            cylinder(r=r, h=extra_h + 0.4);
        translate([ w/2-r, d_front-r, h_shelf - 0.2])
            cylinder(r=r, h=extra_h + 0.4);
    }
}

// 珠寶級立體密鋪鑽石金字塔網格 (SEAMLESS DIAMOND FACET MESH ACROSS ENTIRE TOOTHBRUSH SHELF)
// 整個牙刷放置表面密鋪 4 面體立體鑽石金字塔，折射璀璨各向異性金屬光澤，100% 免支撐
module diamond_mesh_top_shelf(cell_size=6.0, h_pyr=1.4) {
    R = cell_size / sqrt(2);
    nx = ceil((w_holder + 10) / cell_size) / 2 + 1;
    ny = ceil((d_front - d_back + 10) / cell_size) + 1;
    
    intersection() {
        shelf_top_mask(extra_h=h_pyr);
        
        translate([0, d_back, h_shelf - 0.05]) {
            for (ix = [-nx : nx]) {
                for (iy = [0 : ny]) {
                    translate([ix * cell_size, iy * cell_size, 0])
                        rotate([0, 0, 45])
                            cylinder(r1=R, r2=0, h=h_pyr + 0.05, $fn=4);
                }
            }
        }
    }
}

// STYLE 1: 輕奢羅馬柱豎條紋 + 珠寶級密鋪鑽石網格展台 (FLUTED REEDED REAR + DIAMOND MESH FRONT)
module holder_style_fluted() {
    w = w_holder;
    r = corner_r;
    pitch = 4.8;
    rib_r = 1.4;
    
    union() {
        base_holder_structure();
        
        // Vertical decorative flutes along rear tier sides and front face
        for (x = [-w/2+r : pitch : w/2-r]) {
            // Above shelf level on rear tier front face (Z = h_shelf to h_back)
            translate([x, d_back, h_shelf])
                cylinder(r=rib_r, h=h_back - h_shelf);
        }
        for (y = [r : pitch : d_back-r]) {
            translate([-w/2, y, 0]) cylinder(r=rib_r, h=h_back);
            translate([ w/2, y, 0]) cylinder(r=rib_r, h=h_back);
        }
        
        // 牙刷放置區域全面密鋪立體鑽石網格 (Seamless Diamond Faceted Mesh)
        diamond_mesh_top_shelf(cell_size=6.0, h_pyr=1.4);
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
        union() {
            base_holder_structure();
            // Diamond mesh across the front toothbrush shelf
            diamond_mesh_top_shelf(cell_size=6.0, h_pyr=1.4);
        }
        
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
        
        // 4 Precision Toothbrush Apertures & Anti-Drop Berths
        four_precision_berths();
        
        // Clean cut at Z=0 ensuring 100% planar bed adhesion
        translate([0, 0, -50.0]) cube([400.0, 400.0, 100.0], center=true);
    }
}


// =============================================================================
// 6. COLOR ASSEMBLED PREVIEW MODULES
// =============================================================================

// High-fidelity Electric Toothbrush Prop (Hanging in Berth 1 & 2 by Handle Collar)
module electric_toothbrush_prop(color_handle=[0.95, 0.95, 0.97], color_accent=[0.88, 0.58, 0.52]) {
    // Resting position inside retention cup (Z = h_shelf - cup_depth = 41.5, Y = tb_hole_y = 52.0)
    translate([0, tb_hole_y, h_shelf - cup_depth]) {
        // 1. Hanging Handle Body (Ø28mm, hanging down into open air)
        color(color_handle)
            translate([0, 0, -135.0])
                cylinder(d1=28.0, d2=26.0, h=135.0);
                
        // 2. Base Ring / Metallic Accent
        color(color_accent)
            translate([0, 0, -133.0])
                cylinder(d=28.2, h=4.0);
                
        // 3. Power Button & LED Ring
        color(color_accent)
            translate([0, 13.5, -45.0])
                rotate([90, 0, 0])
                    cylinder(d=9.0, h=2.0);
                    
        // 4. Mode Indicator LED dots
        color([0.2, 0.8, 1.0])
            for (z_led = [-75.0, -67.0, -59.0])
                translate([0, 13.5, z_led])
                    rotate([90, 0, 0])
                        cylinder(d=2.0, h=2.0);
                        
        // 5. Metal Shaft Top Collar (rests inside the Ø18.5mm retention cup)
        color([0.8, 0.8, 0.85])
            translate([0, 0, 0])
                cylinder(d1=16.0, d2=11.5, h=7.0);
                
        // 6. Brush Head Neck (extends upwards through cup)
        color(color_handle)
            translate([0, 0, 7.0])
                cylinder(d1=10.0, d2=7.0, h=55.0);
                
        // 7. Brush Head & Bristles
        color(color_handle)
            translate([0, 0, 62.0]) {
                hull() {
                    cylinder(d=11.0, h=16.0);
                    translate([0, 3.0, 8.0]) cylinder(d=8.0, h=8.0);
                }
            }
        // Bristles (Blue + White)
        color([0.3, 0.6, 0.9])
            translate([0, 7.5, 70.0])
                rotate([90, 0, 0])
                    cylinder(d=10.0, h=6.0);
    }
}

// Ergonomic Manual Toothbrush Prop (Hanging in Berth 3 & 4 by Brush Head Neck)
module manual_toothbrush_prop(color_grip=[0.2, 0.7, 0.8]) {
    // Resting position: Brush head transition inside the Ø13.5mm cup at Z = h_shelf - cup_depth
    translate([0, tb_hole_y, h_shelf - cup_depth]) {
        // 1. Handle hanging down (Ø12mm down to Ø14mm grip)
        color(color_grip)
            translate([0, 0, -115.0]) {
                cylinder(d1=11.0, d2=13.0, h=115.0);
                sphere(d=11.0);
            }
        // 2. Slender Neck inside hole (Ø5.5mm, fits through 7.0mm throat)
        color(color_grip)
            translate([0, 0, 0])
                cylinder(d=5.5, h=12.0);
        // 3. Widened Brush Head resting safely in cup (12mm wide, CANNOT pass 7.0mm throat!)
        color([0.95, 0.95, 0.95])
            translate([0, 0, 12.0]) {
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
    // Station 3: Turquoise Ergonomic Manual Toothbrush
    translate([ 18.0, 0, 0]) manual_toothbrush_prop([0.20, 0.72, 0.82]);
    // Station 4: Coral Pink Ergonomic Manual Toothbrush
    translate([ 54.0, 0, 0]) manual_toothbrush_prop([0.92, 0.45, 0.50]);
    
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
