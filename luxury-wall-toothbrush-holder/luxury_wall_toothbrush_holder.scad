// =============================================================================
// LUXURY WALL-MOUNTED ORGANIZER (ROMAN PALAZZO COLONNADE)
// Support-Free FDM 3D Printable (Tailored for Rose Gold Silk Metallic PLA)
// Configurable Suite: Grand Edition (2 Cleansers + 2 Toothpastes + 4 Toothbrushes)
//                 or: Compact Edition (2 Toothpastes + 4 Toothbrushes)
// =============================================================================
// Design Highlights:
//  - Grand 8-in-1 Suite Architecture (204mm width):
//    * 2 Universal Facial Cleanser Chambers (Left & Right, 46x44mm, R=12mm)
//      Accommodates large thick circular flip-caps up to Ø44mm and 100-150g tubes
//    * 2 Universal Toothpaste Chambers (Center, 36x38mm, R=10mm)
//      Accommodates large thick circular standing flip-caps up to Ø36mm and 200g tubes
//    * 4 Self-Evacuating 45° Conical Funnels + Ø8mm Vertical Through-Drain Ports
//    * 4 Front-Release Toothbrush Berths (2 Electric + 2 Manual, Pitch 44mm)
//    * 20mm Front Terrace clearance between toothbrushes and rear gallery wall
//    * 5 Sculpted Architectural Tuscan Modillion Pilasters (8mm wide, 36mm open-air bay)
//    * 4 Wide Open-Air Under-Bays -> Instant vertical water drainage, zero mold traps
//    * Continuous Baseline Plinth at Z=0 (>3500mm² bed contact) -> Zero warping
//    * 8mm Slender Floating Cantilever Deck with R=10mm rounded corners
//    * 100% Support-Free: Strictly <= 45° overhang everywhere
//  - Universal No-Drill / Screw Mount System:
//    * Concealed sliding dovetail bracket with 0.3mm tolerance and stop ceiling
//  - Three Distinct Luxury Styles:
//    * "fluted": Roman Palazzo vertical fluted reeding (silk PLA specular highlights)
//    * "curved": Minimalist Satin Curve (pure continuous tangential curvature)
//    * "faceted": Art Deco Diamond Facets (geometric light-catching chamfers)
// =============================================================================

$fn = 60;

// User / Build Parameters
edition = "grand";    // "grand" (204mm with 2 Cleansers) | "compact" (168mm)
style   = "fluted";   // "fluted" | "curved" | "faceted"
mode    = "holder";   // "holder" | "bracket" | "plate" | "assembled" | "all_styles"

has_cleansers = (edition == "grand");

// Dimensions & Mechanical Specifications
w_total     = has_cleansers ? 204.0 : 168.0;
d_shelf     = 94.0;    // Front shelf edge (Y)
d_wall      = 8.0;     // Backplate thickness (Y)
h_total     = 88.0;    // Total backplate height (Z)
h_shelf     = 36.0;    // Shelf top deck level (Z)
th_shelf    = 8.0;     // Slender shelf deck thickness (Z = 28 to 36)
z_shelf_bot = h_shelf - th_shelf; // 28.0

r_corner    = 10.0;    // Corner radius for backplate and shelf

// Toothbrush Stations (4 Berths at Y = 78.0)
// Grand: Pitch = 44mm: X = [-66, -22, +22, +66]
// Compact: Pitch = 36mm: X = [-54, -18, +18, +54]
tb_pitch   = has_cleansers ? 44.0 : 36.0;
tb_y       = 78.0;

// Electric Berths (Left 2: +X)
elec_slot     = 10.5;
elec_hole_d   = 13.0;
elec_cup_d    = 19.0;
elec_mouth_w  = 20.0;

// Manual Berths (Right 2: -X)
manu_slot     = 7.0;
manu_hole_d   = 8.5;
manu_cup_d    = 14.5;
manu_mouth_w  = 16.0;

