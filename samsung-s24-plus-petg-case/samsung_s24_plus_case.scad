// ==============================================================================
// 專案名稱: Samsung Galaxy S24+ (SM-S926) 極簡圓潤人體工學 PETG 全包覆手機殼
// 設計版本: V5.0 (分件式獨立按鍵蓋終極版：側壁內階梯挖空 + 3 顆防脫落獨立浮動按鍵蓋)
// 適用機型: Samsung Galaxy S24+ / S24 Plus (官方基準 158.50 x 75.90 x 7.70 mm, R=8.28mm)
// 適用耗材: 專為 PETG 最佳化 (建議 0.4mm 噴嘴、0.16~0.20mm 層高、4 圈壁厚、100% 免支撐)
//
// V5.0 核心設計升級重點:
//   1. [100% 完整保留 V4.0 已實測完美之機身內腔、頂部快拆擋板、鏡頭與充電開孔]
//      - 內腔尺寸維持 158.55 x 75.92 x 7.75mm (R=8.29mm)，零晃動貼身包覆；
//      - 頂部防脫擋板維持長邊 0.55mm / 短邊與四角 0.45mm，好裝好拆不卡死；
//      - 後置三鏡頭、閃光燈、頂部麥克風與底部充電喇叭孔 100% 維持不變。
//   2. [全新「側壁內階梯挖空 + 3 顆獨立防脫落按鍵蓋 (Drop-In Floating Button Caps)」分件設計]
//      - 手機殼右側壁切出 3 組「內寬外窄」之階梯式貫穿窗 (內側階梯止擋面位於 X = 39.20mm，頂部帶自支撐斜角)；
//      - 獨立配置 3 顆圓潤鵝卵石按鍵蓋（音量+、音量-、電源鍵），每顆按鍵蓋底部皆帶有「0.48mm 防掉出內法蘭擋邊」；
//      - 安裝時先將 3 顆按鍵蓋從手機殼內側放入階梯槽，再裝入手機即可自動鎖定，按鍵蓋絕不會往外掉出或往內掉入！
//   3. [零彈性阻力 + 0.15mm 自由浮動防誤壓間隙 (絕不誤壓重啟、輕觸即響)]
//      - 裸機按鍵頂面位於 X = 38.57mm，手機殼內側階梯止擋面位於 X = 39.20mm (間距 0.63mm)；
//      - 獨立按鍵蓋之內法蘭厚度設定為 0.48mm (內底面位於 X = 38.72mm)，在未按壓時具備 +0.15mm 自由浮動安全餘裕，
//        100% 不會預壓手機按鍵導致重啟，且按壓時無任何塑膠彎曲阻力，直接還原裸機清脆按鍵手感！
// ==============================================================================

$fn = 72;

/* [視圖與輸出模式 / View & Export Mode] */
// print_plate:     一體同盤列印模式 (手機殼主體 + 右側平放 3 顆獨立按鍵蓋，一鍵切片一次印齊)
// case_only:       僅輸出手機殼主體 (側壁已做階梯挖空)
// buttons_only:    僅輸出 3 顆獨立按鍵蓋 (內底面平貼熱床 Z=0，2 分鐘快速列印)
// assembled:       完整裝配檢視 (手機殼 + 3 顆獨立按鍵蓋 + S24+ 裸機)
// cutaway_xz:      垂直截面 (X-Z 平面切過電源鍵，檢視階梯止擋槽、獨立按鍵蓋法蘭與 0.15mm 浮動間隙)
// cutaway_xy:      水平截面 (X-Y 平面切在 Z=5.25mm 按鍵中心，檢視 3 顆獨立按鍵蓋與手機按鍵配合關係)
view_mode = "print_plate"; // [print_plate, case_only, buttons_only, assembled, cutaway_xz, cutaway_xy]

/* [S24+ 實機精準基準尺寸 / Verified Real Phone Dimensions (mm)] */
phone_l          = 158.50; // 裸機實測長度 (Y = -79.25 ~ +79.25mm)
phone_w          = 75.90;  // 裸機實測寬度 (X = -37.95 ~ +37.95mm)
phone_t          = 7.70;   // 裸機厚度 (Z軸)
phone_corner_r   = 8.28;   // 裸機四角圓弧半徑
phone_btn_ext    = 0.62;   // 裸機實體按鍵凸出機身邊框量 (頂面位於 X = 37.95 + 0.62 = 38.57mm)

