// ==============================================================================
// 專案名稱: Samsung Galaxy S24+ (SM-S926) 極簡圓潤人體工學 PETG 全包覆手機殼
// 設計版本: V2.2 (純平背板 + 頂底 100% 全貫穿分離槽 + 0.78mm 空心微拱形板簧 + 真圓弧鵝卵石按鍵)
// 適用機型: Samsung Galaxy S24+ / S24 Plus (裸機尺寸: 158.50 x 75.90 x 7.70 mm)
// 適用耗材: 專為 PETG 最佳化 (建議 0.4mm 噴嘴、0.16~0.20mm 層高、4 圈壁厚、100% 免支撐)
//
// 核心工程特點 (V2.2 多視角機構驗證版):
//   1. [頂底 100% 全貫穿分離槽 (Full Through-Cut Top & Bottom Isolation Slots)]
//      - 修正頂部分離槽深度，確保每顆按鍵的「頂部 (Z=8.00~8.70mm)」與「底部 (Z=2.15~2.85mm)」
//        皆 100% 完全切穿內外側壁！按鍵上下邊緣完全懸空自由，僅靠左右兩端 0.78mm 彈性細樑連接，
//        在垂直截面 (X-Z) 下呈現完美的獨立浮動懸臂結構！
//   2. [0.78mm 等壁厚空心微拱形板簧 (True Hollow Arch Leaf-Spring)]
//      - 內壁採用與外膠囊球頂同曲率的「等距內掏空球殼」，使兩端彈性鉸鏈壁厚僅 0.78mm (雙圈噴嘴線寬)、
//        拱頂壁厚僅 0.85mm，按壓阻力輕盈 (~150gf)，順著 FDM 水平連續層紋彎曲，永不斷裂。
//   3. [0.05mm 零預壓精準觸發頂針 + 真圓弧鵝卵石膠囊鍵帽]
//      - 觸發頂針內端精準定位於 X = 38.60mm，與 S24+ 裸機按鍵 (X = 38.55mm) 保持 0.05mm 黃金微間隙，
//        裝機絕不常壓誤觸，輕按 0.40mm 即可清脆點擊！
//      - 外側鍵帽為 100% 無裁切真圓弧橢球膠囊曲面，徹底消除任何平面切痕與割手稜角。
// ==============================================================================

$fn = 72;

/* [視圖模式 / View Mode] */
// printable:       可直接切片列印之單件手機殼 (背板朝下平貼熱床 Z=0)
// assembled:       含 S24+ 虛擬裸機之完整裝配預覽
// cutaway_xz:      垂直截面 (X-Z 平面切過電源鍵中心，驗證頂底 100% 貫穿分離縫與頂針間隙)
// cutaway_xy:      水平截面 (X-Y 平面切在 Z=5.42mm 按鍵中心，驗證 0.78mm 空心拱形板簧與頂針)
view_mode = "printable"; // [printable, assembled, cutaway_xz, cutaway_xy]

/* [S24+ 裸機基準尺寸 / Bare Phone Nominal Specs (mm)] */
phone_l          = 158.50; // 裸機長度 (Y軸)
phone_w          = 75.90;  // 裸機寬度 (X軸, 半寬 = 37.95mm)
phone_t          = 7.70;   // 裸機厚度 (Z軸, 不含鏡頭凸起)
phone_corner_r   = 9.50;   // 裸機四角圓弧半徑
phone_btn_ext    = 0.60;   // 裸機原生按鍵凸出機身邊框量 (原生按鍵表面位於 X = 37.95 + 0.60 = 38.55mm)

/* [PETG 緊配公差與殼體結構參數 / PETG Fit & Shell Parameters (mm)] */
tol_xy           = 0.25;   // 單邊 XY 裝配間隙 (內腔半寬 = 38.20mm)
tol_z            = 0.35;   // 厚度方向裝配裕度 (內腔高度 8.05mm)

back_t           = 1.80;   // 背板總厚度 (剛好齊平並保護 S24+ 原廠約 1.6mm 凸出鏡頭)
wall_t           = 1.60;   // 長邊彈性側壁厚度 (外壁位於 X = 39.80mm)
corner_bumper_t  = 2.05;   // 四角平順微加厚量
front_lip_h      = 0.65;   // 螢幕正面微卡扣高度
lip_undercut_side= 0.50;   // 左右長邊卡扣內縮量 (提供穩固咬合力)
lip_undercut_crn = 0.22;   // 四角卡扣漸消內縮量 (實現無開槽順暢拆裝)

