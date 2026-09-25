// =============================================================================
// LUXURY WALL-MOUNTED TOOTHBRUSH, TOOTHPASTE & CLEANSER ORGANIZER
// 奢華壁掛前壁一體式洗面乳牙刷牙膏置物架 (裝飾藝術水晶切面 / 羅馬殿堂旗艦版)
// Precision reverse-engineered from 621-01.stp with Front-Wall Integrated Colonnade
// =============================================================================

$fn = 40;

// Configuration Parameters
edition = "grand";    // "grand" (2 Facial Cleansers + 2 Toothpastes + 6 Toothbrushes)
style   = "faceted";  // "faceted" (Art Deco Diamond - User Selection), "fluted" (Palazzo), "curved" (Satin)
mode    = "holder";   // "holder", "plate", "bracket", "standalone_toothbrush", "assembled", "all_styles"

// Master Dimensions
w_total     = 204.0;
d_wall      = 8.0;
h_total     = 88.0;

w_pod       = 188.0;
d_pod       = 50.0;
h_pod       = 44.0; 
y_front     = d_wall + d_pod; // 58.0mm: Front vertical wall of storage gallery

// Toothbrush Hanging Parameters (Pure Forward-and-Upward Slanted Cutting Plane: Zero Concavity)
tb_pitch      = 25.0; // 6 slots, 7 teeth across 150mm span (Matches 621-01 layout)
foot_w_back   = 14.5; // tooth width at rear wall (inner slot gap = 25 - 14.5 = 10.5mm)
foot_w_front  = 17.5; // tooth width at front tip (slot narrows to 25 - 17.5 = 7.5mm!)
foot_w        = foot_w_back; // backward compatibility
shank_w       = 5.5;  // backward compatibility
tooth_d       = 16.0; // forward protrusion from front wall (total depth = 74.0mm)
z_shelf_back  = 6.0;  // shelf height at rear wall (where toothbrush rests)
z_shelf_front = 10.5; // gentle forward-and-upward slanted plane (~15.7° slope, zero concavity!)
h_foot        = z_shelf_front; // backward compatibility
h_tooth       = z_shelf_front; // backward compatibility
h_apex        = 11.7; // subtle finial apex

// Dovetail Bracket Parameters
bracket_w  = 44.0;
bracket_h  = 34.0;
bracket_th = 2.4;
dove_th    = 4.4;
dove_w_top = 26.0;
dove_w_bot = 22.0;
dove_angle = 12.0;

// Colors
rose_gold_base  = [0.88, 0.58, 0.52];
accent_brass    = [0.82, 0.65, 0.35];
wall_tile_color = [0.93, 0.94, 0.95];


// =============================================================================
// 1. UNIVERSAL WALL MOUNTING BRACKET
// =============================================================================
module wall_bracket() {
    difference() {
        union() {
            // Flat mounting base plate
            hull() {
                translate([-bracket_w/2+4, 4, 0]) cylinder(r=4, h=bracket_th);
                translate([ bracket_w/2-4, 4, 0]) cylinder(r=4, h=bracket_th);
                translate([-bracket_w/2+4, bracket_h-4, 0]) cylinder(r=4, h=bracket_th);
                translate([ bracket_w/2-4, bracket_h-4, 0]) cylinder(r=4, h=bracket_th);
            }
            // Male dovetail wedge
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
        
        // Countersunk screw holes
        for (y_screw = [7.5, 25.5]) {
            translate([0, y_screw, -1.0]) {
                cylinder(d=4.2, h=bracket_th + dove_th + 3.0);
                translate([0, 0, bracket_th + dove_th - 2.0])
                    cylinder(r1=4.2/2, r2=8.2/2, h=2.5);
            }
        }
    }
}

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
// 2. ARCHITECTURAL TABLET BACKPLATE
// =============================================================================
module arch_backplate() {
    w = w_total;
    th_back = d_wall;
    r = 10.0;
    
    difference() {
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
                
        // Classical framed molding relief on front face
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
                                translate([-w/2 + r + 4.0, r + 4.0]) circle(r=r - 3.0);
                                translate([ w/2 - r - 4.0, r + 4.0]) circle(r=r - 3.0);
                                translate([-w/2 + r + 4.0, h_total - r - 4.0]) circle(r=r - 3.0);
                                translate([ w/2 - r - 4.0, h_total - r - 4.0]) circle(r=r - 3.0);
                            }
                }
    }
}