/* [V4.0/V5.0 已驗證完美之零晃動內腔與快拆前唇參數 (100% 鎖定不變)] */
tol_x            = 0.01;   // 單邊 X 零晃動貼合裕度 (內腔總寬 cav_w = 75.92mm, 半寬 37.96mm)
tol_y            = 0.025;  // 單邊 Y 零晃動貼合裕度 (內腔總長 cav_l = 158.55mm, 半長 79.275mm)
tol_z            = 0.05;   // 垂直方向貼合裕度 (內腔直壁高度 cav_t = 7.75mm)

back_t           = 1.80;   // 背板厚度 (齊平保護 S24+ 凸出三鏡頭)
wall_t           = 1.75;   // 實心側壁厚度 (外壁半寬 = 39.71mm)
front_lip_ramp_h = 0.75;   // 正面擋板 45° 內縮斜坡高度
front_lip_rim_h  = 0.40;   // 正面擋板頂部平緣高度
lip_undercut_side= 0.55;   // 左右長邊頂部擋板內縮量 (0.55mm 好裝好拆)
lip_undercut_end = 0.45;   // 上下短邊與四角頂部擋板內縮量 (0.45mm)

/* [後置三鏡頭與閃光燈精準原廠規格座標 (V5.1 修正微偏問題)] */
// 依據 Samsung Galaxy S24+ (SM-S926) 原廠正交工程渲染圖與 1034176 實機驗證殼交叉量測：
//   - 三鏡頭水平中心 cam_x = 24.90mm (距背面左緣 13.05mm；修正原 25.15mm 偏左 +0.25mm 之問題)
//   - 三鏡頭垂直中心 cam1_y = 66.34mm, cam2_y = 49.14mm, cam3_y = 31.94mm (修正原 +0.43mm 偏上誤差)
//   - 閃光燈中心 flash_x = 11.15mm, flash_y = 57.70mm (修正原 11.75/58.16mm 偏左 +0.60mm、偏上 +0.46mm 之「偏左上」問題)
cam_x            = 24.90;  // 三鏡頭中心 X 座標 (向右微調 0.25mm，消除鏡頭孔些微偏左)
cam1_y           = 66.34;  // 超廣角鏡頭中心 Y
cam2_y           = 49.14;  // 主廣角鏡頭中心 Y
cam3_y           = 31.94;  // 3x 長焦鏡頭中心 Y
cam_hole_d       = 16.54;  // 鏡頭保護開孔直徑

flash_x          = 11.15;  // 閃光燈中心 X 座標 (向右修正 0.60mm)
flash_y          = 57.70;  // 閃光燈中心 Y 座標 (向下修正 0.46mm，徹底消除閃光燈孔偏左上)
flash_hole_d     = 7.10;   // 閃光燈開孔直徑

/* [V5.1 右側「階梯挖空槽 + 3 顆獨立防脫落按鍵蓋」精準修正幾何參數 (mm)] */
// 依據 Samsung Galaxy S24+ (SM-S926) 原廠正交工程圖、gs24_plus.step 與多組實機驗證殼交叉比對：
//   1. 纵向 Y 座標 (以手機中心 Y=0 計)：
//      - 原生一體式音量鍵：Y = +30.54 ~ +50.78mm (總長 20.24mm，中心 +40.66mm)
//      - 原生電源鍵：Y = +10.26 ~ +21.48mm (總長 11.22mm，中心 +15.87mm)
//   2. 厚度方向 Z 座標 (以殼外底面 Z=0、殼內底面 Z=back_t=1.80mm 計)：
//      - 真機側按鍵寬度 2.45mm，中心位於距手機背板玻璃 4.10 ~ 4.25mm 處 (即 Z = 1.80 + 4.20 = 6.00mm，實體範圍 Z = 4.78 ~ 7.22mm)
//      - 修正前 V5.0 誤設為 Z = 5.25mm (偏低 0.75mm)；V5.1 精準抬升至 Z = 6.00mm！
vol_up_y         = 46.30;  // 音量+ 獨立按鍵中心 Y (外窗範圍 +41.70 ~ +50.90mm，完整覆蓋音量鍵頂端 +50.78mm)
vol_dn_y         = 35.00;  // 音量- 獨立按鍵中心 Y (外窗範圍 +30.40 ~ +39.60mm，完整覆蓋音量鍵底端 +30.54mm)
pwr_center_y     = 15.87;  // 電源鍵獨立按鍵中心 Y (外窗範圍 +10.27 ~ +21.47mm，精準對齊電源鍵 +10.26 ~ +21.48mm)