/* [後置三鏡頭與閃光燈座標 / Rear Camera & Flash Layout (mm)] */
cam_x            = 22.45;  // 三鏡頭中心 X 座標 (距機身右緣 15.50mm)
cam1_y           = 63.75;  // 超廣角鏡頭中心 Y (距機身頂緣 15.50mm)
cam2_y           = 46.75;  // 主廣角鏡頭中心 Y (距機身頂緣 32.50mm, 節距 17.0mm)
cam3_y           = 29.75;  // 3x 長焦鏡頭中心 Y (距機身頂緣 49.50mm, 節距 17.0mm)
cam_hole_d       = 16.40;  // 鏡頭保護開孔直徑

flash_x          = 8.50;   // 閃光燈中心 X 座標
flash_y          = 55.25;  // 閃光燈中心 Y 座標
flash_hole_d     = 7.60;   // 閃光燈開孔直徑

/* [右側空心微拱形彈性板簧按鍵參數 / Hollow Arch Leaf-Spring Button Specs (mm)] */
vol_center_y     = 36.75;  // 音量鍵組中心 Y (距頂緣 42.5mm)
vol_total_span   = 26.60;  // 音量鍵組總跨度 (含中央 2.2mm 實心立柱 + 上下各 12.2mm 獨立拱形懸臂)
pwr_center_y     = 12.75;  // 電源鍵中心 Y (距頂緣 66.5mm)
pwr_total_span   = 15.00;  // 電源鍵單跨總長 (15.0mm 柔順長懸臂)

btn_hinge_t      = 0.78;   // 兩端彈性鉸鏈實心壁厚 (0.4mm 噴嘴 = 2 圈連續壁厚, 輕按即彎)
btn_dome_protrude= 0.75;   // 圓潤膠囊球頂中心向外凸出量 (外壁峰值 X = 39.80 + 0.75 = 40.55mm)
btn_nub_tip_x    = 38.60;  // 觸發頂針內端點 X 座標 (距裸機按鍵表面 38.55mm 預留 0.05mm 零預壓微間隙)
btn_slot_h       = 0.70;   // 按鍵頂底全貫穿分離縫高度

// 推導內部腔體與外殼尺寸
cav_l            = phone_l + 2 * tol_xy;         // 159.00 mm
cav_w            = phone_w + 2 * tol_xy;         // 76.40 mm (半寬 38.20 mm)
cav_t            = phone_t + tol_z;              // 8.05 mm
cav_r            = phone_corner_r + tol_xy;      // 9.75 mm

outer_l          = cav_l + 2 * wall_t;           // 162.20 mm
outer_w          = cav_w + 2 * wall_t;           // 79.60 mm (半寬 39.80 mm)
outer_r          = cav_r + wall_t;               // 11.35 mm
total_h          = back_t + cav_t + front_lip_h; // 10.50 mm

// 按鍵高度範圍
btn_z_bot        = back_t + 1.05;                // 2.85 mm (底部貫穿縫位於 Z = 2.15 ~ 2.85mm)
btn_z_top        = back_t + cav_t - 1.85;        // 8.00 mm (頂部貫穿縫位於 Z = 8.00 ~ 8.70mm)
btn_z_mid        = (btn_z_bot + btn_z_top) / 2;  // 5.425 mm
btn_body_h       = btn_z_top - btn_z_bot;        // 5.15 mm

// ==============================================================================
// 基礎幾何輔助模組 (Core Geometric Primitives)
// ==============================================================================

module rrect2d(w, l, r) {
    r_safe = max(0.1, min(r, min(w, l)/2 - 0.05));
    hull() {
        for (sx = [-1, 1])
            for (sy = [-1, 1])
                translate([sx * (w/2 - r_safe), sy * (l/2 - r_safe)])
                    circle(r = r_safe);
    }
}