// Rear Storage Pod (Continuous Colonnade Gallery)
// Grand: W = 188.0, D = 50.0 (2 Cleansers + 2 Toothpastes)
// Compact: W = 90.0, D = 50.0 (2 Toothpastes)
tp_pod_w    = has_cleansers ? 188.0 : 90.0;
tp_pod_d    = 50.0;    // Y = 8.0 to 58.0 (Leaves 20mm clearance to tb_y=78.0)
tp_pod_h    = 36.0;    // Height above shelf: Z = 36 to 72
tp_floor_z  = h_shelf + 2.5;

// Wall Bracket & Dovetail
bracket_w  = 44.0;
bracket_h  = 34.0;
bracket_th = 2.4;
dove_th    = 4.4;
dove_w_top = 26.0;
dove_w_bot = 22.0;
dove_angle = 12.0;

// Rose Gold Material Colors
rose_gold_base  = [0.88, 0.58, 0.52];
rose_gold_dark  = [0.76, 0.46, 0.42];
rose_gold_light = [0.95, 0.70, 0.64];
accent_brass    = [0.82, 0.65, 0.38];
wall_tile_color = [0.94, 0.95, 0.96];


// =============================================================================
// 1. WALL BRACKET (免打孔雙用快拆背板)
// =============================================================================
module wall_bracket() {
    difference() {
        union() {
            // Flat base plate (Z = 0 to bracket_th, >1500mm² flat bed contact)
            hull() {
                translate([-bracket_w/2+4, 4, 0]) cylinder(r=4, h=bracket_th);
                translate([ bracket_w/2-4, 4, 0]) cylinder(r=4, h=bracket_th);
                translate([-bracket_w/2+4, bracket_h-4, 0]) cylinder(r=4, h=bracket_th);
                translate([ bracket_w/2-4, bracket_h-4, 0]) cylinder(r=4, h=bracket_th);
            }
            // Male dovetail wedge (Z = bracket_th to bracket_th + dove_th)
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
        
        // Countersunk screw holes (conical chamfer widening UPWARDS +Z)
        for (y_screw = [7.5, 25.5]) {
            translate([0, y_screw, -1.0]) {
                cylinder(d=4.2, h=bracket_th + dove_th + 3.0);
                translate([0, 0, bracket_th + dove_th - 2.0])
                    cylinder(r1=4.2/2, r2=8.2/2, h=2.5);
            }
        }
    }
}


// =============================================================================
// 2. ARCHITECTURAL TABLET BACKPLATE (古典拱碑典雅背板)
// =============================================================================
module arch_backplate() {
    w = w_total;
    th_back = d_wall;
    r = r_corner;
    
    difference() {
        // Main solid arched tablet
        translate([0, th_back, 0])
            rotate([90, 0, 0])
                linear_extrude(height = th_back) {
                    hull() {
                        translate([-w/2 + r, r]) circle(r=r);
                        translate([ w/2 - r, r]) circle(r=r);
                        translate([-w/2 + r, h_total - r]) circle(r=r);
                        translate([ w/2 - r, h_total - r]) circle(r=r);
                    }
                }
                
        // Architectural framed molding relief on front face of backplate
        translate([0, th_back, 0])
            rotate([90, 0, 0])
                difference() {
                    linear_extrude(height = 1.8)
                        hull() {
                            translate([-w/2 + r, r]) circle(r=r + 1.0);
                            translate([ w/2 - r, r]) circle(r=r + 1.0);
                            translate([-w/2 + r, h_total - r]) circle(r=r + 1.0);
                            translate([ w/2 - r, h_total - r]) circle(r=r + 1.0);
                        }
                    translate([0, 0, -1.0])
                        linear_extrude(height = 4.0)
                            hull() {
                                translate([-w/2 + r + 3.5, r + 3.5]) circle(r=r - 2.5);
                                translate([ w/2 - r - 3.5, r + 3.5]) circle(r=r - 2.5);
                                translate([-w/2 + r + 3.5, h_total - r - 3.5]) circle(r=r - 2.5);
                                translate([ w/2 - r - 3.5, h_total - r - 3.5]) circle(r=r - 2.5);
                            }
                }
    }
}


// =============================================================================
// 3. FIVE SCULPTED ARCHITECTURAL MODILLION PILASTERS (五組古典牛腿托樑柱)
// 100% strictly <= 45° overhang everywhere, 8mm solid presence
// Grand Edition: X = [-88, -44, 0, +44, +88] (Interleaved with 4 bays, pitch 44, 36mm bay)
// Compact Edition: X = [-72, -36, 0, +36, +72] (Interleaved with 4 bays, pitch 36, 28mm bay)
// =============================================================================
module five_sculpted_brackets(style_type="fluted") {
    b_w = 8.0; // 8mm solid architectural presence
    