// =============================================================================
// 3. FRONT-WALL TOOTHBRUSH HANGING TEETH (ART DECO / PALAZZO / SATIN)
// =============================================================================
module single_hanging_tooth(style_type="faceted") {
    if (style_type == "faceted") {
        // Art Deco Diamond Faceted Tooth (★ User Selection)
        // Pure Forward-and-Upward Slanted Cutting Plane (向前向上斜線的切割面，零凹槽):
        // 1. 側向切面微調展角: 寬度從後壁 14.5mm 漸展至前緣 17.5mm (槽位開口自 10.5mm 漸縮為 7.5mm，水平卡住牙刷)
        // 2. 托盤表面純斜線仰角: 自後壁 Z=6.0mm 一路筆直向前向上仰升至前緣 Z=16.0mm (+10mm 爬坡仰升，徹底零凹槽)
        
        // Layer 0: Z = 0 to 2.0 (Bottom Chamfer Plinth, 45° overhang for 100% support-free print)
        hull() {
            translate([-foot_w_back/2 + 2.0, 0, 0]) cube([foot_w_back - 4.0, 0.1, 0.1]);
            translate([-foot_w_front/2 + 2.0, tooth_d - 2.5, 0]) cube([foot_w_front - 4.0, 0.1, 0.1]);
            translate([0, tooth_d, 0]) cylinder(r=0.5, h=0.1);
            
            translate([-foot_w_back/2, 0, 2.0]) cube([foot_w_back, 0.1, 0.1]);
            translate([-foot_w_front/2, tooth_d - 2.5, 2.0]) cube([foot_w_front, 0.1, 0.1]);
            translate([0, tooth_d, 2.0]) cylinder(r=0.5, h=0.1);
        }
        
        // Layer 1: Pure Forward-and-Upward Slanted Body
        hull() {
            translate([-foot_w_back/2, 0, 2.0]) cube([foot_w_back, 0.1, 0.1]);
            translate([-foot_w_front/2, tooth_d - 2.5, 2.0]) cube([foot_w_front, 0.1, 0.1]);
            translate([0, tooth_d, 2.0]) cylinder(r=0.5, h=0.1);
            
            translate([-foot_w_back/2, 0, z_shelf_back]) cube([foot_w_back, 0.1, 0.1]);
            translate([-foot_w_front/2, tooth_d - 2.5, z_shelf_front]) cube([foot_w_front, 0.1, 0.1]);
            translate([0, tooth_d, z_shelf_front]) cylinder(r=0.5, h=0.1);
        }
        
        // Layer 2: Diamond Apex Chamfer
        hull() {
            translate([-foot_w_front/2, tooth_d - 2.5, z_shelf_front]) cube([foot_w_front, 0.1, 0.1]);
            translate([0, tooth_d, z_shelf_front]) cylinder(r=0.5, h=0.1);
            translate([0, tooth_d - 2.0, z_shelf_front + 1.2]) cylinder(r=0.2, h=0.1);
        }
    } else if (style_type == "fluted") {
        // Roman Palazzo Fluted Pilaster Tooth
        // Layer 0: Plinth Base
        hull() {
            translate([-foot_w_back/2 + 1.5, 0, 0]) cube([foot_w_back - 3.0, 0.1, 0.1]);
            translate([-foot_w_front/2 + 1.5, tooth_d - 2.5, 0]) cube([foot_w_front - 3.0, 0.1, 0.1]);
            translate([0, tooth_d - 0.5, 0]) cylinder(r=2.0, h=0.1);
            
            translate([-foot_w_back/2, 0, 2.0]) cube([foot_w_back, 0.1, 0.1]);
            translate([-foot_w_front/2, tooth_d - 2.5, 2.0]) cube([foot_w_front, 0.1, 0.1]);
            translate([0, tooth_d, 2.0]) cylinder(r=2.5, h=0.1);
        }
        
        // Layer 1: Pure Forward-and-Upward Slanted Body
        hull() {
            translate([-foot_w_back/2, 0, 2.0]) cube([foot_w_back, 0.1, 0.1]);
            translate([-foot_w_front/2, tooth_d - 2.5, 2.0]) cube([foot_w_front, 0.1, 0.1]);
            translate([0, tooth_d, 2.0]) cylinder(r=2.5, h=0.1);
            
            translate([-foot_w_back/2, 0, z_shelf_back]) cube([foot_w_back, 0.1, 0.1]);
            translate([-foot_w_front/2, tooth_d - 2.5, z_shelf_front]) cube([foot_w_front, 0.1, 0.1]);
            translate([0, tooth_d, z_shelf_front]) cylinder(r=2.5, h=0.1);
        }
        
        // Layer 2: Classical Chamfer
        hull() {
            translate([-foot_w_front/2, tooth_d - 2.5, z_shelf_front]) cube([foot_w_front, 0.1, 0.1]);
            translate([0, tooth_d, z_shelf_front]) cylinder(r=2.5, h=0.1);
            translate([0, tooth_d - 1.5, z_shelf_front + 1.2]) cylinder(r=0.5, h=0.1);
        }
    } else {
        // Minimalist Satin Curve
        // Layer 0: Plinth Base
        hull() {
            translate([-foot_w_back/2 + 2, 0, 0]) cylinder(r=2, h=0.1);
            translate([ foot_w_back/2 - 2, 0, 0]) cylinder(r=2, h=0.1);
            translate([-foot_w_front/2 + 2, tooth_d - 2, 0]) cylinder(r=2, h=0.1);
            translate([ foot_w_front/2 - 2, tooth_d - 2, 0]) cylinder(r=2, h=0.1);
            
            translate([-foot_w_back/2 + 1.5, 0, 2.0]) cylinder(r=1.5, h=0.1);
            translate([ foot_w_back/2 - 1.5, 0, 2.0]) cylinder(r=1.5, h=0.1);
            translate([-foot_w_front/2 + 1.5, tooth_d - 2, 2.0]) cylinder(r=1.5, h=0.1);
            translate([ foot_w_front/2 - 1.5, tooth_d - 2, 2.0]) cylinder(r=1.5, h=0.1);
        }
        
        // Layer 1: Pure Forward-and-Upward Slanted Body
        hull() {
            translate([-foot_w_back/2 + 1.5, 0, 2.0]) cylinder(r=1.5, h=0.1);
            translate([ foot_w_back/2 - 1.5, 0, 2.0]) cylinder(r=1.5, h=0.1);
            translate([-foot_w_front/2 + 1.5, tooth_d - 2, 2.0]) cylinder(r=1.5, h=0.1);
            translate([ foot_w_front/2 - 1.5, tooth_d - 2, 2.0]) cylinder(r=1.5, h=0.1);
            
            translate([-foot_w_back/2 + 1.5, 0, z_shelf_back]) cylinder(r=1.5, h=0.1);
            translate([ foot_w_back/2 - 1.5, 0, z_shelf_back]) cylinder(r=1.5, h=0.1);
            translate([-foot_w_front/2 + 1.5, tooth_d - 2, z_shelf_front]) cylinder(r=1.5, h=0.1);
            translate([ foot_w_front/2 - 1.5, tooth_d - 2, z_shelf_front]) cylinder(r=1.5, h=0.1);
        }
    }
}