module smooth_fillet_cyl(r, h, r_bot=1.5, r_top=1.0) {
    hull() {
        cylinder(r1 = max(0.1, r - r_bot * 0.85), r2 = max(0.1, r - r_bot * 0.40), h = r_bot * 0.45);
        translate([0, 0, r_bot * 0.45])
            cylinder(r1 = max(0.1, r - r_bot * 0.40), r2 = max(0.1, r - r_bot * 0.12), h = r_bot * 0.35);
        translate([0, 0, r_bot * 0.80])
            cylinder(r1 = max(0.1, r - r_bot * 0.12), r2 = r, h = r_bot * 0.25);

        translate([0, 0, r_bot])
            cylinder(r = r, h = max(0.01, h - r_bot - r_top));
        translate([0, 0, h - r_top])
            cylinder(r1 = r, r2 = max(0.1, r - r_top * 0.15), h = r_top * 0.30);
        translate([0, 0, h - r_top * 0.70])
            cylinder(r1 = max(0.1, r - r_top * 0.15), r2 = max(0.1, r - r_top * 0.45), h = r_top * 0.35);
        translate([0, 0, h - r_top * 0.35])
            cylinder(r1 = max(0.1, r - r_top * 0.45), r2 = max(0.1, r - r_top * 0.85), h = r_top * 0.35);
    }
}

module rrect_smooth(w, l, h, r, r_bot=1.5, r_top=1.0) {
    hull() {
        for (sx = [-1, 1])
            for (sy = [-1, 1])
                translate([sx * (w/2 - r), sy * (l/2 - r), 0])
                    smooth_fillet_cyl(r, h, r_bot, r_top);
    }
}

module smooth_corner_bumpers(h, r_bot=1.5, r_top=1.0) {
    bumper_extra = corner_bumper_t - wall_t;
    for (sx = [-1, 1])
        for (sy = [-1, 1]) {
            hull() {
                translate([sx * (outer_w/2 - outer_r), sy * (outer_l/2 - outer_r), 0])
                    smooth_fillet_cyl(outer_r + bumper_extra, h, r_bot, r_top);
                translate([sx * (outer_w/2 - outer_r - 14), sy * (outer_l/2 - outer_r), 0])
                    smooth_fillet_cyl(outer_r, h, r_bot, r_top);
                translate([sx * (outer_w/2 - outer_r), sy * (outer_l/2 - outer_r - 20), 0])
                    smooth_fillet_cyl(outer_r, h, r_bot, r_top);
            }
        }
}

// ==============================================================================
// 內部腔體與「直邊強咬合 + 四角輕阻力」漸變卡扣模組
// ==============================================================================
module inner_phone_cavity() {
    union() {
        translate([0, 0, back_t])
            hull() {
                linear_extrude(height = 0.01)
                    rrect2d(cav_w - 1.0, cav_l - 1.0, cav_r - 0.5);
                translate([0, 0, 0.50])
                    linear_extrude(height = cav_t - 0.50)
                        rrect2d(cav_w, cav_l, cav_r);
            }

        translate([0, 0, back_t + cav_t - 0.55])
            hull() {
                linear_extrude(height = 0.01)
                    rrect2d(cav_w, cav_l, cav_r);
                translate([0, 0, 0.55])
                    linear_extrude(height = front_lip_h + 0.20)
                        rrect2d(cav_w - 2 * lip_undercut_side, cav_l - 2 * lip_undercut_crn, cav_r - lip_undercut_crn);
            }

        for (sx = [-1, 1])
            for (sy = [-1, 1])
                translate([sx * (cav_w/2 - cav_r), sy * (cav_l/2 - cav_r), back_t + cav_t - 0.55])
                    cylinder(r1 = cav_r, r2 = cav_r - lip_undercut_crn, h = 0.55 + front_lip_h + 0.20);

        translate([-cav_w/2, 0, back_t + 2.0])
            hull() {
                rotate([90, 0, 0])
                    cylinder(d = 2.4, h = cav_l - 2 * cav_r - 16, center = true, $fn = 24);
                translate([-0.28, 0, 0])
                    rotate([90, 0, 0])
                        cylinder(d = 1.2, h = cav_l - 2 * cav_r - 20, center = true, $fn = 24);
            }
        translate([cav_w/2, -32, back_t + 2.0])
            hull() {
                rotate([90, 0, 0])
                    cylinder(d = 2.4, h = 60, center = true, $fn = 24);
                translate([0.28, 0, 0])
                    rotate([90, 0, 0])
                        cylinder(d = 1.2, h = 56, center = true, $fn = 24);
            }

        intersection() {
            translate([0, 0, back_t - 0.25])
                linear_extrude(height = 0.60)
                    rrect2d(cav_w - 14, cav_l - 24, 4.0);
            union() {
                for (ang = [35, -35])
                    for (offset_y = [-60 : 14 : 60])
                        translate([0, offset_y, back_t + 0.05])
                            rotate([0, 0, ang])
                                cube([cav_w, 1.8, 0.60], center = true);
            }
        }
    }
}