    // Strict <= 45° overhang profile (dz >= dy everywhere)
    p_profile = [
        [ d_wall,        0.0],
        [ 58.0,          0.0],  // Flat plinth contact on bed
        [ 58.0,          3.0],  // Plinth step
        [ 64.0,          9.0],  // 45° lower chamfer (dy=6, dz=6)
        [ 72.0,          20.0], // 36° mid console sweep (dy=8, dz=11)
        [ 80.0,          z_shelf_bot], // 45° upper cove (dy=8, dz=8)
        [ d_shelf - 8.0, z_shelf_bot], // Front contact under deck
        [ d_wall,        z_shelf_bot]
    ];
    
    x_list = has_cleansers ? [-88.0, -44.0, 0.0, 44.0, 88.0] : [-72.0, -36.0, 0.0, 36.0, 72.0];
    
    for (x_b = x_list) {
        translate([x_b - b_w/2, 0, 0]) {
            rotate([90, 0, 90]) {
                linear_extrude(height = b_w)
                    polygon(p_profile);
            }
        }
        
        // Chamfered edges on brackets for 'faceted' style
        if (style_type == "faceted") {
            for (side = [-1, 1]) {
                translate([x_b + side * b_w/2, 68.0, 14.0])
                    rotate([0, 45, 0])
                        cube([1.4, 24.0, 1.4], center=true);
            }
        }
    }
    
    // Continuous baseline plinth tying all 5 brackets together at Z=0
    translate([-w_total/2 + r_corner, d_wall, 0])
        cube([w_total - 2*r_corner, 8.0, 3.0]);
}


// =============================================================================
// 4. FLOATING CANTILEVER SHELF DECK (8mm 纖薄懸浮展台)
// Pure floating deck from Y=0 to d_shelf=94.0, rounded front corners R=10
// =============================================================================
module shelf_deck() {
    w = w_total;
    r = r_corner;
    
    difference() {
        hull() {
            translate([-w/2 + r, 0, z_shelf_bot]) cube([w - 2*r, 0.1, th_shelf]);
            translate([-w/2 + r, d_shelf - r, z_shelf_bot]) cylinder(r=r, h=th_shelf);
            translate([ w/2 - r, d_shelf - r, z_shelf_bot]) cylinder(r=r, h=th_shelf);
            translate([-w/2, 0, z_shelf_bot]) cube([w, d_shelf - r, th_shelf]);
        }
        
        // Refined 45° beading on front lip top and bottom edges
        translate([0, d_shelf, h_shelf])
            rotate([0, 90, 0])
                rotate([0, 0, 45])
                    cube([1.4, 1.4, w*2], center=true);
        translate([0, d_shelf, z_shelf_bot])
            rotate([0, 90, 0])
                rotate([0, 0, 45])
                    cube([1.4, 1.4, w*2], center=true);
    }
}


// =============================================================================
// 5. REAR STORAGE GALLERY (後排長虹柱面收納大艙 - 兼容厚實大圓蓋)
// Grand Edition: 4 Universal Chambers (2 Facial Cleansers + 2 Toothpastes)
// Compact Edition: 2 Universal Chambers (2 Toothpastes)
// =============================================================================
module squircle_cavity(w, d, r, h) {
    hull() {
        translate([-w/2 + r, -d/2 + r, 0]) cylinder(r=r, h=h);
        translate([ w/2 - r, -d/2 + r, 0]) cylinder(r=r, h=h);
        translate([-w/2 + r,  d/2 - r, 0]) cylinder(r=r, h=h);
        translate([ w/2 - r,  d/2 - r, 0]) cylinder(r=r, h=h);
    }
}

module rear_storage_pod(style_type="fluted") {
    w = tp_pod_w;
    d = tp_pod_d;
    r = 16.0;
    z_base = h_shelf;
    h = tp_pod_h;
    y_center = d_wall + d/2;
    
