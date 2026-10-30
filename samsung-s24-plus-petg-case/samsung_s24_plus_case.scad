// ==============================================================================
// 專案名稱: Samsung Galaxy S24+ (SM-S926) 極簡圓潤人體工學 PETG 全包覆手機殼
// 設計版本: V3.3 (真機 STEP CAD 校正 + 360° 強效防脫卡扣 + 全高微彎 0.20mm 極薄連體按鍵)
// 適用機型: Samsung Galaxy S24+ / S24 Plus (實測 CAD: 158.65 x 75.94 x 7.80 mm, R=8.33mm)
// 適用耗材: 專為 PETG 最佳化 (建議 0.4mm 噴嘴、0.16~0.20mm 層高、開啟薄壁偵測 / Arachne 最小牆寬 45%)
//
// V3.3 設計特點與實機回饋修正重點:
//   1. [移除內壁兩側凹槽與內底紋理] 內腔側壁與底板改為 100% 實心純平，消除結構削弱。
//   2. [100% 依據 S24+ 原廠級 STEP CAD (gs24_plus.step) 校正所有開孔與按鍵座標]
//      - 三鏡頭中心 X 校正為 +25.15mm，Y 校正為 +66.74 / +49.57 / +32.41mm；
//      - 閃光燈中心校正為 X = +11.75mm, Y = +58.16mm；
//      - 音量鍵組中心校正為 Y = +40.66mm；電源鍵中心校正為 Y = +15.87mm。
//   3. [解決安裝過鬆問題：收緊內腔公差 + 360° 全周向 1.10mm 深咬合防脫前唇]
//      - 內腔寬度收緊至 76.16mm (半寬 38.08mm)、長度 158.90mm (半長 79.45mm)、四角 R=8.44mm；
//      - 正面防脫卡扣內縮量提升至「長邊 1.10mm / 短邊與四角 0.95mm」，牢牢鎖住機身不掉出。
//   4. [V3.3 全新「全高微彎 0.20mm 極薄 S 型弧線連體按鍵」— 極致輕柔手感與一體式流線外觀]
//      - 取消 V3.0 醜陋的左右大破洞，恢復一體式全高 (4.50mm) 圓潤流線外觀（僅保留上下 0.85mm 水平細縫）；
//      - 將按鍵彈性壁厚度設定為 0.20mm 極薄微彎簧片，配合窄型橢圓頂針 (Y 軸寬僅 1.35~1.65mm)，
//        提供極致輕柔的按壓觸發手感！
// ==============================================================================

$fn = 72;

/* [視圖模式 / View Mode] */
// printable:       可直接切片列印之單件手機殼 (背板朝下平貼熱床 Z=0)
// assembled:       疊加真實 S24+ STEP 轉換模型 (或精準 CAD 裸機) 之完整裝配對位驗證
// cutaway_xz:      垂直截面 (X-Z 平面切過電源鍵中心，檢視 1.10mm 強效前唇卡扣與微彎薄壁按鍵截面)
// cutaway_xy:      水平截面 (X-Y 平面切在 Z=5.65mm 按鍵中心，檢視 0.52mm 微彎 S 型弧線薄壁與頂針)
view_mode = "printable"; // [printable, assembled, cutaway_xz, cutaway_xy]

/* [S24+ 實測 CAD 基準尺寸 / Verified CAD Specs from gs24_plus.step (mm)] */
phone_l          = 158.65; // 裸機實測長度 (Y = -79.325 ~ +79.325mm)
phone_w          = 75.94;  // 裸機實測寬度 (X = -37.97 ~ +37.97mm)
phone_t          = 7.80;   // 裸機含螢幕邊框厚度 (Z軸)
phone_corner_r   = 8.33;   // 裸機實測四角圓弧半徑 (圓心位於 X = ±29.64, Y = ±71.04mm)
phone_btn_ext    = 0.60;   // 裸機原生按鍵凸出機身邊框量 (原生按鍵頂面位於 X = 37.97 + 0.60 = 38.57mm)