// 7 Teeth Array across front wall
module front_hanging_teeth_array(style_type="faceted") {
    translate([0, y_front, 0]) {
        for (i = [-3 : 3]) {
            x_pos = i * tb_pitch;
            translate([x_pos, 0, 0])
                single_hanging_tooth(style_type);
        }
    }
}


// =============================================================================
// 4. STORAGE GALLERY SOLID (外觀實體)
// =============================================================================
module squircle_body(w, d, r, h) {
    hull() {
        translate([-w/2 + r, d_wall + r, 0]) cylinder(r=r, h=h);
        translate([ w/2 - r, d_wall + r, 0]) cylinder(r=r, h=h);
        translate([-w/2 + r, d_wall + d - r, 0]) cylinder(r=r, h=h);
        translate([ w/2 - r, d_wall + d - r, 0]) cylinder(r=r, h=h);
    }
}

module storage_gallery_solid(style_type="faceted") {
    w = w_pod;
    d = d_pod;
    h = h_pod;
    
    squircle_body(w, d, 16.0, h);
    front_hanging_teeth_array(style_type);
}


// =============================================================================
// 5. STORAGE CAVITIES, CONICAL FUNNELS & THROUGH-DRAINS (頂層統一差集)
// =============================================================================
module squircle_cavity(w, d, r, h) {
    hull() {
        translate([-w/2 + r, -d/2 + r, 0]) cylinder(r=r, h=h);
        translate([ w/2 - r, -d/2 + r, 0]) cylinder(r=r, h=h);
        translate([-w/2 + r,  d/2 - r, 0]) cylinder(r=r, h=h);
        translate([ w/2 - r,  d/2 - r, 0]) cylinder(r=r, h=h);
    }
}