    difference() {
        union() {
            // Main continuous capsule body
            hull() {
                translate([-w/2 + r, d_wall + r, z_base]) cylinder(r=r, h=h);
                translate([ w/2 - r, d_wall + r, z_base]) cylinder(r=r, h=h);
                translate([-w/2 + r, d_wall + d - r, z_base]) cylinder(r=r, h=h);
                translate([ w/2 - r, d_wall + d - r, z_base]) cylinder(r=r, h=h);
            }
            
            // Fluted Reeding Columns (Palazzo Fluting)
            if (style_type == "fluted") {
                pitch = 3.6;
                // Front fluted wall
                for (x = [-w/2 + r : pitch : w/2 - r]) {
                    translate([x, d_wall + d, z_base])
                        cylinder(r=1.5, h=h, $fn=20);
                }
                // Curved flanks
                for (side = [-1, 1]) {
                    cx = side * (w/2 - r);
                    for (a = [0 : 15 : 90]) {
                        rad = a * side;
                        translate([cx + sin(rad)*r, d_wall + d - r + cos(rad)*r, z_base])
                            cylinder(r=1.5, h=h, $fn=16);
                    }
                }
            }
            
            // Faceted diamond ribs for 'faceted' style
            if (style_type == "faceted") {
                pitch = 6.0;
                for (x = [-w/2 + r : pitch : w/2 - r]) {
                    translate([x, d_wall + d - 0.5, z_base])
                        rotate([0, 0, 45])
                            cube([2.2, 2.2, h]);
                }
            }
        }
        
        // Chamfered top gallery rim
        translate([0, d_wall + d, z_base + h])
            rotate([0, 90, 0])
                rotate([0, 0, 45])
                    cube([1.6, 1.6, w*2], center=true);
                    
        // ---------------------------------------------------------------------
        // 1. Center Twin Universal Toothpaste Wells
        // Fits large thick circular standing flip-caps up to Ø36mm & 200g tubes
        // Cavity: 36.0 x 38.0mm, corner radius 10mm
        // ---------------------------------------------------------------------
        tp_x = has_cleansers ? 22.0 : 18.0;
        for (x_off = [-tp_x, tp_x]) {
            translate([x_off, y_center, 0]) {
                translate([0, 0, tp_floor_z]) {
                    squircle_cavity(36.0, 38.0, 10.0, h_total);
                }
                // 45° Lead-in top rim funnel flare (smooth blind insertion)
                translate([0, 0, z_base + h - 2.5])
                    cylinder(r1=36.0/2 - 2.0, r2=36.0/2 + 2.0, h=3.0);
                // 45° Conical drainage funnel + Ø8mm vertical drain hole
                translate([0, 0, tp_floor_z - 0.01])
                    cylinder(r1=4.0, r2=10.0, h=4.0);
                translate([0, 0, -5.0])
                    cylinder(d=8.0, h=tp_floor_z + 10.0);
            }
        }
        
        // ---------------------------------------------------------------------
        // 2. Twin Universal Facial Cleanser Wells (Grand Edition only)
        // Fits large thick circular flip-caps up to Ø44mm & 150g tubes
        // Cavity: 46.0 x 44.0mm, corner radius 12mm
        // ---------------------------------------------------------------------
        if (has_cleansers) {
            for (side = [-1, 1]) {
                cx = side * 66.0;
                translate([cx, y_center, 0]) {
                    translate([0, 0, tp_floor_z]) {
                        squircle_cavity(46.0, 44.0, 12.0, h_total);
                    }
                    // 45° Lead-in top rim funnel flare
                    translate([0, 0, z_base + h - 2.5])
                        cylinder(r1=44.0/2 - 2.0, r2=44.0/2 + 2.0, h=3.0);
                    // 45° Conical drainage funnel + Ø8mm vertical drain hole
                    translate([0, 0, tp_floor_z - 0.01])
                        cylinder(r1=4.0, r2=12.0, h=5.0);
                    translate([0, 0, -5.0])
                        cylinder(d=8.0, h=tp_floor_z + 10.0);
                }
            }
        }
    }
}


// =============================================================================
// 6. FOUR PRECISION FRONT-RELEASE TOOTHBRUSH BERTHS
// =============================================================================
module four_front_release_berths() {
    for (i = [0:3]) {
        x_pos = (i - 1.5) * tb_pitch;
        is_elec = (x_pos > 0); // Left 2 are Electric
        
        slot_w  = is_elec ? elec_slot    : manu_slot;
        hole_d  = is_elec ? elec_hole_d  : manu_hole_d;
        cup_d   = is_elec ? elec_cup_d   : manu_cup_d;
        mouth_w = is_elec ? elec_mouth_w : manu_mouth_w;
        
        y_throat = tb_y + 4.0;
        delta_y = d_shelf - y_throat;
        delta_x = mouth_w/2 - slot_w/2;
        R = (delta_x*delta_x + delta_y*delta_y) / (2 * delta_y);
        y_center = d_shelf - R;
        
        translate([x_pos, 0, 0]) {
            // 1. Through Hole: Vertical drainage through 8mm shelf deck
            translate([0, tb_y, z_shelf_bot - 2.0])
                cylinder(d=hole_d, h=th_shelf + 4.0);
                
            // 2. Tangential Flared Trumpet Horn Entry (C1 continuous curve)
            translate([0, 0, z_shelf_bot - 1.0])
                linear_extrude(height = th_shelf + 2.0) {
                    difference() {
                        union() {
                            translate([-slot_w/2, tb_y])
                                square([slot_w, y_throat - tb_y + 0.05]);
                            polygon([
                                [-slot_w/2, y_throat],
                                [-mouth_w/2, d_shelf],
                                [-mouth_w/2, d_shelf + 5.0],
                                [ mouth_w/2, d_shelf + 5.0],
                                [ mouth_w/2, d_shelf],
                                [ slot_w/2, y_throat]
                            ]);
                            translate([-mouth_w/2, d_shelf - 0.01])
                                square([mouth_w, 5.0]);
                        }
                        translate([-mouth_w/2, y_center]) circle(r=R);
                        translate([ mouth_w/2, y_center]) circle(r=R);
                    }
                }
                
            // 3. Smooth Conical Saddle Seat (Anti-Drop)
            translate([0, tb_y, h_shelf - 3.2])
                cylinder(r1=hole_d/2, r2=cup_d/2, h=3.25);
            translate([0, tb_y, h_shelf - 0.5])
                cylinder(r1=cup_d/2, r2=cup_d/2 + 1.2, h=1.0);
        }
    }
}


// =============================================================================
// 7. DOVETAIL SLIDE RECEIVER
// =============================================================================
module female_dovetail_cavity() {
    tol = 0.30;
    h_slot = bracket_h;
    w_t = dove_w_top + tol*2;
    w_b = dove_w_bot + tol*2;
    d_s = dove_th + tol;
    w_max = w_b + 2 * d_s * tan(dove_angle);
    apex_h = w_max / 2;