/* [PETG 緊配公差與強效防脫卡扣參數 / Snug Fit & Retention Lip Specs (mm)] */
tol_x            = 0.11;   // 單邊 X 緊配間隙 (內腔半寬 = 38.08mm, 總寬 76.16mm, 緊密貼合不晃動)
tol_y            = 0.125;  // 單邊 Y 緊配間隙 (內腔半長 = 79.45mm, 總長 158.90mm)
tol_z            = 0.12;   // 垂直方向微裕度 (內腔直壁高度 cav_t = 7.92mm)

back_t           = 1.80;   // 背板厚度 (剛好齊平保護 S24+ 原廠凸出 1.5~1.6mm 之三鏡頭)
wall_t           = 1.75;   // 實心側壁厚度 (外壁半寬 = 39.83mm, 提供穩固夾持力)
front_lip_ramp_h = 1.05;   // 正面卡扣 45° 內縮斜坡高度 (100% 免支撐)
front_lip_rim_h  = 0.55;   // 正面卡扣頂部鎖定平緣高度
lip_undercut_side= 1.10;   // 左右長邊卡扣向內咬合量 (內緣達 X=36.98mm，實質扣住手機邊框達 0.99mm！)
lip_undercut_end = 0.95;   // 上下短邊與四角卡扣向內咬合量 (內緣達 Y=78.50mm，全周向牢牢鎖住手機！)

/* [後置三鏡頭與閃光燈精準 CAD 座標 / Verified Rear Camera & Flash Layout (mm)] */
// 依據 gs24_plus.step & gslatest_hardcase.step 實測數據：
cam_x            = 25.15;  // 三鏡頭中心 X 座標 (距中軸 25.15mm，距機身側緣 12.82mm)
cam1_y           = 66.74;  // 超廣角鏡頭中心 Y (距頂緣 12.59mm)
cam2_y           = 49.57;  // 主廣角鏡頭中心 Y (距頂緣 29.76mm, 節距 17.17mm)
cam3_y           = 32.41;  // 3x 長焦鏡頭中心 Y (距頂緣 46.92mm, 節距 17.16mm)
cam_hole_d       = 16.54;  // 鏡頭保護開孔直徑 (裸機鏡頭環 Ø14.61mm，單邊預留 0.96mm 精準裕度)

flash_x          = 11.75;  // 閃光燈中心 X 座標 (CAD 實測 11.65~11.81mm)
flash_y          = 58.16;  // 閃光燈中心 Y 座標 (CAD 實測 58.16mm，位於第 1 與第 2 顆鏡頭正中間)
flash_hole_d     = 7.10;   // 閃光燈開孔直徑 (裸機閃光燈 Ø4.74mm)

/* [V3.3 右側「全高微彎 0.20mm 極薄 S 型弧線連體按鍵」精準 CAD 座標 (mm)] */
// 依據 gs24_plus.step 實測：
//   - 原生音量鍵範圍 Y = +30.54 ~ +50.78mm (總長 20.24mm, 中心 +40.66mm)
//   - 原生電源鍵範圍 Y = +10.26 ~ +21.48mm (總長 11.22mm, 中心 +15.87mm)
//   - 音量+ 與 音量- 中央保留 Y = +39.86 ~ +41.46mm (寬 1.60mm) 實心分界立柱，隔離上下按壓！
vol_up_y         = 46.86;  // 音量+ 微彎按鍵中心 Y (跨度 +41.46 ~ +52.26mm，頂針精準對位原生音量+ 上半段)
vol_dn_y         = 34.46;  // 音量- 微彎按鍵中心 Y (跨度 +29.06 ~ +39.86mm，頂針精準對位原生音量- 下半段)
pwr_center_y     = 15.87;  // 電源鍵微彎按鍵中心 Y (跨度 +9.87 ~ +21.87mm，完全對齊原生電源鍵中心)

btn_span_v       = 10.80;  // 音量+ / 音量- 微彎按鍵總跨度 (全高連體無側邊破洞)
btn_span_p       = 12.00;  // 電源鍵微彎按鍵總跨度 (全高連體無側邊破洞)
btn_wall_t       = 0.20;   // 微彎彈性壁厚度 (0.20mm 極薄微彎壁厚！)
btn_arch_amp     = 0.72;   // 餘弦微彎外拱幅度 (中央向外微彎拱起 0.72mm，兼具圓潤手感與釋放拉緊應力)
btn_slot_h       = 0.85;   // 按鍵上下水平分離細縫高度 (僅上下各一條 0.85mm 細縫，外觀極簡乾淨)
btn_nub_tip_x    = 38.58;  // 內側觸發頂針端點 X 座標 (貼合裸機按鍵表面 38.57mm，0.01mm 零空行程一按即響)