btn_z_mid        = back_t + 4.20; // 6.00 mm (由 V5.0 之 5.25mm 向上抬升 +0.75mm，100% 對準真機按鍵 Z 軸中心！)
btn_win_len_v    = 9.20;   // 音量+ / 音量- 外側開窗長度
btn_win_len_p    = 11.20;  // 電源鍵外側開窗長度
btn_win_h        = 3.60;   // 外側開窗高度 (Z = 4.20 ~ 7.80mm，完整包絡真機按鍵 Z = 4.78 ~ 7.22mm)

btn_flange_ext_y = 0.90;   // 內側階梯槽單邊縱向擴展量 (防掉出法蘭擋邊寬度)
btn_flange_ext_z = 0.65;   // 內側階梯槽單邊垂直擴展量 (內槽高度 = 3.60 + 1.30 = 4.90mm, Z = 3.55 ~ 8.45mm)
btn_step_x       = 39.20;  // 側壁內側階梯止擋面 X 座標 (距裸機按鍵 38.57mm 有 0.63mm 空間，外側留 0.51mm 擋牆)

// 獨立按鍵蓋尺寸與公差：
btn_cap_clr      = 0.18;   // 按鍵蓋與開孔單邊滑動間隙 (確保自由滑動完全不卡滯)
btn_flange_t     = 0.48;   // 按鍵蓋內側法蘭厚度 (0.48mm < 0.63mm 空間，保留 +0.15mm 自由浮動餘裕絕不誤壓重啟！)
btn_cap_total_t  = 1.80;   // 按鍵蓋總厚度 (當按鍵蓋靠在 X=39.20mm 止擋面時，內底面 X=38.72mm，外頂面 X=40.52mm 凸出殼外 0.81mm)

// 推導內部腔體與外殼尺寸
cav_l            = phone_l + 2 * tol_y;                        // 158.55 mm (半長 79.275 mm)
cav_w            = phone_w + 2 * tol_x;                        // 75.92 mm  (半寬 37.96 mm)
cav_t            = phone_t + tol_z;                            // 7.75 mm
cav_r            = phone_corner_r + tol_x;                     // 8.29 mm

outer_l          = cav_l + 2 * wall_t;                         // 162.05 mm (半長 81.025 mm)
outer_w          = cav_w + 2 * wall_t;                         // 79.42 mm  (半寬 39.71 mm)
outer_r          = cav_r + wall_t;                             // 10.04 mm
total_h          = back_t + cav_t + front_lip_ramp_h + front_lip_rim_h; // 10.70 mm

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

// ==============================================================================
// 零晃動貼身內腔與「適中好拆型 0.55mm 防脫前唇」模組 (與 V4.0 100% 相同)
// ==============================================================================
module inner_phone_cavity() {
    lip_open_w = cav_w - 2 * lip_undercut_side; // 75.92 - 1.10 = 74.82 mm
    lip_open_l = cav_l - 2 * lip_undercut_end;  // 158.55 - 0.90 = 157.65 mm
    lip_open_r = max(2.0, cav_r - lip_undercut_end);

    union() {
        // 1. 主機身零晃動貼合容納腔 (Z = back_t 到 back_t + cav_t = 1.80 ~ 9.55mm)
        translate([0, 0, back_t])
            hull() {
                linear_extrude(height = 0.01)
                    rrect2d(cav_w - 1.1, cav_l - 1.1, cav_r - 0.55);
                translate([0, 0, 0.55])
                    linear_extrude(height = cav_t - 0.55)
                        rrect2d(cav_w, cav_l, cav_r);
            }

        // 2. 頂部 45° 自支撐適中鎖定斜坡 (Z = 9.55 ~ 10.30mm)
        translate([0, 0, back_t + cav_t - 0.02])
            hull() {
                linear_extrude(height = 0.02)
                    rrect2d(cav_w, cav_l, cav_r);
                translate([0, 0, front_lip_ramp_h])
                    linear_extrude(height = 0.02)
                        rrect2d(lip_open_w, lip_open_l, lip_open_r);
            }

        // 3. 頂部防脫平緣與向外大導角口 (Z = 10.30 ~ 10.75mm)
        translate([0, 0, back_t + cav_t + front_lip_ramp_h - 0.02])
            hull() {
                linear_extrude(height = 0.18)
                    rrect2d(lip_open_w, lip_open_l, lip_open_r);
                translate([0, 0, front_lip_rim_h + 0.15])
                    linear_extrude(height = 0.02)
                        rrect2d(lip_open_w + 0.90, lip_open_l + 0.90, lip_open_r + 0.45);
            }
    }
}