module rear_storage_cavities_and_drains() {
    y_cav = d_wall + d_pod/2; // 33.0mm
    z_floor = 9.0;           // Cavity floor
    h = h_pod;               // 44.0mm
    
    // 1. Cleanser Chambers (X = -66, +66) - Compatible with Ø44mm Thick Caps
    if (edition == "grand") {
        for (side = [-1, 1]) {
            cx = side * 66.0;
            translate([cx, y_cav, 0]) {
                // Squircle Cavity 46 x 44 mm
                translate([0, 0, z_floor])
                    squircle_cavity(46.0, 44.0, 12.0, h_total);
                    
                // Top Lead-in chamfer
                translate([0, 0, h - 2.5])
                    cylinder(r1=44.0/2 - 2.0, r2=44.0/2 + 2.0, h=3.0);
                    
                // 45° Conical drainage funnel (from Z=9 down to Z=5)
                translate([0, 0, z_floor - 4.0])
                    cylinder(r1=7.0, r2=12.0, h=4.01);
                    
                // Ø14.0mm Vertical Through-Drain Hole to open air below!
                translate([0, 0, -5.0])
                    cylinder(d=14.0, h=z_floor + 2.0);
                    
                // Cross-ventilation grooves (4mm wide x 2mm deep)
                translate([0, 0, z_floor]) {
                    cube([46.0, 4.0, 2.0], center=true);
                    cube([4.0, 44.0, 2.0], center=true);
                }
            }
        }
    }
    
    // 2. Toothpaste Chambers (X = -22, +22) - Compatible with Ø36mm Thick Caps
    for (side = [-1, 1]) {
        cx = side * 22.0;
        translate([cx, y_cav, 0]) {
            // Squircle Cavity 36 x 38 mm
            translate([0, 0, z_floor])
                squircle_cavity(36.0, 38.0, 10.0, h_total);
                
            // Top Lead-in chamfer
            translate([0, 0, h - 2.5])
                cylinder(r1=36.0/2 - 2.0, r2=36.0/2 + 2.0, h=3.0);
                
            // 45° Conical drainage funnel (from Z=9 down to Z=5)
            translate([0, 0, z_floor - 4.0])
                cylinder(r1=6.0, r2=10.0, h=4.01);
                
            // Ø12.0mm Vertical Through-Drain Hole to open air below!
            translate([0, 0, -5.0])
                cylinder(d=12.0, h=z_floor + 2.0);
                
            // Cross-ventilation grooves (4mm wide x 2mm deep)
            translate([0, 0, z_floor]) {
                cube([36.0, 4.0, 2.0], center=true);
                cube([4.0, 38.0, 2.0], center=true);
            }
        }
    }
}


// =============================================================================
// 6. MASTER INTEGRATED ORGANIZER (二合一旗艦主體)
// =============================================================================
module luxury_holder(style_type="faceted") {
    difference() {
        union() {
            arch_backplate();
            storage_gallery_solid(style_type);
        }
        
        // Dovetail slide receiver on rear
        female_dovetail_cavity();
        
        // Rear Chambers + Funnels + Through-Drains (Cuts straight through to open air!)
        rear_storage_cavities_and_drains();
        
        // Clean cut at Z=0 ensuring 100% planar bed adhesion
        translate([0, 0, -50.0]) cube([500.0, 500.0, 100.0], center=true);
    }
}