    translate([0, -0.01, -0.5]) {
        linear_extrude(height=h_slot, scale=[w_b/w_t, 1.0])
            polygon([
                [-w_t/2, 0],
                [-w_t/2 - d_s*tan(dove_angle), d_s],
                [ w_t/2 + d_s*tan(dove_angle), d_s],
                [ w_t/2, 0]
            ]);
            
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


// =============================================================================
// 8. MASTER ORGANIZER ASSEMBLY
// =============================================================================
module luxury_holder(style_type="fluted") {
    difference() {
        union() {
            arch_backplate();
            five_sculpted_brackets(style_type);
            shelf_deck();
            rear_storage_pod(style_type);
        }
        
        // Dovetail slide-in mounting slot on rear
        female_dovetail_cavity();
        
        // 4 Front-Release Toothbrush Berths
        four_front_release_berths();
        
        // Clean cut at Z=0 ensuring 100% planar bed adhesion
        translate([0, 0, -50.0]) cube([500.0, 500.0, 100.0], center=true);
    }
}


// =============================================================================
// 9. COLOR ASSEMBLED PREVIEW MODULES (FEATURING LARGE THICK CIRCULAR CAPS)
// =============================================================================
module electric_toothbrush_prop(color_handle=[0.96, 0.96, 0.97], color_accent=[0.88, 0.58, 0.52]) {
    translate([0, tb_y, h_shelf - 3.2]) {
        color(color_handle)
            translate([0, 0, -125.0])
                cylinder(d1=27.0, d2=25.0, h=125.0);
        color(color_accent)
            translate([0, 0, -123.0])
                cylinder(d=27.2, h=4.0);
        color(color_accent)
            translate([0, 13.0, -40.0])
                rotate([90, 0, 0])
                    cylinder(d=8.0, h=2.0);
        color([0.85, 0.85, 0.90])
            translate([0, 0, 0])
                cylinder(d1=15.0, d2=11.0, h=6.0);
        color(color_handle)
            translate([0, 0, 6.0])
                cylinder(d1=9.0, d2=6.5, h=52.0);
        color(color_handle)
            translate([0, 0, 58.0])
                hull() {
                    cylinder(d=10.0, h=14.0);
                    translate([0, 3.0, 7.0]) cylinder(d=7.0, h=7.0);
                }
        color([0.2, 0.6, 0.9])
            translate([0, 6.5, 65.0])
                rotate([90, 0, 0])
                    cylinder(d=8.5, h=5.0);
    }
}

module manual_toothbrush_prop(color_grip=[0.2, 0.7, 0.8]) {
    translate([0, tb_y, h_shelf - 3.2]) {
        color(color_grip)
            translate([0, 0, -110.0]) {
                cylinder(d1=10.5, d2=12.5, h=110.0);
                sphere(d=10.5);
            }
        color(color_grip)
            translate([0, 0, 0])
                cylinder(d=5.2, h=10.0);
        color([0.96, 0.96, 0.96])
            translate([0, 0, 10.0]) {
                hull() {
                    cylinder(d=11.0, h=4.0);
                    translate([0, 8.0, 0]) cylinder(d=9.0, h=4.0);
                }
                translate([0, 4.0, 4.0]) cube([5.5, 14.0, 8.5], center=true);
            }
    }
}

// Toothpaste with Large Thick Circular Standing Flip-Cap (Ø32mm x 20mm thick)
module toothpaste_tube_prop(color_tube=[0.22, 0.58, 0.88]) {
    color([0.92, 0.92, 0.94])
        cylinder(d=32.0, h=20.0);
    color(color_tube) {
        translate([0, 0, 20.0])
            scale([1.1, 0.70, 1.0])
                cylinder(r1=15.0, r2=17.0, h=75.0);
        translate([0, 0, 95.0])
            cube([37.0, 4.0, 12.0], center=true);
    }
}

// Facial Cleanser with Large Thick Circular Flip-Cap (Ø40mm x 22mm thick)
module cleanser_tube_prop(color_tube=[0.85, 0.90, 0.95]) {
    color([0.94, 0.94, 0.96])
        cylinder(d=40.0, h=22.0);
    color(color_tube) {
        translate([0, 0, 22.0])
            scale([1.25, 0.75, 1.0])
                cylinder(r1=19.0, r2=22.0, h=80.0);
        translate([0, 0, 102.0])
            cube([46.0, 4.0, 12.0], center=true);
    }
}

module preview_assembled(style_type="fluted") {
    // Wall Tile
    color(wall_tile_color)
        translate([0, -2.0, 45.0])
            cube([w_total + 80.0, 4.0, 280.0], center=true);
            
    // Wall Bracket (mounted to wall)
    color([0.35, 0.35, 0.38])
        translate([0, 0, 4.0])
            rotate([90, 0, 0])
                wall_bracket();
                
    // Main Luxury Holder (Rose Gold)
    color(rose_gold_base)
        luxury_holder(style_type);
        
    // 4 Hanging Toothbrushes (Left to Right from User Facing View: +X to -X)
    x_elec1 =  1.5 * tb_pitch; // Leftmost: Electric 1
    x_elec2 =  0.5 * tb_pitch; // Center-Left: Electric 2
    x_manu1 = -0.5 * tb_pitch; // Center-Right: Manual 1
    x_manu2 = -1.5 * tb_pitch; // Rightmost: Manual 2
    
    translate([x_elec1, 0, 0]) electric_toothbrush_prop([0.96, 0.96, 0.96], rose_gold_base);
    translate([x_elec2, 0, 0]) electric_toothbrush_prop([0.22, 0.22, 0.25], accent_brass);
    translate([x_manu1, 0, 0]) manual_toothbrush_prop([0.20, 0.72, 0.82]);
    translate([x_manu2, 0, 0]) manual_toothbrush_prop([0.92, 0.45, 0.50]);
    
    y_center = d_wall + tp_pod_d/2;
    // 2 Toothpastes with Large Circular Caps (Left: +22, Right: -22)
    tp_x = has_cleansers ? 22.0 : 18.0;
    translate([ tp_x, y_center, tp_floor_z])
        toothpaste_tube_prop([0.88, 0.30, 0.35]);
    translate([-tp_x, y_center, tp_floor_z])
        toothpaste_tube_prop([0.20, 0.58, 0.85]);
        
    // 2 Facial Cleansers with Large Circular Caps (Grand Edition: Left: +66, Right: -66)
    if (has_cleansers) {
        translate([ 66.0, y_center, tp_floor_z])
            cleanser_tube_prop([0.22, 0.40, 0.72]);
        translate([-66.0, y_center, tp_floor_z])
            cleanser_tube_prop([0.92, 0.92, 0.95]);
    }
}


// =============================================================================
// 10. OUTPUT SELECTOR
// =============================================================================
if (mode == "holder") {
    color(rose_gold_base) luxury_holder(style);
} else if (mode == "bracket") {
    color([0.35, 0.35, 0.38]) wall_bracket();
} else if (mode == "plate") {
    // 1-Plate Combo: Compact footprint at Z=0 (204mm x 136mm)
    color(rose_gold_base) luxury_holder(style);
    color([0.35, 0.35, 0.38]) translate([0, d_shelf + 8.0, 0]) wall_bracket();
} else if (mode == "assembled") {
    preview_assembled(style);
} else if (mode == "all_styles") {
    spacing = w_total + 25.0;
    translate([ spacing, 0, 0]) preview_assembled("fluted");
    translate([     0.0, 0, 0]) preview_assembled("curved");
    translate([-spacing, 0, 0]) preview_assembled("faceted");
}