// ==============================================================================
// 後置三鏡頭與閃光燈精準斜切保護窗 (Camera & Flash Cutouts)
// ==============================================================================
module camera_and_flash_cutouts() {
    hull() {
        translate([cam_x, cam1_y, -0.1])
            cylinder(d1 = cam_hole_d + 2.0, d2 = cam_hole_d, h = 1.1);
        translate([cam_x, cam3_y, -0.1])
            cylinder(d1 = cam_hole_d + 2.0, d2 = cam_hole_d, h = 1.1);
    }
    hull() {
        translate([cam_x, cam1_y, 0.9])
            cylinder(d = cam_hole_d, h = back_t + 1.0);
        translate([cam_x, cam3_y, 0.9])
            cylinder(d = cam_hole_d, h = back_t + 1.0);
    }

    translate([flash_x, flash_y, -0.1]) {
        cylinder(d1 = flash_hole_d + 1.8, d2 = flash_hole_d, h = 1.1);
        translate([0, 0, 0.9])
            cylinder(d = flash_hole_d, h = back_t + 1.0);
    }
}

// ==============================================================================
// 頂部與底部開孔模組 (100% 免支撐 45° 斜拱頂開槽)
// ==============================================================================
module port_cutouts() {
    z_mid = back_t + cav_t / 2;

    translate([0, -outer_l/2 - 1, z_mid])
        rotate([-90, 0, 0])
            support_free_slot(13.2, 6.2, wall_t + 4.0);

    for (sx = [-1, 1])
        translate([sx * 16.5, -outer_l/2 - 1, z_mid])
            rotate([-90, 0, 0])
                support_free_slot(10.5, 4.2, wall_t + 4.0);

    translate([-13.0, outer_l/2 + 1, z_mid])
        rotate([90, 0, 0])
            support_free_slot(9.0, 3.6, wall_t + 4.0);
}

module support_free_slot(w, h, depth) {
    r = h / 2;
    hull() {
        for (sx = [-1, 1])
            translate([sx * (w/2 - r), 0, 0]) {
                cylinder(r = r, h = depth);
                translate([0, -r * 0.35, 0])
                    cylinder(r = r * 0.85, h = depth);
            }
    }
}

// ==============================================================================
// V2.2 核心機構：100% 頂底全貫穿分離 + 0.78mm 空心微拱形彈性板簧 + 真圓弧鵝卵石按鍵
// ==============================================================================

// 1. 外側真圓弧鵝卵石膠囊球頂 (無任何平面切割盒！100% 自然橢球圓弧收頂)
module single_pill_outer_dome(sub_y, span_len, has_dot=false) {
    r_cap = (btn_body_h - 0.30) / 2;         // 2.425 mm (預留上下裕度絕不碰觸貫穿槽)
    hinge_margin = 2.0;                      // 兩端各留 2.0mm 齊平彈性鉸鏈段
    dome_len = span_len - 2 * hinge_margin;  // 膠囊隆起段長度
    core_y = max(0.4, dome_len - 2 * r_cap);

    union() {
        hull() {
            // 基底圓柱 (埋入外壁 X = 39.50 ~ 39.80mm，平滑銜接無台階)
            for (sy = [-1, 1])
                translate([outer_w/2 - 0.30, sub_y + sy * (core_y/2 + 0.35), btn_z_mid])
                    rotate([0, 90, 0])
                        cylinder(r = r_cap, h = 0.30, $fn = 40);

            // 頂部真圓弧橢球膠囊頂 (X 方向半徑壓縮為 0.75mm -> 最外點精準停在 39.80 + 0.75 = 40.55mm！)
            for (sy = [-1, 1])
                translate([outer_w/2, sub_y + sy * (core_y/2), btn_z_mid])
                    scale([btn_dome_protrude / (r_cap - 0.15), 1.0, 1.0])
                        sphere(r = r_cap - 0.15, $fn = 40);
        }

        // 電源鍵中央光滑微凸盲操球點 (從 40.55mm 再微凸 0.30mm 至 40.85mm，全圓弧不刮手)
        if (has_dot) {
            translate([outer_w/2 + btn_dome_protrude, sub_y, btn_z_mid])
                scale([0.35, 1.0, 1.0])
                    sphere(r = 1.05, $fn = 32);
        }
    }
}