// 推導內部腔體與外殼尺寸
cav_l            = phone_l + 2 * tol_y;                        // 158.90 mm (半長 79.45 mm)
cav_w            = phone_w + 2 * tol_x;                        // 76.16 mm  (半寬 38.08 mm)
cav_t            = phone_t + tol_z;                            // 7.92 mm
cav_r            = phone_corner_r + tol_x;                     // 8.44 mm

outer_l          = cav_l + 2 * wall_t;                         // 162.40 mm (半長 81.20 mm)
outer_w          = cav_w + 2 * wall_t;                         // 79.66 mm  (半寬 39.83 mm)
outer_r          = cav_r + wall_t;                             // 10.19 mm
total_h          = back_t + cav_t + front_lip_ramp_h + front_lip_rim_h; // 11.32 mm

// 按鍵垂直高度定位 (對齊 CAD 原生按鍵高度 Z = back_t + 3.85mm)
btn_z_mid        = back_t + 3.85;                              // 5.65 mm
btn_h            = 4.50;                                       // 全高微彎按鍵高度 (Z = 3.40 ~ 7.90mm)
btn_cutout_h     = btn_h + 2 * btn_slot_h;                     // 6.20 mm (上下各留 0.85mm 水平分離縫)

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

// 3D 多階圓弧過渡圓柱 (底部 45° 起步免支撐，向上平滑過渡為圓潤弧面不割手)
module smooth_fillet_cyl(r, h, r_bot=1.5, r_top=1.1) {
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

module rrect_smooth(w, l, h, r, r_bot=1.5, r_top=1.1) {
    hull() {
        for (sx = [-1, 1])
            for (sy = [-1, 1])
                translate([sx * (w/2 - r), sy * (l/2 - r), 0])
                    smooth_fillet_cyl(r, h, r_bot, r_top);
    }
}

// ==============================================================================
// 內部腔體與「360° 全周向強效防脫卡扣」模組 (完全移除內壁凹槽與內底紋路)
// ==============================================================================
module inner_phone_cavity() {
    lip_open_w = cav_w - 2 * lip_undercut_side; // 76.16 - 2.20 = 73.96 mm (比 75.94mm 裸機窄 1.98mm，單邊緊扣 0.99mm！)
    lip_open_l = cav_l - 2 * lip_undercut_end;  // 158.90 - 1.90 = 157.00 mm (比 158.65mm 裸機短 1.65mm，單端緊扣 0.825mm！)
    lip_open_r = max(2.0, cav_r - lip_undercut_end);

    union() {
        // 1. 主機身緊配容納腔 (Z = back_t 到 back_t + cav_t = 1.80 ~ 9.72mm)
        //    100% 純平內底與平滑內壁，底部帶 0.65mm 內倒角貼合 S24+ 背蓋圓弧邊緣
        translate([0, 0, back_t])
            hull() {
                linear_extrude(height = 0.01)
                    rrect2d(cav_w - 1.3, cav_l - 1.3, cav_r - 0.65);
                translate([0, 0, 0.65])
                    linear_extrude(height = cav_t - 0.65)
                        rrect2d(cav_w, cav_l, cav_r);
            }

        // 2. 頂部 45° 自支撐強效鎖定斜坡 (Z = 9.72 ~ 10.77mm)
        //    由內腔全寬 (76.16 x 158.90) 以 45° 向內收縮至鎖定口 (73.96 x 157.00)
        translate([0, 0, back_t + cav_t - 0.02])
            hull() {
                linear_extrude(height = 0.02)
                    rrect2d(cav_w, cav_l, cav_r);
                translate([0, 0, front_lip_ramp_h])
                    linear_extrude(height = 0.02)
                        rrect2d(lip_open_w, lip_open_l, lip_open_r);
            }