// =============================================================================
// 7. STANDALONE TOOTHBRUSH RACK (獨立美化壁掛牙刷架版)
// =============================================================================
module standalone_toothbrush_rack(style_type="faceted") {
    difference() {
        union() {
            // Slender backing plate
            w_rack = 166.0;
            h_rack = 34.0; // Compact matching lower column height
            th_back = 4.0;
            translate([0, th_back, 0])
                rotate([90, 0, 0])
                    linear_extrude(height=th_back)
                        hull() {
                            translate([-w_rack/2 + 5, 5]) circle(r=5);
                            translate([ w_rack/2 - 5, 5]) circle(r=5);
                            translate([-w_rack/2 + 5, h_rack - 5]) circle(r=5);
                            translate([ w_rack/2 - 5, h_rack - 5]) circle(r=5);
                        }
            // Hanging teeth on front
            translate([0, th_back, 0]) {
                for (i = [-3 : 3]) {
                    translate([i * tb_pitch, 0, 0])
                        single_hanging_tooth(style_type);
                }
            }
        }
        // Dovetail slide receiver
        female_dovetail_cavity();
        // Bed cut
        translate([0, 0, -50.0]) cube([500.0, 500.0, 100.0], center=true);
    }
}


// =============================================================================
// 8. REALISTIC PROPS MATCHING USER SETUP
// =============================================================================
module mijia_electric_brush_prop() {
    // Point 1: caught directly at the lower end of the brush head!
    // Lower end of brush head rests on forward-and-upward slanted plane at Z ~ 7.5mm
    y_brush = y_front + 5.5;
    translate([0, y_brush, 7.5]) {
        // Brush head backing & oval body (facing front)
        color([0.96, 0.96, 0.97]) {
            translate([0, 0, 11.0])
                scale([1.0, 0.65, 1.8])
                    sphere(r=5.8);
            // Slender neck passing down through 9mm slot
            translate([0, 0, -28.0])
                cylinder(d=5.6, h=28.0);
            // Text "mijia Regular" indicator
            translate([0, 2.5, -18.0])
                cube([3.5, 0.6, 12.0], center=true);
            // Flared transition to electric body
            translate([0, 0, -43.0])
                cylinder(d1=27.0, d2=11.5, h=15.0);
            // Main electric handle body
            translate([0, 0, -155.0])
                cylinder(d=27.0, h=112.0);
            translate([0, 0, -155.0])
                sphere(d=27.0);
        }
        // Bristles facing front (+Y)
        color([0.82, 0.85, 0.90])
            translate([0, 2.8, 11.0])
                cube([8.0, 4.2, 16.0], center=true);
        // Accent ring
        color([0.90, 0.85, 0.82])
            translate([0, 0, -42.5])
                cylinder(d=27.2, h=3.0);
        // Power button
        color([0.88, 0.58, 0.52])
            translate([0, 13.0, -70.0])
                rotate([90, 0, 0])
                    cylinder(d=8.0, h=2.0);
    }
}

module manual_brush_prop(color_handle=[0.92, 0.80, 0.20], color_bristle=[0.95, 0.85, 0.10]) {
    // Point 1: caught directly at the lower end of the brush head!
    // Lower end of brush head rests on slanted plane at Z ~ 7.5mm
    y_brush = y_front + 5.5;
    translate([0, y_brush, 7.5]) {
        // Brush head backing & body
        color([0.96, 0.96, 0.97]) {
            translate([0, 0, 11.5])
                scale([1.0, 0.65, 1.9])
                    sphere(r=5.5);
            // Slender neck passing down through 9mm slot
            translate([0, 0, -28.0])
                cylinder(d=4.8, h=28.0);
        }
        // Handle below
        color(color_handle) {
            translate([0, 0, -120.0]) {
                cylinder(d1=10.5, d2=8.0, h=92.0);
                sphere(d=10.5);
            }
        }
        // Grip accent
        color([0.85, 0.95, 0.30])
            translate([0, 0, -75.0])
                cylinder(d=11.2, h=35.0);
        // Bristles facing front (+Y)
        color(color_bristle)
            translate([0, 2.8, 11.5])
                cube([8.5, 4.2, 17.0], center=true);
    }
}