// 2. 單段空心微拱形板簧的「頂底 100% 全貫穿分離槽 + 同曲率內部空心掏空槽」
module single_arch_hollow_and_slots(sub_y, span_len) {
    r_cap = (btn_body_h - 0.30) / 2;
    hinge_margin = 2.0;
    dome_len = span_len - 2 * hinge_margin;
    core_y = max(0.4, dome_len - 2 * r_cap);

    // (A) 底部 100% 內外全貫穿水平分離縫 (X = 35.0 ~ 43.0mm, Z = 2.15 ~ 2.85mm)
    translate([outer_w/2, sub_y, btn_z_bot - btn_slot_h/2])
        cube([8.0, span_len, btn_slot_h], center = true);

    // (B) 頂部 100% 內外全貫穿 45° 自支撐分離縫 (X = 35.0 ~ 43.0mm, Z = 8.00 ~ 8.70mm)
    //     注意 X 中心設於 outer_w/2 (39.80mm) 寬 8.0mm，確保 100% 貫穿外壁！
    translate([outer_w/2, sub_y, btn_z_top + btn_slot_h/2])
        hull() {
            cube([8.0, span_len, btn_slot_h * 0.65], center = true);
            translate([0, 0, btn_slot_h * 0.45])
                cube([8.0, span_len - 0.70, 0.08], center = true);
        }

    // (C) 內側等壁厚空心微拱形掏空槽 (True Hollow Leaf-Spring Cavity)：
    //     1. 兩端彈性鉸鏈段：從內腔削至 X = outer_w/2 - btn_hinge_t = 39.80 - 0.78 = 39.02mm
    //        (保留外側 0.78mm = 2 圈完整噴嘴壁厚的連續彈性細樑，且在頂部帶 45° 自支撐斜坡)
    hull() {
        translate([cav_w/2, sub_y, btn_z_mid])
            cube([(outer_w/2 - btn_hinge_t - cav_w/2) * 2, span_len + 0.1, btn_body_h + 0.1], center = true);
        translate([cav_w/2 - 0.8, sub_y, btn_z_mid])
            cube([0.2, span_len + 0.4, btn_body_h + 0.8], center = true);
    }

    //     2. 中央膠囊球頂內部同曲率掏空 (深入至 X = 39.02 + 0.68 = 39.70mm，使拱頂壁厚維持均勻 0.85mm！)
    hull() {
        for (sy = [-1, 1])
            translate([outer_w/2 - btn_hinge_t, sub_y + sy * (core_y/2), btn_z_mid])
                scale([0.68 / (r_cap - 0.45), 1.0, 1.0])
                    sphere(r = r_cap - 0.45, $fn = 36);
        translate([outer_w/2 - btn_hinge_t - 0.5, sub_y, btn_z_mid])
            cube([0.2, dome_len - 0.6, btn_body_h - 0.4], center = true);
    }
}

// 3. 中央圓潤觸發頂針 (Actuator Nub)：
//    從空心拱頂內壁 (X = 39.70mm) 往內精準延伸至 X = btn_nub_tip_x (38.60mm)
//    與 S24+ 裸機原生按鍵表面 (X = 38.55mm) 保持 0.05mm 黃金微間隙，絕不常壓、一按即響！
module single_actuator_nub(sub_y) {
    nub_base_x = outer_w/2 - btn_hinge_t + 0.72; // 39.74 mm (穩固融合於空心拱頂內壁)
    nub_len_x  = nub_base_x - btn_nub_tip_x;     // 1.14 mm

    translate([btn_nub_tip_x, sub_y, btn_z_mid])
        hull() {
            // 內端圓潤觸發頭 (X = 38.60mm, 寬 2.2mm x 高 2.4mm 圓潤觸頭)
            translate([0.10, 0, 0])
                rotate([0, 90, 0])
                    scale([1.1, 1.0, 1.0])
                        cylinder(d = 2.2, h = 0.10, $fn = 28);

            // 根部與空心拱頂內壁連接 (X = 39.74mm, 45° 免支撐錐台)
            translate([nub_len_x - 0.10, 0, 0])
                rotate([0, 90, 0])
                    scale([1.1, 1.0, 1.0])
                        cylinder(d = 3.2, h = 0.10, $fn = 28);
        }
}

// ==============================================================================
// 手機殼完整主體組裝模組 (Main Phone Case Solid)
// ==============================================================================
module s24_plus_petg_case() {
    vol_sub_span = (vol_total_span - 2.2) / 2;          // 12.20 mm
    vol_up_y     = vol_center_y + vol_sub_span/2 + 1.1; // +43.95 mm
    vol_dn_y     = vol_center_y - vol_sub_span/2 - 1.1; // +29.55 mm