        // 3. 頂部防脫鎖定口與向外導引口 (Z = 10.77 ~ 11.35mm)
        //    上方帶微外擴導角，讓手機推入時可順暢撐開 PETG 側壁滑入卡扣下方
        translate([0, 0, back_t + cav_t + front_lip_ramp_h - 0.02])
            hull() {
                linear_extrude(height = 0.25)
                    rrect2d(lip_open_w, lip_open_l, lip_open_r);
                translate([0, 0, front_lip_rim_h + 0.15])
                    linear_extrude(height = 0.02)
                        rrect2d(lip_open_w + 0.80, lip_open_l + 0.80, lip_open_r + 0.40);
            }
    }
}

// ==============================================================================
// 後置三鏡頭與閃光燈精準斜切保護窗 (100% 依據 gs24_plus.step 座標)
// ==============================================================================
module camera_and_flash_cutouts() {
    // 1. 三鏡頭一體化跑道型視窗 (X = +25.15mm, Y = +32.41 ~ +66.74mm, 孔徑 16.54mm)
    hull() {
        translate([cam_x, cam1_y, -0.1])
            cylinder(d1 = cam_hole_d + 1.8, d2 = cam_hole_d, h = 1.0);
        translate([cam_x, cam3_y, -0.1])
            cylinder(d1 = cam_hole_d + 1.8, d2 = cam_hole_d, h = 1.0);
    }
    hull() {
        translate([cam_x, cam1_y, 0.8])
            cylinder(d = cam_hole_d, h = back_t + 1.0);
        translate([cam_x, cam3_y, 0.8])
            cylinder(d = cam_hole_d, h = back_t + 1.0);
    }

    // 2. LED 閃光燈獨立防眩光開孔 (X = +11.75mm, Y = +58.16mm, 孔徑 7.10mm)
    translate([flash_x, flash_y, -0.1]) {
        cylinder(d1 = flash_hole_d + 1.6, d2 = flash_hole_d, h = 1.0);
        translate([0, 0, 0.8])
            cylinder(d = flash_hole_d, h = back_t + 1.0);
    }
}

// ==============================================================================
// 頂部與底部開孔模組 (依據 gs24_plus.step 校正頂部麥克風與底部喇叭位置)
// ==============================================================================
module port_cutouts() {
    z_mid = back_t + 3.95;

    // 1. 底部正中央 USB Type-C 充電孔 (X = 0, 寬 12.8mm x 高 6.2mm)
    translate([0, -outer_l/2 - 1, z_mid])
        rotate([-90, 0, 0])
            support_free_slot(12.8, 6.2, wall_t + 4.0);

    // 2. 底部揚聲器與主麥克風開孔 (依據 STEP CAD: 喇叭位於 X = -12.4 ~ -20.1mm，即遠離按鍵側)
    translate([-16.2, -outer_l/2 - 1, z_mid])
        rotate([-90, 0, 0])
            support_free_slot(11.5, 4.2, wall_t + 4.0);

    // 底部副麥克風孔
    translate([10.5, -outer_l/2 - 1, z_mid])
        rotate([-90, 0, 0])
            support_free_slot(4.5, 3.6, wall_t + 4.0);