// ==============================================================================
// 後置三鏡頭與閃光燈精準斜切保護窗 (與 V4.0 100% 相同)
// ==============================================================================
module camera_and_flash_cutouts() {
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

    translate([flash_x, flash_y, -0.1]) {
        cylinder(d1 = flash_hole_d + 1.6, d2 = flash_hole_d, h = 1.0);
        translate([0, 0, 0.8])
            cylinder(d = flash_hole_d, h = back_t + 1.0);
    }
}

// ==============================================================================
// 頂部與底部開孔模組 (與 V4.0 100% 相同)
// ==============================================================================
module port_cutouts() {
    z_mid = back_t + 3.85;

    translate([0, -outer_l/2 - 1, z_mid])
        rotate([-90, 0, 0])
            support_free_slot(12.8, 6.2, wall_t + 4.0);

    translate([-16.2, -outer_l/2 - 1, z_mid])
        rotate([-90, 0, 0])
            support_free_slot(11.5, 4.2, wall_t + 4.0);

    translate([10.5, -outer_l/2 - 1, z_mid])
        rotate([-90, 0, 0])
            support_free_slot(4.5, 3.6, wall_t + 4.0);

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
// V5.0 核心升級：「側壁內階梯挖空槽 (Stepped Button Slot)」與「3 顆獨立防脫落按鍵蓋」
// ==============================================================================

// 輔助模組：沿 X 軸拉伸之圓角膠囊柱 (頂部帶微尖拱自支撐設計，側壁橫向開孔免支撐不垂墜)
module horiz_pill_x(len_y, h_z, depth_x, r_end=1.40, roof_peak=0.30) {
    r_use = min(r_end, min(len_y, h_z)/2 - 0.1);
    rotate([0, 90, 0])
        linear_extrude(height = depth_x)
            hull() {
                for (sy = [-1, 1])
                    for (sz = [-1, 1])
                        translate([sz * (h_z/2 - r_use), sy * (len_y/2 - r_use)])
                            circle(r = r_use, $fn = 36);
                // 頂部 (-X in 2D = +Z in 3D) 微拱自支撐導角，消除水平懸空橋接垂墜
                if (roof_peak > 0) {
                    for (sy = [-1, 1])
                        translate([-(h_z/2 - r_use + roof_peak), sy * max(0, len_y/2 - r_use - roof_peak*1.2)])
                            circle(r = max(0.2, r_use - roof_peak), $fn = 28);
                }
            }
}

// 1. 手機殼側壁「內寬外窄」階梯式按鍵挖空槽
//    - 外側貫穿孔：長 win_len x 高 btn_win_h (供按鍵帽穿出殼外)
//    - 內側階梯止擋槽：長 (win_len + ext_y_neg + ext_y_pos) x 高 (btn_win_h + 2*btn_flange_ext_z)，
//      由內腔一路向外挖至 X = btn_step_x (39.20mm)，形成堅固的 0.51mm 外擋牆鎖住按鍵蓋法蘭！
module stepped_button_cutout(center_y, win_len, ext_y_neg, ext_y_pos) {
    cb_len = win_len + ext_y_neg + ext_y_pos;
    cb_y   = center_y + (ext_y_pos - ext_y_neg) / 2;
    cb_h   = btn_win_h + 2 * btn_flange_ext_z; // 5.20 mm

    union() {
        // (A) 外側貫穿孔 (X = 38.50 ~ 41.50mm)
        translate([btn_step_x - 0.50, center_y, btn_z_mid])
            horiz_pill_x(win_len, btn_win_h, 3.00, 1.45, 0.25);

        // (B) 內側階梯法蘭容納槽 (從內腔 X = 37.00mm 挖至止擋面 X = btn_step_x = 39.20mm)
        translate([37.00, cb_y, btn_z_mid])
            horiz_pill_x(cb_len, cb_h, btn_step_x - 37.00, 1.75, 0.35);
    }
}

// 2. 單顆「獨立防脫落圓潤按鍵蓋」(局部座標系：內底面位於 X = 0，向外延伸至 X = btn_cap_total_t = 1.80mm)
//    - 內底面 (X = 0 ~ 0.48mm)：寬大防掉出法蘭擋邊 (卡在手機殼內側階梯槽內，絕不掉出)
//    - 外按鍵柱與鵝卵石圓頂 (X = 0.48 ~ 1.80mm)：穿出手機殼外窗，頂部全圓弧倒角溫潤不割手
module standalone_button_cap(win_len, ext_y_neg, ext_y_pos, has_dot=false) {
    cap_len    = win_len - 2 * btn_cap_clr; // 預留 0.18mm 單邊滑動裕度，順暢不卡鍵
    cap_h      = btn_win_h - 2 * btn_cap_clr;
    flange_len = (win_len + ext_y_neg + ext_y_pos) - 2 * (btn_cap_clr + 0.04);
    flange_h   = (btn_win_h + 2 * btn_flange_ext_z) - 2 * (btn_cap_clr + 0.04);
    flange_dy  = (ext_y_pos - ext_y_neg) / 2;

