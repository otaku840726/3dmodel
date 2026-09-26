// =============================================================================
// LUXURY WALL-MOUNTED TOOTHBRUSH, TOOTHPASTE & CLEANSER ORGANIZER
// 奢華壁掛前壁一體式洗面乳牙刷牙膏置物架 (羅馬殿堂長虹柱 × 7 大萌寵 4 色旗艦版)
// Precision reverse-engineered from 621-01.stp with Front-Wall Integrated Colonnade
// =============================================================================

$fn = 40;

// Configuration Parameters
edition      = "grand";          // "grand" (2 Facial Cleansers + 2 Toothpastes + 6 Toothbrushes)
style        = "fluted";         // Primary & Canonical Edition: "fluted" (Palazzo Fluting + 7 Animal Faces)
tooth_style  = "animals";        // "animals" (7 sculpted 3D animal faces: 🐱 Cat, 🐻 Bear, 🐰 Bunny, 🐼 Panda, 🐶 Puppy, 🦊 Fox, 🐨 Koala), "plain"
wall_style   = "fluted";         // "fluted" (Classical Roman Fluting + Horizontal Beltline, Diamonds Removed)
mode         = "holder";         // "holder", "plate", "bracket", "standalone_toothbrush", "assembled", "holder_monochrome"
color_export = 0;                // 0: Full Colored Object, 1: Color 1 (Body), 2: Color 2 (Black), 3: Color 3 (Warm Pink), 4: Color 4 (Gold Trim)
side_hooks   = "both";           // "both" (左右兩側雙掛勾), "left" (僅左側), "right" (僅右側), "none" (不加掛勾)
side_hook_color = "body";        // "body" (C1 暖象牙白 - 結構一體無耗材最高強度), "gold" (C4 香檳金輕奢金屬掛勾)
side_hook_type = "cradle_1b";    // "cradle_1b" (輕奢 45° 幾何切面一體雕塑雙功能掛勾 - 兼具毛巾掛勾與刮鬍刀架)

// Master Dimensions
w_total     = 194.0; // Reduced from 204.0 to 194.0 to form a true rectangle aligned with storage pod
d_wall      = 8.0;
h_total     = 88.0;

w_pod       = 194.0;
d_pod       = 52.0;
h_pod       = 44.0; 
y_front     = d_wall + d_pod; // 60.0mm: Front vertical wall of storage gallery

// Toothbrush Hanging Parameters (Pure Forward-and-Upward Slanted Cutting Plane: Zero Concavity)
tb_pitch      = 25.0; // 6 slots, 7 teeth across 150mm span (Matches 621-01 layout)
foot_w_back   = 14.5; // tooth width at rear wall (inner slot gap = 25 - 14.5 = 10.5mm)
foot_w_front  = 17.5; // tooth width at front tip (slot narrows to 25 - 17.5 = 7.5mm!)
foot_w        = foot_w_back; // backward compatibility
shank_w       = 5.5;  // backward compatibility
tooth_d       = 16.0; // forward protrusion from front wall (total depth = 74.0mm)
z_shelf_back  = 5.5;  // shelf height at rear wall (where toothbrush rests comfortably)
z_shelf_front = 11.0; // forward-and-upward retention slope (越往外越厚: 5.5mm -> 11.0mm, zero concavity!)
h_foot        = z_shelf_front; // backward compatibility
h_tooth       = z_shelf_front; // backward compatibility
h_apex        = 11.7; // subtle finial apex
tooth_top_style = "arched"; // "arched" (全新圓弧拱頂，零積水自導正 - 用戶建議)
r_crown         = 18.0;     // 圓弧拱頂半徑 (mm)

// Dovetail Bracket Parameters
bracket_w  = 44.0;
bracket_h  = 34.0;
bracket_th = 2.4;
dove_th    = 4.4;
dove_w_top = 26.0;
dove_w_bot = 22.0;
dove_angle = 12.0;

// =============================================================================
// 4-COLOR MULTI-MATERIAL PALETTE (4 色多色 3D 列印 / AMS 最佳化配色)
// =============================================================================
c1_body  = [0.96, 0.95, 0.93]; // [Filament 1] 珠光暖象牙白 (主體結構、收納艙外壁、水滴托爪基座)
c2_black = [0.14, 0.14, 0.16]; // [Filament 2] 曜石碳素黑 (萌寵靈動眼睛、鼻子、熊貓圓耳與眼圈、貓咪鬍鬚)
c3_warm  = [0.94, 0.65, 0.58]; // [Filament 3] 蜜桃珊瑚粉 / 玫瑰金 (小兔長耳、小狗垂耳、小熊吻部、小狐耳朵、無尾熊蓬鬆耳)
c4_gold  = [0.82, 0.65, 0.35]; // [Filament 4] 典雅香檳金 / 輕奢黃銅 (羅馬長虹柱凹槽飾條、水平腰線、背板邊框飾條、快拆背板)

rose_gold_base  = c1_body;
accent_brass    = c4_gold;
wall_tile_color = [0.93, 0.94, 0.95];