    // 3. 頂部雙降噪麥克風開孔 (依據 STEP CAD: 位於 X = +11.46 ~ +15.27mm，即靠近鏡頭/按鍵側！)
    translate([13.4, outer_l/2 + 1, z_mid])
        rotate([90, 0, 0])
            support_free_slot(8.2, 3.6, wall_t + 4.0);
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
// V3.3 核心升級：「全高微彎 0.20mm 極薄 S 型弧線連體按鍵 (Micro-Curved 0.20mm Thin Button)」
// ==============================================================================
// 結構與力學原理解析：
//   1. [外觀一體無破洞]：按鍵採全高連體設計 (高 4.50mm)，完全填滿視窗左右跨度，僅在按鍵上下各留一條
//      0.85mm 乾淨水平分離細縫，徹底消除舊版左右兩側醜陋的大方孔！
//   2. [下修壁厚至 0.20mm]：將彈性壁厚設定為 0.20mm 極薄微彎簧片，阻力極小、輕觸即發！
//   3. [餘弦微彎 S 型外拱曲線 + 窄型橢圓頂針]：
//      在 X-Y 平面採用餘弦微彎曲線 x(u) = A * (1 + cos(π*u)) / 2（兩端與側壁平滑相切，中央向外微彎拱起 0.72mm），
//      並將中央頂針在 Y 軸方向的寬度收窄至 1.35~1.65mm，讓 >85% 跨度皆為純粹 0.20mm 極薄彈性微彎板簧！

// 餘弦微彎曲線函數：u 從 -1 到 +1，回傳 0 ~ btn_arch_amp 之平滑微彎外凸量
function btn_arch_offset(u) =
    (abs(u) >= 1.0) ? 0.0 : btn_arch_amp * (1.0 + cos(180.0 * u)) / 2.0;

// 單一截面 0.20mm 極薄微彎切片 (維持全高均勻 0.20mm 壁厚，內壁純平垂直)
module btn_slice_3d(x_in, x_out, y_pos, slice_w, h) {
    bevel_z = 0.35; // 外緣上下微圓潤過渡高度
    bevel_x = 0.02; // 維持近乎全高完整 0.20mm 厚度，避免頂底層過薄
    translate([0, y_pos, btn_z_mid])
        hull() {
            // 內壁：全高純垂直平面 (消除 C 型槽強化效應，保持極致柔軟度)
            translate([x_in + 0.01, 0, 0])
                cube([0.02, slice_w, h], center = true);
            // 外壁中段：0.20mm 完整厚度平滑頂面
            translate([x_out - 0.01, 0, 0])
                cube([0.02, slice_w, h - 2 * bevel_z], center = true);
            // 外壁上下微收圓潤邊緣
            translate([x_out - bevel_x, 0, 0])
                cube([0.02, slice_w, h], center = true);
        }
}

// 1. 側壁按鍵區挖空槽 (僅在組裝上可看見上下 0.85mm 水平細縫，內側完全掏空供微彎薄壁回彈)
module button_window_cutout(center_y, span_len) {
    // (A) 貫穿側壁的按鍵槽 + 頂部 45° 免支撐斜屋頂
    translate([outer_w/2, center_y, btn_z_mid])
        hull() {
            cube([wall_t * 3, span_len, btn_cutout_h - 0.50], center = true);
            translate([0, 0, btn_cutout_h/2])
                cube([wall_t * 3, span_len - 0.80, 0.04], center = true);
        }

    // (B) 內腔邊緣擴口避空槽 (確保裸機 +0.60mm 凸出按鍵周圍完全不摩擦側壁)
    translate([cav_w/2, center_y, btn_z_mid])
        cube([1.60, span_len + 0.60, btn_cutout_h + 0.10], center = true);
}

// 2. 全高微彎 0.38mm 超薄 S 型弧線連體按鍵 + 窄型精準觸發頂針
module button_compliant_assembly(center_y, span_len, has_dot=false) {
    steps = 32; // 沿 Y 軸高解析度微彎分段數
    ext_u = 1.08; // 兩端延伸 8% 深入實心側壁錨固，確保左右無任何破洞或縫隙

    union() {
        // (A) 沿 Y 軸連續掃掠之「0.38mm 微彎 S 型餘弦超薄板簧」
        for (i = [0 : steps - 1]) {
            u1 = -ext_u + (2 * ext_u * i) / steps;
            u2 = -ext_u + (2 * ext_u * (i + 1)) / steps;
            y1 = center_y + u1 * (span_len / 2);
            y2 = center_y + u2 * (span_len / 2);

            x_out1 = outer_w/2 + btn_arch_offset(u1);
            x_in1  = x_out1 - btn_wall_t;
            x_out2 = outer_w/2 + btn_arch_offset(u2);
            x_in2  = x_out2 - btn_wall_t;

            hull() {
                btn_slice_3d(x_in1, x_out1, y1, 0.03, btn_h);
                btn_slice_3d(x_in2, x_out2, y2, 0.03, btn_h);
            }
        }

        // (B) 電源鍵專屬光滑球面盲操微凸點
        if (has_dot) {
            translate([outer_w/2 + btn_arch_amp, center_y, btn_z_mid])
                scale([0.28, 1.0, 1.0])
                    sphere(r = 0.95, $fn = 32);
        }