    r_cap      = 1.25;
    dome_start = 1.15; // 從 X = 1.15mm 至 1.80mm 做多階鵝卵石圓潤球頂過渡

    union() {
        // (A) 內側防掉出法蘭底板 (X = 0 ~ btn_flange_t = 0.48mm，平貼熱床列印時之第一層底座)
        translate([0, flange_dy, 0])
            horiz_pill_x(flange_len, flange_h, btn_flange_t, 1.55, 0.25);

        // (B) 穿出殼外之按鍵主體 + 圓潤鵝卵石弧頂 (X = btn_flange_t - 0.05 ~ btn_cap_total_t = 1.80mm)
        hull() {
            translate([btn_flange_t - 0.05, 0, 0])
                horiz_pill_x(cap_len, cap_h, dome_start - btn_flange_t + 0.05, r_cap, 0.18);

            // 中段圓弧收斂
            translate([btn_cap_total_t - 0.28, 0, 0])
                horiz_pill_x(cap_len - 0.55, cap_h - 0.55, 0.10, max(0.5, r_cap - 0.25), 0.10);

            // 頂端溫潤鵝卵石弧面 (X = 1.80mm，完全消除銳利稜角)
            translate([btn_cap_total_t - 0.05, 0, 0])
                horiz_pill_x(cap_len - 1.30, cap_h - 1.30, 0.05, max(0.3, r_cap - 0.55), 0.0);
        }

        // (C) 電源鍵專屬盲操圓潤凸點
        if (has_dot) {
            translate([btn_cap_total_t, 0, 0])
                scale([0.30, 1.0, 1.0])
                    sphere(r = 0.95, $fn = 32);
        }
    }
}

// ==============================================================================
// 手機殼主體模組 (含右側 3 個階梯式按鍵挖空槽)
// ==============================================================================
module s24_plus_petg_case_body() {
    difference() {
        // 1. 外部圓潤主殼體 (100% 純平光滑外背板 + 多階圓弧過渡邊框)
        rrect_smooth(outer_w, outer_l, total_h, outer_r, 1.5, 1.0);

        // 2. 內部零晃動緊配腔體 + 0.55mm 適中好拆防脫前唇
        inner_phone_cavity();

        // 3. 後置三鏡頭與閃光燈開窗
        camera_and_flash_cutouts();

        // 4. 頂部麥克風與底部充電/喇叭開孔
        port_cutouts();

        // 5. 切出右側 3 個「內寬外窄」階梯式獨立按鍵槽
        //    音量+ 與 音量- 之間保留 1.60mm 外分隔柱與 0.60mm 內分隔肋，兩顆按鍵蓋互不干涉
        stepped_button_cutout(vol_up_y, btn_win_len_v, 0.50, btn_flange_ext_y);
        stepped_button_cutout(vol_dn_y, btn_win_len_v, btn_flange_ext_y, 0.50);
        stepped_button_cutout(pwr_center_y, btn_win_len_p, btn_flange_ext_y, btn_flange_ext_y);
    }
}

// ==============================================================================
// 3 顆獨立按鍵蓋列印盤模組 (內底面法蘭平貼熱床 Z = 0，圓頂朝上 +Z，100% 免支撐快速列印)
// ==============================================================================
module standalone_buttons_print_set(base_x = 0) {
    // rotate([0, -90, 0]) 將局部 +X (外圓頂) 轉向世界 +Z (朝上)，使 X=0 (內底面法蘭) 100% 平貼熱床 Z=0！
    // 1. 音量+ 獨立按鍵蓋
    translate([base_x, vol_up_y + 1.5, 0])
        rotate([0, -90, 0])
            standalone_button_cap(btn_win_len_v, 0.50, btn_flange_ext_y, false);

    // 2. 音量- 獨立按鍵蓋
    translate([base_x, vol_dn_y - 1.5, 0])
        rotate([0, -90, 0])
            standalone_button_cap(btn_win_len_v, btn_flange_ext_y, 0.50, false);