module toothpaste_tube_prop(color_tube=[0.22, 0.58, 0.88]) {
    color([0.92, 0.92, 0.94]) cylinder(d=32.0, h=20.0);
    color(color_tube) {
        translate([0, 0, 20.0])
            scale([1.1, 0.70, 1.0])
                cylinder(r1=15.0, r2=17.0, h=75.0);
        translate([0, 0, 95.0]) cube([37.0, 4.0, 12.0], center=true);
    }
}

module cleanser_tube_prop(color_tube=[0.85, 0.90, 0.95]) {
    color([0.94, 0.94, 0.96]) cylinder(d=40.0, h=22.0);
    color(color_tube) {
        translate([0, 0, 22.0])
            scale([1.25, 0.75, 1.0])
                cylinder(r1=19.0, r2=22.0, h=80.0);
        translate([0, 0, 102.0]) cube([46.0, 4.0, 12.0], center=true);
    }
}

module preview_assembled(style_type="faceted") {
    // Wall
    color(wall_tile_color)
        translate([0, -2.0, 50.0])
            cube([w_total + 60.0, 4.0, 260.0], center=true);
            
    // Wall Bracket
    color([0.35, 0.35, 0.38])
        translate([0, 0, 4.0])
            rotate([90, 0, 0])
                wall_bracket();
                
    // Main Holder
    color(rose_gold_base)
        luxury_holder(style_type);
        
    // Rear Cleansers & Toothpastes
    y_cav = d_wall + d_pod/2;
    translate([ 66.0, y_cav, 9.0]) cleanser_tube_prop([0.22, 0.40, 0.72]);
    translate([-66.0, y_cav, 9.0]) cleanser_tube_prop([0.92, 0.92, 0.95]);
    translate([ 22.0, y_cav, 9.0]) toothpaste_tube_prop([0.88, 0.30, 0.35]);
    translate([-22.0, y_cav, 9.0]) toothpaste_tube_prop([0.20, 0.58, 0.85]);
    
    // Front Hanging Toothbrushes (Matching user photo 1:1)
    // Looking at front wall: +X is on viewer's left, -X is on viewer's right
    // Slot 1 (X = +62.5): Empty / spare
    // Slot 2 (X = +37.5): Xiaomi Mijia White Electric Toothbrush
    translate([ 37.5, 0, 0]) mijia_electric_brush_prop();
    // Slot 3 (X = +12.5): Empty buffer slot
    // Slot 4 (X = -12.5): Yellow Manual Toothbrush
    translate([-12.5, 0, 0]) manual_brush_prop([0.95, 0.85, 0.15], [0.95, 0.80, 0.05]);
    // Slot 5 (X = -37.5): Black Manual Toothbrush
    translate([-37.5, 0, 0]) manual_brush_prop([0.15, 0.15, 0.18], [0.18, 0.18, 0.20]);
    // Slot 6 (X = -62.5): Green Manual Toothbrush
    translate([-62.5, 0, 0]) manual_brush_prop([0.15, 0.75, 0.35], [0.20, 0.85, 0.40]);
}


// =============================================================================
// 9. OUTPUT SELECTOR
// =============================================================================
if (mode == "holder") {
    color(rose_gold_base) luxury_holder(style);
} else if (mode == "bracket") {
    color([0.35, 0.35, 0.38]) wall_bracket();
} else if (mode == "plate") {
    // 1-Plate Combo: Compact footprint at Z=0 (204mm x 116mm)
    color(rose_gold_base) luxury_holder(style);
    color([0.35, 0.35, 0.38]) translate([0, y_front + 24.0, 0]) wall_bracket();
} else if (mode == "standalone_toothbrush") {
    color(rose_gold_base) standalone_toothbrush_rack(style);
} else if (mode == "assembled") {
    preview_assembled(style);
} else if (mode == "all_styles") {
    spacing = w_total + 25.0;
    translate([ spacing, 0, 0]) preview_assembled("faceted");
    translate([     0.0, 0, 0]) preview_assembled("fluted");
    translate([-spacing, 0, 0]) preview_assembled("curved");
}