        // (C) 內側窄型精準觸發頂針 (Y 軸寬僅 1.35~1.65mm，不佔用微彎薄壁彈性變形跨度！)
        center_x_in = outer_w/2 + btn_arch_amp - btn_wall_t; // 39.83 + 0.72 - 0.38 = 40.17 mm
        nub_len     = center_x_in - btn_nub_tip_x + 0.08;
        translate([btn_nub_tip_x, center_y, btn_z_mid])
            hull() {
                translate([0.03, 0, 0])
                    scale([1.0, 0.60, 1.0])
                        rotate([0, 90, 0])
                            cylinder(d = 2.25, h = 0.03, $fn = 28);
                translate([nub_len, 0, 0])
                    scale([1.0, 0.62, 1.0])
                        rotate([0, 90, 0])
                            cylinder(d = 2.65, h = 0.03, $fn = 28);
            }
    }
}

// ==============================================================================
// 手機殼完整主體組裝模組 (Main Phone Case Solid)
// ==============================================================================
module s24_plus_petg_case() {
    union() {
        difference() {
            // 1. 外部圓潤主殼體 (100% 純平光滑外背板 + 多階圓弧過渡邊框)
            rrect_smooth(outer_w, outer_l, total_h, outer_r, 1.5, 1.1);

            // 2. 內部緊配腔體 + 360° 全周向 1.10mm 強效防脫卡扣前唇
            inner_phone_cavity();

            // 3. 依據 STEP CAD 校正之後置三鏡頭與閃光燈開窗
            camera_and_flash_cutouts();

            // 4. 依據 STEP CAD 校正之頂部麥克風與底部充電/喇叭開孔
            port_cutouts();

            // 5. 切出 3 顆側按鍵之內側避空與上下 0.85mm 分離槽
            button_window_cutout(vol_up_y, btn_span_v);
            button_window_cutout(vol_dn_y, btn_span_v);
            button_window_cutout(pwr_center_y, btn_span_p);
        }

        // 6. 置入 3 組「全高微彎 0.38mm 超薄 S 型弧線連體按鍵 + 窄型觸發頂針」
        button_compliant_assembly(vol_up_y, btn_span_v, false);
        button_compliant_assembly(vol_dn_y, btn_span_v, false);
        button_compliant_assembly(pwr_center_y, btn_span_p, true);
    }
}

// ==============================================================================
// S24+ 精準 CAD 參考裸機模型 (100% 對應 gs24_plus.step 尺寸與鏡頭/按鍵座標)
// ==============================================================================
module dummy_s24_plus_phone() {
    translate([0, 0, back_t + tol_z/2]) {
        // 機身主體 (75.94 x 158.65 x 7.80mm, R=8.33mm)
        color("#2c3038")
            rrect_smooth(phone_w, phone_l, phone_t, phone_corner_r, 0.55, 0.55);
        // 螢幕面板
        color("#12161f")
            translate([0, 0, phone_t - 0.05])
                linear_extrude(height = 0.10)
                    rrect2d(phone_w - 2.6, phone_l - 2.6, phone_corner_r - 1.3);
        // 後置三鏡頭環 (X = +25.15, Y = +66.74 / +49.57 / +32.41, Ø14.61mm)
        color("#d0d5dd")
            for (cy = [cam1_y, cam2_y, cam3_y])
                translate([cam_x, cy, -1.55])
                    cylinder(d = 14.61, h = 1.60);
        color("#0b0e14")
            for (cy = [cam1_y, cam2_y, cam3_y])
                translate([cam_x, cy, -1.60])
                    cylinder(d = 11.0, h = 0.2);
        // LED 閃光燈 (X = +11.75, Y = +58.16, Ø4.74mm)
        color("#f5e6b3")
            translate([flash_x, flash_y, -0.25])
                cylinder(d = 4.74, h = 0.30);
        // 右側原生音量鍵 (Y = +30.54 ~ +50.78) 與電源鍵 (Y = +10.26 ~ +21.48)，外頂面位於 X = 38.57mm
        color("#f6ad55") {
            translate([phone_w/2, 40.66, 3.85])
                cube([phone_btn_ext * 2, 20.24, 2.20], center = true);
            translate([phone_w/2, 15.87, 3.85])
                cube([phone_btn_ext * 2, 11.22, 2.20], center = true);
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
            cube([70, 90 + pwr_center_y - 1.8, 30]);
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
        translate([-50, -90, -10])
            cube([100, 180, 10 + btn_z_mid - 1.5]);
    }
}