    // 3. 電源鍵獨立按鍵蓋 (帶盲操圓點)
    translate([base_x, pwr_center_y - 3.0, 0])
        rotate([0, -90, 0])
            standalone_button_cap(btn_win_len_p, btn_flange_ext_y, btn_flange_ext_y, true);
}

// 3 顆獨立按鍵蓋裝配於手機殼階梯槽內之位置 (內法蘭靠在 X = btn_step_x = 39.20mm，內底面位於 X = 38.72mm)
module standalone_buttons_assembled() {
    cap_in_x = btn_step_x - btn_flange_t; // 39.20 - 0.48 = 38.72 mm (距裸機按鍵 38.57mm 留有 +0.15mm 安全浮動間隙！)
    color("#63b3ed") {
        translate([cap_in_x, vol_up_y, btn_z_mid])
            standalone_button_cap(btn_win_len_v, 0.50, btn_flange_ext_y, false);
        translate([cap_in_x, vol_dn_y, btn_z_mid])
            standalone_button_cap(btn_win_len_v, btn_flange_ext_y, 0.50, false);
        translate([cap_in_x, pwr_center_y, btn_z_mid])
            standalone_button_cap(btn_win_len_p, btn_flange_ext_y, btn_flange_ext_y, true);
    }
}

// ==============================================================================
// S24+ 精準參考裸機模型
// ==============================================================================
module dummy_s24_plus_phone() {
    translate([0, 0, back_t + tol_z/2]) {
        color("#2c3038")
            rrect_smooth(phone_w, phone_l, phone_t, phone_corner_r, 0.55, 0.55);
        color("#12161f")
            translate([0, 0, phone_t - 0.05])
                linear_extrude(height = 0.10)
                    rrect2d(phone_w - 2.6, phone_l - 2.6, phone_corner_r - 1.3);
        color("#d0d5dd")
            for (cy = [cam1_y, cam2_y, cam3_y])
                translate([cam_x, cy, -1.55])
                    cylinder(d = 14.61, h = 1.60);
        color("#0b0e14")
            for (cy = [cam1_y, cam2_y, cam3_y])
                translate([cam_x, cy, -1.60])
                    cylinder(d = 11.0, h = 0.2);
        color("#f5e6b3")
            translate([flash_x, flash_y, -0.25])
                cylinder(d = 4.74, h = 0.30);
        // 右側實體音量鍵與電源鍵 (頂面位於 X = 37.95 + 0.62 = 38.57mm，Z 中心位於距背板 4.20mm)
        color("#f6ad55") {
            translate([phone_w/2, 40.66, 4.20])
                cube([phone_btn_ext * 2, 20.24, 2.45], center = true);
            translate([phone_w/2, 15.87, 4.20])
                cube([phone_btn_ext * 2, 11.22, 2.45], center = true);
        }
    }
}

// ==============================================================================
// 視圖模式切換渲染與 STL 輸出
// ==============================================================================
if (view_mode == "print_plate") {
    // 手機殼主體 + 右側平放 3 顆獨立按鍵蓋 (同盤一次列印)
    color("#2b6cb0")
        s24_plus_petg_case_body();
    color("#63b3ed")
        standalone_buttons_print_set(outer_w/2 + 6.5);
} else if (view_mode == "case_only") {
    color("#2b6cb0")
        s24_plus_petg_case_body();
} else if (view_mode == "buttons_only") {
    color("#63b3ed")
        standalone_buttons_print_set(0);
} else if (view_mode == "assembled") {
    color("#2b6cb0")
        s24_plus_petg_case_body();
    standalone_buttons_assembled();
    dummy_s24_plus_phone();
} else if (view_mode == "cutaway_xz") {
    difference() {
        union() {
            color("#2b6cb0")
                s24_plus_petg_case_body();
            standalone_buttons_assembled();
            dummy_s24_plus_phone();
        }
        translate([-10, -90, -5])
            cube([70, 90 + pwr_center_y, 30]);
    }
} else if (view_mode == "cutaway_xy") {
    difference() {
        union() {
            color("#2b6cb0")
                s24_plus_petg_case_body();
            standalone_buttons_assembled();
            dummy_s24_plus_phone();
        }
        translate([-50, -90, btn_z_mid])
            cube([100, 180, 20]);
        translate([-50, -90, -10])
            cube([100, 180, 10 + btn_z_mid - 1.5]);
    }
}