// =============================================================================
// 1. UNIVERSAL WALL MOUNTING BRACKET
// =============================================================================
module wall_bracket() {
    difference() {
        union() {
            hull() {
                translate([-bracket_w/2+4, 4, 0]) cylinder(r=4, h=bracket_th);
                translate([ bracket_w/2-4, 4, 0]) cylinder(r=4, h=bracket_th);
                translate([-bracket_w/2+4, bracket_h-4, 0]) cylinder(r=4, h=bracket_th);
                translate([ bracket_w/2-4, bracket_h-4, 0]) cylinder(r=4, h=bracket_th);
            }
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
    tol = 0.35;
    h_slot = bracket_h;
    w_t = dove_w_top + tol*2;
    w_b = dove_w_bot + tol*2;
    d_s = dove_th + tol;
    ch_dove = 1.2;
    
    poly_bot = [
        [-w_t/2, -0.1],
        [-w_t/2 - d_s*tan(dove_angle), d_s],
        [ w_t/2 + d_s*tan(dove_angle), d_s],
        [ w_t/2, -0.1]
    ];
    poly_bot_chamfer = [
        [-w_t/2 - ch_dove, -0.1 - ch_dove],
        [-w_t/2 - (d_s + ch_dove)*tan(dove_angle) - ch_dove, d_s + ch_dove],
        [ w_t/2 + (d_s + ch_dove)*tan(dove_angle) + ch_dove, d_s + ch_dove],
        [ w_t/2 + ch_dove, -0.1 - ch_dove]
    ];
    poly_top = [
        [-w_b/2, -0.1],
        [-w_b/2 - d_s*tan(dove_angle), d_s],
        [ w_b/2 + d_s*tan(dove_angle), d_s],
        [ w_b/2, -0.1]
    ];
    
    // Continuous matched hull for the sliding socket (zero internal ledge)
    hull() {
        translate([0, 0, -0.5])
            linear_extrude(height=0.1) polygon(poly_bot);
        translate([0, 0, h_slot])
            linear_extrude(height=0.1) polygon(poly_top);
    }
    
    // 45° Bottom entrance lead-in chamfer (avoid sharp right-angle rim, smooth bracket alignment)
    hull() {
        translate([0, 0, -0.5])
            linear_extrude(height=0.1) polygon(poly_bot_chamfer);
        translate([0, 0, ch_dove])
            linear_extrude(height=0.1) polygon(poly_bot);
    }
    
    // 55° Self-supporting gable ceiling sloping smoothly to back wall (zero support required)
    hull() {
        translate([0, 0, h_slot])
            linear_extrude(height=0.1) polygon(poly_top);
        translate([0, 0, h_slot + d_s * 1.5])
            linear_extrude(height=0.1)
                polygon([
                    [-w_b/2, -0.1],
                    [ w_b/2, -0.1],
                    [ w_b/2,  0.05],
                    [-w_b/2,  0.05]
                ]);
    }
}


// =============================================================================
// 2. ARCHITECTURAL TABLET BACKPLATE
// =============================================================================
function backplate_bottom_polygon(w, r, min_ang=42.0, N=8) = 
    let(
        alpha_max = 90.0 - min_ang,
        z_end = r * (1.0 - sin(alpha_max)),
        x_end = -w/2 + r * (1.0 - cos(alpha_max)),
        dx = z_end / tan(min_ang),
        x_bed = x_end + dx,
        pts_left = concat(
            [[x_bed, 0]],
            [for (i = [1 : N-1]) 
                let(a = alpha_max * (1.0 - i/N))
                [-w/2 + r * (1.0 - cos(a)), r * (1.0 - sin(a))]
            ],
            [[-w/2, r]]
        ),
        pts_right = [for (i = [len(pts_left)-1 : -1 : 0]) [-pts_left[i][0], pts_left[i][1]]]
    )
    concat(pts_left, pts_right);

module arch_backplate_solid() {
    w = w_total;
    th_back = d_wall;
    r = 10.0;
    
    translate([0, th_back, 0])
        rotate([90, 0, 0])
            linear_extrude(height = th_back) {
                hull() {
                    // Multi-faceted smooth rounded corner bevels (zero sharp corners, 100% self-supporting)
                    polygon(backplate_bottom_polygon(w, r, 42.0, 8));
                    translate([-w/2 + r, r]) circle(r=r);
                    translate([ w/2 - r, r]) circle(r=r);
                    translate([-w/2 + r, h_total - r]) circle(r=r);
                    translate([ w/2 - r, h_total - r]) circle(r=r);
                }
            }
}

// Classical Molding Frame Trim (Color 4: Champagne Gold) - Exposed Upper Backplate
module arch_backplate_frame_trim() {
    w = w_total;
    th_back = d_wall;
    r = 10.0;
    
    translate([0, th_back, 0])
        rotate([90, 0, 0])
            difference() {
                linear_extrude(height = 1.0)
                    hull() {
                        translate([-w/2 + r, h_pod]) circle(r=r);
                        translate([ w/2 - r, h_pod]) circle(r=r);
                        translate([-w/2 + r, h_total - r]) circle(r=r);
                        translate([ w/2 - r, h_total - r]) circle(r=r);
                    }
                translate([0, 0, -1.0])
                    linear_extrude(height = 3.0)
                        hull() {
                            translate([-w/2 + r + 4.0, h_pod + 4.0]) circle(r=4.0);
                            translate([ w/2 - r - 4.0, h_pod + 4.0]) circle(r=4.0);
                            translate([-w/2 + r + 4.0, h_total - r - 4.0]) circle(r=4.0);
                            translate([ w/2 - r - 4.0, h_total - r - 4.0]) circle(r=4.0);
                        }
            }
}


// =============================================================================
// 3. FRONT-WALL TOOTHBRUSH HANGING TEETH & SCULPTED 3D ANIMAL FACES
// =============================================================================
animals_list = ["cat", "bear", "bunny", "panda", "puppy", "pig", "koala"];

// Conformal Whisker Helper for Cat (Surface relief tightly hugging the spherical cheek)
// 100% printable without overhangs; zero cantilever floating geometry
module cat_conformal_whisker_stroke(s, x1, z1, x2, z2, r_inner=0.45, r_outer=0.35) {
    r2_cheek = foot_w_front / 2;   // 8.75mm
    h2_cheek = z_shelf_front;      // 11.0mm
    y2_cheek = tooth_d - r2_cheek; // 7.25mm
    
    xm = (x1 + x2) / 2;
    zm = (z1 + z2) / 2;
    rm = (r_inner + r_outer) / 2;
    p_offset = 0.12; // anchors ~0.3mm into white body, protrudes ~0.45mm
    
    y_p1 = y2_cheek + sqrt(max(0, r2_cheek*r2_cheek * (1 - (z1/h2_cheek)*(z1/h2_cheek)) - x1*x1)) - p_offset;
    y_pm = y2_cheek + sqrt(max(0, r2_cheek*r2_cheek * (1 - (zm/h2_cheek)*(zm/h2_cheek)) - xm*xm)) - p_offset;
    y_p2 = y2_cheek + sqrt(max(0, r2_cheek*r2_cheek * (1 - (z2/h2_cheek)*(z2/h2_cheek)) - x2*x2)) - p_offset;
    
    hull() {
        translate([s * x1, y_p1, z1]) sphere(r=r_inner, $fn=16);
        translate([s * xm, y_pm, zm]) sphere(r=rm, $fn=16);
    }
    hull() {
        translate([s * xm, y_pm, zm]) sphere(r=rm, $fn=16);
        translate([s * x2, y_p2, z2]) sphere(r=r_outer, $fn=16);
    }
}

module cat_conformal_whiskers() {
    for (s = [-1, 1]) {
        // Upper whisker: radiating outward and slightly downward along cheek
        cat_conformal_whisker_stroke(s, 3.2, 4.6, 6.5, 4.2, r_inner=0.45, r_outer=0.35);
        // Lower whisker: angled downward in harmony
        cat_conformal_whisker_stroke(s, 3.0, 3.4, 6.2, 2.8, r_inner=0.45, r_outer=0.35);
    }
}

// Conformal Surface Y Helper on Front Tooth
function tooth_surf_y(x, z) = 
    let(r2 = foot_w_front / 2,
        h2 = z_shelf_front,
        y2 = tooth_d - r2,
        term = 1 - pow(x/r2, 2) - pow(z/h2, 2))
    (term > 0) ? (y2 + r2 * sqrt(term)) : y2;

// Conformal Support-Free Eye: Anchored 0.6mm into tooth, protruding 0.35mm out, zero overhang
module supportfree_eye(x, z, r=0.85, tilt=0, scale_xy=[1,1]) {
    y_s = tooth_surf_y(x, z);
    hull() {
        translate([x, y_s + 0.35, z + r*0.3])
            rotate([0, tilt, 0]) scale([scale_xy[0], 0.7, scale_xy[1]]) sphere(r=r*0.7, $fn=16);
        translate([x, y_s - 0.6, z])
            rotate([0, tilt, 0]) scale([scale_xy[0], 1.0, scale_xy[1]]) sphere(r=r, $fn=16);
        translate([x, y_s - 0.2, z - r])
            rotate([0, tilt, 0]) scale([scale_xy[0], 0.5, scale_xy[1]]) sphere(r=r*0.4, $fn=16);
    }
}

// Conformal Support-Free Nose: 45° upward draft taper into tooth surface
module supportfree_nose(z, rx=1.0, ry=0.8, rz=0.8, relief=0.55) {
    y_s = tooth_surf_y(0, z);
    hull() {
        translate([0, y_s + relief, z + rz*0.2])
            scale([rx, ry, rz]) sphere(r=0.6, $fn=16);
        translate([0, y_s - 0.6, z])
            scale([rx, ry, rz]) sphere(r=0.9, $fn=16);
        translate([0, y_s - 0.1, z - rz*1.2])
            scale([rx*0.7, ry*0.4, rz*0.4]) sphere(r=0.6, $fn=16);
    }
}

// Conformal Support-Free Muzzle / Snout: 48° draft angle merging seamlessly into cheek
module supportfree_muzzle(z, rx=2.2, ry=1.4, rz=1.6, relief=0.8) {
    y_s = tooth_surf_y(0, z);
    hull() {
        translate([0, y_s + relief, z + rz*0.1])
            scale([rx*0.8, ry*0.7, rz*0.7]) sphere(r=1.0, $fn=24);
        translate([0, y_s - 1.0, z])
            scale([rx, ry, rz]) sphere(r=1.0, $fn=24);
        translate([0, y_s - 0.2, z - rz*1.1])
            scale([rx*0.7, ry*0.4, rz*0.4]) sphere(r=1.0, $fn=24);
    }
}

// Pig Snout in C3 (Pink) - Conformal oval snout with self-supporting draft
module pig_snout_c3(z=4.8, rx=2.3, rz=1.5, relief=0.85) {
    y_s = tooth_surf_y(0, z);
    hull() {
        translate([0, y_s + relief, z])
            scale([rx, 0.6, rz]) sphere(r=1.0, $fn=24);
        translate([0, y_s - 0.8, z])
            scale([rx*1.1, 0.8, rz*1.1]) sphere(r=1.0, $fn=24);
        translate([0, y_s - 0.2, z - rz*1.2])
            scale([rx*0.7, 0.4, 0.5]) sphere(r=1.0, $fn=16);
    }
}

// Pig Nostril in C2 (Black) - Sits on front face of snout (enlarged & distinct)
module pig_nostril_c2(x, z, rx=0.62, rz=0.92) {
    y_s = tooth_surf_y(0, z) + 0.9;
    hull() {
        translate([x, y_s + 0.25, z])
            scale([rx, 0.4, rz]) sphere(r=1.0, $fn=16);
        translate([x, y_s - 0.6, z])
            scale([rx, 0.6, rz]) sphere(r=1.0, $fn=16);
        translate([x, y_s - 0.1, z - rz*0.8])
            scale([rx*0.6, 0.3, rz*0.4]) sphere(r=1.0, $fn=16);
    }
}

// Pig Folded Triangular Ears in C3 (Pink)
module pig_ears_c3() {
    y_center = tooth_d - foot_w_front / 2;
    for (s = [-1, 1]) {
        hull() {
            translate([s * 3.6, y_center + 0.6, 9.4]) scale([1.2, 0.8, 1.0]) sphere(r=1.4, $fn=16);
            translate([s * 5.6, y_center + 0.4, 8.4]) scale([1.2, 0.8, 1.0]) sphere(r=1.3, $fn=16);
            translate([s * 4.8, y_center + 1.2, 10.8]) scale([1.0, 0.7, 0.8]) sphere(r=1.1, $fn=16);
            translate([s * 4.4, y_center + 1.9, 9.2]) scale([1.0, 0.7, 0.7]) sphere(r=1.0, $fn=16);
            translate([s * 4.2, y_center + 0.6, 7.8]) sphere(r=1.1, $fn=16);
        }
    }
}

// Pig Conformal Blush in C3 (Peach/Pink) - Perfectly aligned with cheek normal & surface curvature
module pig_conformal_blush_c3() {
    x_b = 4.4;
    z_b = 4.6;
    y_b = tooth_surf_y(x_b, z_b);
    phi = 33.6;   // yaw around Z
    theta = 20.1; // pitch around X
    
    for (s = [-1, 1]) {
        translate([s * x_b, y_b, z_b])
            rotate([0, 0, -s * phi])
                rotate([-theta, 0, 0])
                    rotate([0, 0, -s * 10]) {
                        hull() {
                            // Subtle, smooth conformal dome (protruding only 0.28mm from cheek)
                            translate([0, 0.15, 0])
                                scale([1.3, 0.15, 0.85]) sphere(r=1.0, $fn=24);
                            // Deep anchor into cheek flesh
                            translate([0, -0.6, 0])
                                scale([1.4, 0.5, 0.95]) sphere(r=1.0, $fn=24);
                            // Self-supporting draft taper
                            translate([0, -0.2, -0.85])
                                scale([0.9, 0.2, 0.5]) sphere(r=1.0, $fn=16);
                        }
                    }
    }
}

// Color 2: Black Accents (Eyes, Noses, Panda ears, Cat Whiskers)
module animal_features_c2(animal) {
    y_center = tooth_d - foot_w_front / 2; // 7.25mm
    
    if (animal == "bear") {
        supportfree_nose(5.6, rx=1.45, ry=1.1, rz=1.15, relief=1.05);
        for (s = [-1, 1]) supportfree_eye(s * 3.4, 7.5, 0.85);
    } else if (animal == "cat") {
        supportfree_nose(5.2, rx=1.1, ry=0.7, rz=0.7, relief=0.45);
        for (s = [-1, 1]) supportfree_eye(s * 3.5, 7.2, 0.9, tilt=s * 15, scale_xy=[1.2, 0.9]);
        cat_conformal_whiskers();
    } else if (animal == "bunny") {
        supportfree_nose(5.0, rx=0.9, ry=0.7, rz=0.7, relief=0.45);
        for (s = [-1, 1]) supportfree_eye(s * 3.2, 7.2, 0.85);
    } else if (animal == "panda") {
        for (s = [-1, 1]) {
            hull() {
                translate([s * 4.8, y_center + 1.0, 9.8]) scale([1.0, 0.8, 1.0]) sphere(r=1.9, $fn=24);
                translate([s * 3.8, y_center - 0.4, 7.5]) scale([1.0, 0.8, 1.0]) sphere(r=1.4, $fn=16);
            }
        }
        for (s = [-1, 1]) supportfree_eye(s * 3.5, 7.0, 1.35, tilt=s * -25, scale_xy=[1.3, 0.95]);
        supportfree_nose(5.4, rx=1.0, ry=0.8, rz=0.8, relief=0.5);
    } else if (animal == "puppy") {
        supportfree_nose(5.6, rx=1.2, ry=0.8, rz=0.8, relief=0.55);
        for (s = [-1, 1]) supportfree_eye(s * 3.4, 7.4, 0.9);
    } else if (animal == "pig") {
        for (s = [-1, 1]) supportfree_eye(s * 3.2, 7.2, 0.85);
        pig_nostril_c2(-1.1, 4.8);
        pig_nostril_c2( 1.1, 4.8);
    } else if (animal == "fox") {
        supportfree_nose(5.2, rx=0.85, ry=0.7, rz=0.7, relief=0.45);
        for (s = [-1, 1]) supportfree_eye(s * 3.5, 7.2, 0.9, tilt=s * 25, scale_xy=[1.3, 0.8]);
    } else if (animal == "koala") {
        supportfree_nose(5.4, rx=1.3, ry=0.9, rz=1.6, relief=0.75);
        for (s = [-1, 1]) supportfree_eye(s * 3.4, 7.4, 0.85);
    }
}

// Color 3: Warm Peach / Pink Accents (Ears, Muzzles, Cheeks)
module animal_features_c3(animal) {
    y_center = tooth_d - foot_w_front / 2; // 7.25mm
    
    if (animal == "bear") {
        for (s = [-1, 1]) {
            hull() {
                translate([s * 4.8, y_center + 1.2, 10.0]) scale([1.0, 0.8, 1.0]) sphere(r=2.0, $fn=24);
                translate([s * 3.8, y_center - 0.3, 8.0]) scale([1.0, 0.8, 1.0]) sphere(r=1.6, $fn=16);
            }
        }
        supportfree_muzzle(4.8, 2.2, 1.4, 1.6, relief=0.75);
    } else if (animal == "cat") {
        for (s = [-1, 1]) {
            hull() {
                translate([s * 4.2, y_center + 0.8, 9.2]) sphere(r=1.5, $fn=16);
                translate([s * 5.4, y_center + 1.2, 12.8]) sphere(r=0.8, $fn=16);
                translate([s * 3.5, y_center + 0.2, 7.5]) sphere(r=1.2, $fn=16);
            }
        }
    } else if (animal == "bunny") {
        for (s = [-1, 1]) {
            hull() {
                translate([s * 3.2, y_center + 0.5, 9.5]) sphere(r=1.5, $fn=16);
                translate([s * 3.8, y_center + 0.2, 14.5]) sphere(r=1.1, $fn=16);
                translate([s * 2.8, y_center - 0.2, 8.0]) sphere(r=1.4, $fn=16);
            }
        }
        for (s = [-1, 1]) supportfree_eye(s * 1.5, 4.4, 1.2, scale_xy=[1.1, 0.9]);
    } else if (animal == "panda") {
        supportfree_muzzle(4.6, 2.0, 1.2, 1.4, relief=0.7);
    } else if (animal == "puppy") {
        for (s = [-1, 1]) {
            hull() {
                translate([s * 5.2, y_center + 1.2, 9.5]) sphere(r=1.6, $fn=16);
                translate([s * 6.2, y_center + 3.8, 6.2]) sphere(r=1.7, $fn=16);
                translate([s * 5.2, y_center + 3.2, 4.2]) sphere(r=1.4, $fn=16);
            }
        }
        supportfree_muzzle(4.6, 2.3, 1.3, 1.5, relief=0.75);
    } else if (animal == "pig") {
        pig_ears_c3();
        pig_snout_c3();
        pig_conformal_blush_c3();
    } else if (animal == "fox") {
        for (s = [-1, 1]) {
            hull() {
                translate([s * 4.4, y_center + 0.8, 9.2]) sphere(r=1.5, $fn=16);
                translate([s * 5.8, y_center + 0.8, 13.2]) sphere(r=0.8, $fn=16);
                translate([s * 3.6, y_center + 0.2, 7.5]) sphere(r=1.2, $fn=16);
            }
        }
        supportfree_muzzle(4.8, 1.8, 1.3, 1.3, relief=0.65);
    } else if (animal == "koala") {
        for (s = [-1, 1]) {
            hull() {
                translate([s * 5.4, y_center + 1.0, 9.4]) scale([1.0, 0.8, 1.0]) sphere(r=2.3, $fn=24);
                translate([s * 4.2, y_center - 0.4, 7.2]) scale([1.0, 0.8, 1.0]) sphere(r=1.6, $fn=16);
            }
        }
    }
}

// Complete animal features (all colors unioned for single-color print)
module animal_features(animal) {
    animal_features_c2(animal);
    animal_features_c3(animal);
}

module single_hanging_tooth(style_type="fluted", animal_idx=-1) {
    r1 = foot_w_back / 2;  // 7.25mm
    r2 = foot_w_front / 2; // 8.75mm
    y1 = 0.0;
    y2 = tooth_d - r2;     // 16.0 - 8.75 = 7.25mm
    h1 = z_shelf_back;     // 5.5mm
    h2 = z_shelf_front;    // 11.0mm
    ch_bot = 1.2;          // 45° bottom edge chamfer (avoid sharp 90° equator cut)
    
    union() {
        difference() {
            hull() {
                translate([0, y1, 0]) scale([1.0, 1.0, h1/r1]) sphere(r=r1);
                translate([0, y2, 0]) scale([1.0, 1.0, h2/r2]) sphere(r=r2);
            }
            translate([0, 0, -10.0]) cube([100.0, 100.0, 20.0], center=true);
            translate([0, -53.0, 0]) cube([100.0, 100.0, 100.0], center=true);
            // 45° bottom edge chamfer around teardrop perimeter (silky touch, anti-cut)
            difference() {
                translate([0, 0, ch_bot/2]) cube([50.0, 50.0, ch_bot + 0.01], center=true);
                hull() {
                    translate([0, y1, -0.1]) cylinder(r1=r1 - ch_bot, r2=r1, h=ch_bot + 0.2);
                    translate([0, y2, -0.1]) cylinder(r1=r2 - ch_bot, r2=r2, h=ch_bot + 0.2);
                }
            }
        }
        
        if (tooth_style == "animals" && animal_idx >= 0) {
            animal = animals_list[animal_idx % 7];
            animal_features(animal);
        }
    }
}

// 7 Animals Arrays for Multi-Color Export
module front_animals_c2() {
    translate([0, y_front, 0]) {
        for (i = [-3 : 3]) {
            x_pos = i * tb_pitch;
            animal = animals_list[i + 3];
            translate([x_pos, 0, 0]) animal_features_c2(animal);
        }
    }
}

module front_animals_c3() {
    translate([0, y_front, 0]) {
        for (i = [-3 : 3]) {
            x_pos = i * tb_pitch;
            animal = animals_list[i + 3];
            translate([x_pos, 0, 0]) animal_features_c3(animal);
        }
    }
}

// 7 Teeth Array across front wall (Full Unified)
module front_hanging_teeth_array(style_type="fluted") {
    translate([0, y_front, 0]) {
        for (i = [-3 : 3]) {
            x_pos = i * tb_pitch;
            translate([x_pos, 0, 0])
                single_hanging_tooth(style_type, i + 3);
        }
    }
}


// =============================================================================
// 4. STORAGE GALLERY SOLID & CLASSICAL ARCHITECTURAL FLUTING
// =============================================================================
module fused_master_body() {
    w = w_total;
    r_back = 10.0;
    r_front = 14.0;
    ch_front = 2.5; // Top chamfer on front wall and front corners
    ch_bot = 1.2;   // Bottom perimeter 45° anti-cut chamfer
    
    // 1. Monolithic Lower Storage Pod Body (Z = 0 to h_pod = 44.0)
    // Seamlessly integrates the storage box with the backplate (from Y = 0 to Y = y_front = 60.0)
    hull() {
        // Base at Z = 0 (45° anti-cut chamfered around outer perimeter)
        translate([-w/2 + r_back, r_back, 0]) cylinder(r=r_back - ch_bot, h=0.1);
        translate([ w/2 - r_back, r_back, 0]) cylinder(r=r_back - ch_bot, h=0.1);
        translate([-w/2 + r_front, y_front - r_front, 0]) cylinder(r=r_front - ch_bot, h=0.1);
        translate([ w/2 - r_front, y_front - r_front, 0]) cylinder(r=r_front - ch_bot, h=0.1);
        
        // Footprint at Z = ch_bot (full footprint)
        translate([-w/2 + r_back, r_back, ch_bot]) cylinder(r=r_back, h=0.1);
        translate([ w/2 - r_back, r_back, ch_bot]) cylinder(r=r_back, h=0.1);
        translate([-w/2 + r_front, y_front - r_front, ch_bot]) cylinder(r=r_front, h=0.1);
        translate([ w/2 - r_front, y_front - r_front, ch_bot]) cylinder(r=r_front, h=0.1);
        
        // Footprint at Z = h_pod - ch_front
        translate([-w/2 + r_back, r_back, h_pod - ch_front]) cylinder(r=r_back, h=0.1);
        translate([ w/2 - r_back, r_back, h_pod - ch_front]) cylinder(r=r_back, h=0.1);
        translate([-w/2 + r_front, y_front - r_front, h_pod - ch_front]) cylinder(r=r_front, h=0.1);
        translate([ w/2 - r_front, y_front - r_front, h_pod - ch_front]) cylinder(r=r_front, h=0.1);
        
        // Top deck at Z = h_pod:
        // Rear and side edges maintain full profile to meet the backplate with ZERO gap!
        // Front wall and front corners chamfer smoothly by ch_front
        translate([-w/2 + r_back, r_back, h_pod]) cylinder(r=r_back, h=0.1);
        translate([ w/2 - r_back, r_back, h_pod]) cylinder(r=r_back, h=0.1);
        translate([-w/2 + r_front, y_front - r_front - ch_front, h_pod]) cylinder(r=r_front - ch_front, h=0.1);
        translate([ w/2 - r_front, y_front - r_front - ch_front, h_pod]) cylinder(r=r_front - ch_front, h=0.1);
    }
    
    // 2. Upper Architectural Backplate (Z = h_pod to h_total = 88.0)
    // Continuous monolithic extension of the rear wall (from Y = 0 to Y = d_wall = 8.0)
    translate([0, d_wall, 0])
        rotate([90, 0, 0])
            linear_extrude(height = d_wall)
                hull() {
                    translate([-w/2 + r_back, h_pod - 1.0]) circle(r=r_back);
                    translate([ w/2 - r_back, h_pod - 1.0]) circle(r=r_back);
                    translate([-w/2 + r_back, h_total - r_back]) circle(r=r_back);
                    translate([ w/2 - r_back, h_total - r_back]) circle(r=r_back);
                }
}

// Classical Architectural Fluting & Champagne Gold Trim (Color 4)
module supportfree_beltline() {
    translate([0, y_front + 0.1, 28.0])
        rotate([0, 90, 0])
            linear_extrude(height=158.0, center=true)
                polygon([
                    [-0.8, -0.6],  // back bottom inside wall
                    [-0.8, -0.1],  // front wall contact bottom (Z=27.2)
                    [ 0.0,  0.5],  // front beltline midpoint (53° upward draft! Z=28.0)
                    [ 0.4,  0.5],  // front top vertical facet (Z=28.4)
                    [ 0.7, -0.6]   // back top inside wall
                ]);
}

module flute_single(fx) {
    hull() {
        // Top cap at Z=25
        translate([fx, y_front + 0.1, 25.0]) rotate([-90, 0, 0]) cylinder(d=2.2, h=1.0);
        // Mid body at Z=12.5
        translate([fx, y_front + 0.1, 12.5]) rotate([-90, 0, 0]) cylinder(d=2.2, h=1.0);
        // Base taper: slopes at 55 deg into wall at Z=10.2 (100% self-supporting)
        translate([fx, y_front - 0.2, 10.2]) cube([1.8, 0.4, 0.2], center=true);
    }
}

module architectural_trim_c4() {
    // 1. Horizontal Beltline at Z=28mm (Beveled 53° self-supporting cross-section)
    supportfree_beltline();
        
    // 2. Classical Vertical Fluting on front wall (55° self-supporting tapered base)
    for (fx = [-w_pod/2 + 22 : 6.0 : w_pod/2 - 22]) {
        flute_single(fx);
    }
    
    // 3. Backplate Molding Frame
    arch_backplate_frame_trim();
}

// =============================================================================
// =============================================================================
// 4b. SUPPORT-FREE SIDE UTILITY HOOKS (輕奢一體雕塑雙功能外擴鞍座掛勾 - 1B 專用款)
// =============================================================================
// 100% 遵守 FDM 3D 列印自支撐法則（底部 45° 平滑自支撐爬升斜面，列印時零支撐）。
// 兼顧雙重用途：
// 1. 刮鬍刀專用架：中央引導鞍槽由內向外漸擴開展（壁側 11.5mm → 前端 18.0mm），
//    能同時適配細柄傳統雙刃安全刮鬍刀（深靠內側）與粗柄人體工學刀柄（外側自然自定心卡托）。
// 2. 頂面圓滑弧形凹槽：頂面呈連續圓滑凹槽鞍面，刀頭橫跨置放時更加貼合，手指拿取順手優雅。
// 3. 左右雕塑雙角：苗條修長不笨重（壁厚約 4.8mm），外側經 45° 切面修飾，角尖平滑倒角微翹防滑落。
// 全體邊緣經 R=0.65mm 空間球體柔潤微圓角處理，完全無生硬直角與割手稜角。
module octagonal_profile_2d(w, h, ch) {
    polygon([
        [-w/2 + ch, -h/2],
        [w/2 - ch, -h/2],
        [w/2, -h/2 + ch],
        [w/2, h/2 - ch],
        [w/2 - ch, h/2],
        [-w/2 + ch, h/2],
        [-w/2, h/2 - ch],
        [-w/2, -h/2 + ch]
    ]);
}

module monolithic_dual_utility_cradle(side=1) {
    x_base = side * (w_pod/2); // ±97.0mm
    y_center = d_wall + d_pod/2; // 34.0mm
    z_center = 22.0;
    
    w_base    = 34.0;   // Base width in Y
    h_base    = 38.0;   // Base height in Z
    ch_corner = 4.5;    // Octagonal corner chamfer
    th_bevel  = 3.0;    // Wall perimeter bevel depth in X
    d_proj    = 23.0;   // Forward reach in X
    h_tip     = 12.5;   // Horn tip height in Z (proud, upward-hooking to secure razor)
    
    // Flare specifications: 越往外越開
    gap_rear  = 11.5;   // Gap near wall (fits slim DE safety razors)
    gap_front = 18.0;   // Gap at tips (fits thick ergonomic razors)
    prong_w   = 4.5;    // Slender horn thickness (左右兩根沒那麼粗)
    r_edge    = 0.60;   // Soft edge fillet

    translate([x_base, y_center, z_center]) {
        // Internal wall anchor pin (stays inside wall X <= 0)
        translate([-side * 3.0, 0, 0]) rotate([0, 90, 0])
            cylinder(d=6.0, h=3.0, center=false, $fn=24);

        scale([side, 1, 1]) {
            difference() {
                hull() {
                    // 1. 貼牆八角底面 (X = 0)
                    translate([0, 0, 0]) rotate([0, 90, 0])
                        linear_extrude(height=0.1)
                            octagonal_profile_2d(w_base, h_base, ch_corner);
                            
                    // 2. 45° 倒角過渡階 (X = th_bevel = 3.0)
                    translate([th_bevel, 0, 0]) rotate([0, 90, 0])
                        linear_extrude(height=0.1)
                            octagonal_profile_2d(w_base - 2*th_bevel, h_base - 2*th_bevel, ch_corner - 1.0);
                            
                    // 3. 左側尖端 (3D 圓球穹頂，向外開展至 gap_front，向上昂起防滑)
                    translate([d_proj, (gap_front/2 + prong_w/2), h_tip])
                        rotate([0, 30, 14])
                            sphere(d=prong_w, $fn=24);

                    // 4. 右側尖端 (3D 圓球穹頂，向外開展至 gap_front，向上昂起防滑)
                    translate([d_proj, -(gap_front/2 + prong_w/2), h_tip])
                        rotate([0, 30, -14])
                            sphere(d=prong_w, $fn=24);

                    // 5. 底部 45° 平滑自支撐爬升斜面 (100% 零支撐保證)
                    translate([d_proj - 6.0, 0, -h_base/2 + th_bevel + (d_proj - 6.0 - th_bevel)])
                        cube([0.5, gap_rear + 2.0, 1.0], center=true);
                }

                // =============================================================
                // 細節 1: 兩根的根部到前端是凹型的 (Top Concave Saddle Dish)
                // 自根部至前端雕琢出圓滑下凹鞍面，穩固托住刮鬍刀頭，避免前後晃動滑落
                // =============================================================
                translate([d_proj * 0.54, 0, 22.5])
                    rotate([0, 90, 90])
                        cylinder(r=13.5, h=w_base * 1.5, center=true, $fn=64);

                // =============================================================
                // 細節 2: 兩根中間的部分往根部內縮 (Deep Recessed V-Trough)
                // 深度內縮至 X = 1.2mm，並提供手柄垂直下垂空間，確保手柄 100% 垂直直立
                // =============================================================
                hull() {
                    // 前端口 (寬度 gap_front = 18.0mm，越往外越開)
                    translate([d_proj + 3.0, 0, 15.0])
                        cube([4.0, gap_front, 10.0], center=true);
                    // 深度內縮根部口 (往根部縮至 X = 1.2mm，寬度 gap_rear = 11.5mm)
                    translate([1.2, 0, 15.0])
                        cube([2.0, gap_rear, 10.0], center=true);
                    // 前段圓弧槽底
                    translate([d_proj - 3.0, 0, 2.0])
                        rotate([0, 90, 0])
                            cylinder(d=5.5, h=4.0, center=true, $fn=32);
                    // 根部深度內縮圓弧 U 形凹口 (X = 1.2mm，半徑 5.75mm)
                    translate([1.2, 0, 0.5])
                        rotate([0, 90, 0])
                            cylinder(d=gap_rear, h=2.0, center=true, $fn=32);
                    // 手柄垂直垂放容置槽 (使各種粗細手柄皆可筆直垂立)
                    translate([d_proj * 0.45, 0, -9.0])
                        cube([d_proj * 0.65, gap_rear, 14.0], center=true);
                }

                // 背板頂部柔潤凹槽修飾 (手指拿取空間)
                translate([th_bevel + 8.5, 0, h_base/2 + 6.5])
                    rotate([0, 75, 0])
                        scale([1.0, 1.45, 0.75])
                            cylinder(r=13.0, h=w_base * 1.5, center=true, $fn=64);
            }
        }
    }
}

module side_utility_hooks() {
    if (side_hooks == "both" || side_hooks == "left") {
        monolithic_dual_utility_cradle(-1);
    }
    if (side_hooks == "both" || side_hooks == "right") {
        monolithic_dual_utility_cradle(1);
    }
}


// =============================================================================
// 5. STORAGE CAVITIES, CONICAL FUNNELS & THROUGH-DRAINS (頂層統一差集)
// =============================================================================
// Flush-Rear Storage Cavity Module
// Rear wall is flush at Y = d_wall = 8.0mm (backplate serves directly as the rear wall!)
// Smooth 45° mouth lead-in chamfer on front and sides for luxurious bottle guidance
module flush_rear_cavity(w_c, y_front_c=56.0, r_c=8.0, h_c=h_total, ch_mouth=1.5) {
    y_rear_c = d_wall; // 8.0mm
    
    // Main pocket
    hull() {
        translate([-w_c/2 + r_c, y_front_c - r_c, 0]) cylinder(r=r_c, h=h_c);
        translate([ w_c/2 - r_c, y_front_c - r_c, 0]) cylinder(r=r_c, h=h_c);
        translate([-w_c/2 + 2.0, y_rear_c + 2.0, 0]) cylinder(r=2.0, h=h_c);
        translate([ w_c/2 - 2.0, y_rear_c + 2.0, 0]) cylinder(r=2.0, h=h_c);
    }
    
    // Mouth chamfer (front and sides only, rear stays vertical flush with backplate)
    hull() {
        translate([-w_c/2 + r_c, y_front_c - r_c, h_pod - 9.0 - 2.0]) cylinder(r=r_c, h=0.1);
        translate([ w_c/2 - r_c, y_front_c - r_c, h_pod - 9.0 - 2.0]) cylinder(r=r_c, h=0.1);
        translate([-w_c/2 + 2.0, y_rear_c + 2.0, h_pod - 9.0 - 2.0]) cylinder(r=2.0, h=0.1);
        translate([ w_c/2 - 2.0, y_rear_c + 2.0, h_pod - 9.0 - 2.0]) cylinder(r=2.0, h=0.1);
        
        translate([-w_c/2 + r_c - ch_mouth, y_front_c - r_c + ch_mouth, h_pod - 9.0 + 0.5]) cylinder(r=r_c + ch_mouth, h=0.1);
        translate([ w_c/2 - r_c + ch_mouth, y_front_c - r_c + ch_mouth, h_pod - 9.0 + 0.5]) cylinder(r=r_c + ch_mouth, h=0.1);
        translate([-w_c/2 + 2.0 - ch_mouth, y_rear_c + 2.0, h_pod - 9.0 + 0.5]) cylinder(r=2.0, h=0.1);
        translate([ w_c/2 - 2.0 + ch_mouth, y_rear_c + 2.0, h_pod - 9.0 + 0.5]) cylinder(r=2.0, h=0.1);
    }
}

module rear_storage_cavities_and_drains() {
    z_floor = 9.0;           // Cavity floor
    h = h_pod;               // 44.0mm
    y_drain = 32.0;          // Center of drainage hole (halfway between Y=8 and Y=56)
    
    // 1. Cleanser Chambers (X = -67.0, +67.0) - Sized 46mm x 48mm (Expansive volume)
    for (side = [-1, 1]) {
        cx = side * 67.0;
        translate([cx, 0, 0]) {
            translate([0, 0, z_floor])
                flush_rear_cavity(46.0, y_front_c=56.0, r_c=8.0);
            
            // Floor conical guidance funnel (widens to 24mm at cavity floor for rapid water intake)
            translate([0, y_drain, z_floor - 4.0])
                cylinder(r1=18.0/2, r2=12.0, h=4.01);
            // 100% continuous straight-through drainage hole (Ø18.0mm expanded)
            translate([0, y_drain, -5.0])
                cylinder(d=18.0, h=z_floor + 20.0);
            // 45° bottom exit countersink chamfer (smooth to touch, anti-cut)
            translate([0, y_drain, -0.1])
                cylinder(r1=18.0/2 + 1.2, r2=18.0/2, h=1.3);
            // Floor cross drainage channels
            translate([0, y_drain, z_floor]) {
                cube([46.0, 4.0, 2.0], center=true);
                cube([4.0, 48.0, 2.0], center=true);
            }
        }
    }
    
    // 2. Toothpaste Chambers (X = -21.5, +21.5) - Sized 38mm x 48mm (Expansive volume)
    for (side = [-1, 1]) {
        cx = side * 21.5;
        translate([cx, 0, 0]) {
            translate([0, 0, z_floor])
                flush_rear_cavity(38.0, y_front_c=56.0, r_c=8.0);
            
            // Floor conical guidance funnel (widens to 24mm at cavity floor for rapid water intake)
            translate([0, y_drain, z_floor - 4.0])
                cylinder(r1=18.0/2, r2=12.0, h=4.01);
            // 100% continuous straight-through drainage hole (Ø18.0mm expanded)
            translate([0, y_drain, -5.0])
                cylinder(d=18.0, h=z_floor + 20.0);
            // 45° bottom exit countersink chamfer (smooth to touch, anti-cut)
            translate([0, y_drain, -0.1])
                cylinder(r1=18.0/2 + 1.2, r2=18.0/2, h=1.3);
            // Floor cross drainage channels
            translate([0, y_drain, z_floor]) {
                cube([38.0, 4.0, 2.0], center=true);
                cube([4.0, 48.0, 2.0], center=true);
            }
        }
    }
}


// =============================================================================
// 6. MULTI-COLOR DISCRETE SOLIDS & FULL INTEGRATED MASTER HOLDER
// =============================================================================

// Solid 1: Pearl Warm White Base Body (Main Structure + Wells + Teeth Bases)
module luxury_holder_c1() {
    difference() {
        union() {
            fused_master_body();
            translate([0, y_front, 0]) {
                for (i = [-3 : 3]) {
                    translate([i * tb_pitch, 0, 0])
                        single_hanging_tooth("fluted", -1);
                }
            }
            if (side_hook_color == "body") {
                side_utility_hooks();
            }
        }
        
        // Subtract C4 trim grooves for seamless puzzle fit
        architectural_trim_c4();
        if (side_hook_color == "gold") {
            side_utility_hooks();
        }
        
        female_dovetail_cavity();
        rear_storage_cavities_and_drains();
        translate([0, 0, -50.0]) cube([500.0, 500.0, 100.0], center=true);
    }
}

// Solid 2: Obsidian Charcoal Black Features (Eyes, Noses, Panda ears & eye patches, Cat whiskers)
module luxury_holder_c2() {
    front_animals_c2();
}

// Solid 3: Pastel Coral Peach / Pink Details (Ears, Muzzles, Cheeks)
module luxury_holder_c3() {
    front_animals_c3();
}

// Solid 4: Champagne Gold Architectural Trim (Fluting inlays, Beltline, Molding frame)
module luxury_holder_c4() {
    architectural_trim_c4();
    if (side_hook_color == "gold") {
        side_utility_hooks();
    }
}

// Complete 4-Color Assembly with Full OpenSCAD Palette Preview
module luxury_holder_4color() {
    color(c1_body)  luxury_holder_c1();
    color(c2_black) luxury_holder_c2();
    color(c3_warm)  luxury_holder_c3();
    color(c4_gold)  luxury_holder_c4();
}

// Complete Unified Monolithic Solid (100% Watertight Single-Material Print)
module luxury_holder_monochrome() {
    union() {
        luxury_holder_c1();
        luxury_holder_c2();
        luxury_holder_c3();
        luxury_holder_c4();
    }
}

module luxury_holder(style_type="fluted") {
    luxury_holder_4color();
}


// =============================================================================
// 7. STANDALONE TOOTHBRUSH RACK (獨立美化壁掛牙刷架版)
// =============================================================================
module standalone_toothbrush_rack(style_type="fluted") {
    difference() {
        union() {
            w_rack = 166.0;
            h_rack = 34.0;
            th_back = 4.0;
            translate([0, th_back, 0])
                rotate([90, 0, 0])
                    linear_extrude(height=th_back)
                        hull() {
                            translate([-w_rack/2 + 5, 5]) circle(r=5);
                            translate([ w_rack/2 - 5, 5]) circle(r=5);
                            translate([-w_rack/2 + 8, h_rack - 4]) circle(r=3);
                            translate([ w_rack/2 - 8, h_rack - 4]) circle(r=3);
                        }
            translate([0, th_back, 0]) {
                for (i = [-3 : 3]) {
                    translate([i * tb_pitch, 0, 0])
                        single_hanging_tooth(style_type, i + 3);
                }
            }
        }
        female_dovetail_cavity();
        translate([0, 0, -50.0]) cube([500.0, 500.0, 100.0], center=true);
    }
}


// =============================================================================
// 8. REALISTIC PROPS MATCHING USER SETUP
// =============================================================================
module mijia_electric_brush_prop() {
    y_brush = y_front + 5.5;
    translate([0, y_brush, 7.5]) {
        color([0.96, 0.96, 0.97]) {
            translate([0, 0, 11.0])
                scale([1.0, 0.65, 1.8])
                    sphere(r=5.8);
            translate([0, 0, -28.0])
                cylinder(d=5.6, h=28.0);
            translate([0, 2.5, -18.0])
                cube([3.5, 0.6, 12.0], center=true);
            translate([0, 0, -43.0])
                cylinder(d1=27.0, d2=11.5, h=15.0);
            translate([0, 0, -155.0])
                cylinder(d=27.0, h=112.0);
            translate([0, 0, -155.0])
                sphere(d=27.0);
        }
        color([0.82, 0.85, 0.90])
            translate([0, 2.8, 11.0])
                cube([8.0, 4.2, 16.0], center=true);
        color([0.90, 0.85, 0.82])
            translate([0, 0, -42.5])
                cylinder(d=27.2, h=3.0);
        color([0.88, 0.58, 0.52])
            translate([0, 13.0, -70.0])
                rotate([90, 0, 0])
                    cylinder(d=8.0, h=2.0);
    }
}

module manual_brush_prop(color_handle=[0.92, 0.80, 0.20], color_bristle=[0.95, 0.85, 0.10]) {
    y_brush = y_front + 5.5;
    translate([0, y_brush, 7.5]) {
        color([0.96, 0.96, 0.97]) {
            translate([0, 0, 11.5])
                scale([1.0, 0.65, 1.9])
                    sphere(r=5.5);
            translate([0, 0, -28.0])
                cylinder(d=4.8, h=28.0);
        }
        color(color_handle) {
            translate([0, 0, -120.0]) {
                cylinder(d1=10.5, d2=8.0, h=92.0);
                sphere(d=10.5);
            }
        }
        color([0.85, 0.95, 0.30])
            translate([0, 0, -75.0])
                cylinder(d=11.2, h=35.0);
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

module preview_assembled(style_type="fluted") {
    color(wall_tile_color)
        translate([0, -2.0, 50.0])
            cube([w_total + 60.0, 4.0, 260.0], center=true);
            
    color(c4_gold)
        translate([0, 0, 4.0])
            rotate([90, 0, 0])
                wall_bracket();
                
    // Main 4-Color Luxury Holder
    luxury_holder_4color();
    
    // Rear Cleansers & Toothpastes
    y_cav = 32.0;
    translate([ 67.0, y_cav, 9.0]) cleanser_tube_prop([0.22, 0.40, 0.72]);
    translate([-67.0, y_cav, 9.0]) cleanser_tube_prop([0.92, 0.92, 0.95]);
    translate([ 21.5, y_cav, 9.0]) toothpaste_tube_prop([0.88, 0.30, 0.35]);
    translate([-21.5, y_cav, 9.0]) toothpaste_tube_prop([0.20, 0.58, 0.85]);
    
    // Front Hanging Toothbrushes
    translate([ 37.5, 0, 0]) mijia_electric_brush_prop();
    translate([-12.5, 0, 0]) manual_brush_prop([0.95, 0.85, 0.15], [0.95, 0.80, 0.05]);
    translate([-37.5, 0, 0]) manual_brush_prop([0.15, 0.15, 0.18], [0.18, 0.18, 0.20]);
    translate([-62.5, 0, 0]) manual_brush_prop([0.15, 0.75, 0.35], [0.20, 0.85, 0.40]);
}


// =============================================================================
// 9. OUTPUT SELECTOR (DISCRETE COLOR EXPORT & ASSEMBLY MODES)
// =============================================================================
if (color_export == 1) {
    // Export Color 1: Pearl Warm White Base Body
    luxury_holder_c1();
} else if (color_export == 2) {
    // Export Color 2: Obsidian Charcoal Black Features
    luxury_holder_c2();
} else if (color_export == 3) {
    // Export Color 3: Pastel Coral Peach / Pink Details
    luxury_holder_c3();
} else if (color_export == 4) {
    // Export Color 4: Champagne Gold Architectural Trim
    luxury_holder_c4();
} else if (mode == "holder") {
    // Default: Full 4-Color Luxury Assembly Preview
    luxury_holder_4color();
} else if (mode == "holder_monochrome") {
    // 100% Watertight Unified Monolithic Solid (Single Material Print)
    color(rose_gold_base) luxury_holder_monochrome();
} else if (mode == "bracket") {
    color(c4_gold) wall_bracket();
} else if (mode == "plate") {
    // 1-Plate Combo: 4-Color Holder + Wall Bracket
    luxury_holder_4color();
    color(c4_gold) translate([0, y_front + 24.0, 0]) wall_bracket();
} else if (mode == "standalone_toothbrush") {
    color(c1_body) standalone_toothbrush_rack("fluted");
} else if (mode == "assembled") {
    preview_assembled("fluted");
}