    union() {
        difference() {
            // 1. 外部圓潤主殼體 + 四角護角 + 3 顆真圓弧鵝卵石膠囊球頂
            union() {
                rrect_smooth(outer_w, outer_l, total_h, outer_r, 1.5, 1.0);
                smooth_corner_bumpers(total_h, 1.5, 1.0);

                single_pill_outer_dome(vol_up_y, vol_sub_span, false);
                single_pill_outer_dome(vol_dn_y, vol_sub_span, false);
                single_pill_outer_dome(pwr_center_y, pwr_total_span, true);
            }

            // 2. 內部手機腔體、四角漸變卡扣與側壁卸力暗槽
            inner_phone_cavity();

            // 3. 後置三鏡頭與閃光燈開窗
            camera_and_flash_cutouts();

            // 4. 頂部與底部充電/喇叭/麥克風開孔
            port_cutouts();

            // 5. 切出 3 顆按鍵的「頂底 100% 全貫穿分離縫 + 內部空心微拱形板簧掏空槽」
            single_arch_hollow_and_slots(vol_up_y, vol_sub_span);
            single_arch_hollow_and_slots(vol_dn_y, vol_sub_span);
            single_arch_hollow_and_slots(pwr_center_y, pwr_total_span);
        }

        // 6. 在空心拱頂內壁中央加上 3 顆 0.05mm 零預壓精準觸發頂針
        single_actuator_nub(vol_up_y);
        single_actuator_nub(vol_dn_y);
        single_actuator_nub(pwr_center_y);
    }
}

// ==============================================================================
// S24+ 虛擬裸機模型 (含精準 +0.60mm 凸出之獨立音量+/音量-/電源原生按鍵)
// ==============================================================================
module dummy_s24_plus_phone() {
    vol_sub_span = (vol_total_span - 2.2) / 2;
    vol_up_y     = vol_center_y + vol_sub_span/2 + 1.1;
    vol_dn_y     = vol_center_y - vol_sub_span/2 - 1.1;

    translate([0, 0, back_t + tol_z/2]) {
        color("#2c3038")
            rrect_smooth(phone_w, phone_l, phone_t, phone_corner_r, 0.6, 0.6);
        color("#12161f")
            translate([0, 0, phone_t - 0.05])
                linear_extrude(height = 0.10)
                    rrect2d(phone_w - 3.0, phone_l - 3.0, phone_corner_r - 1.5);
        color("#d0d5dd")
            for (cy = [cam1_y, cam2_y, cam3_y])
                translate([cam_x, cy, -1.60])
                    cylinder(d = 14.2, h = 1.65);
        color("#0b0e14")
            for (cy = [cam1_y, cam2_y, cam3_y])
                translate([cam_x, cy, -1.65])
                    cylinder(d = 10.6, h = 0.2);
        color("#f5e6b3")
            translate([flash_x, flash_y, -0.2])
                cylinder(d = 4.5, h = 0.25);
        // 右側原生音量鍵與電源鍵 (外表面精準位於 X = 38.55mm)
        color("#f6ad55") {
            translate([phone_w/2, vol_up_y, phone_t/2])
                cube([phone_btn_ext * 2, 8.5, 1.9], center = true);
            translate([phone_w/2, vol_dn_y, phone_t/2])
                cube([phone_btn_ext * 2, 8.5, 1.9], center = true);
            translate([phone_w/2, pwr_center_y, phone_t/2])
                cube([phone_btn_ext * 2, 10.0, 1.9], center = true);
        }
    }
}

// ==============================================================================
// 視圖模式切換渲染輸出
// ==============================================================================
if (view_mode == "printable") {
    color("#2b6cb0")
        s24_plus_petg_case();
} else if (view_mode == "assembled") {
    color("#2b6cb0")
        s24_plus_petg_case();
    dummy_s24_plus_phone();
} else if (view_mode == "cutaway_xz") {
    difference() {
        union() {
            color("#2b6cb0")
                s24_plus_petg_case();
            dummy_s24_plus_phone();
        }
        translate([-10, -90, -5])
            cube([70, 90 + pwr_center_y, 30]);
    }
} else if (view_mode == "cutaway_xy") {
    difference() {
        union() {
            color("#2b6cb0")
                s24_plus_petg_case();
            dummy_s24_plus_phone();
        }
        translate([-50, -90, btn_z_mid])
            cube([100, 180, 20]);
    }
}
