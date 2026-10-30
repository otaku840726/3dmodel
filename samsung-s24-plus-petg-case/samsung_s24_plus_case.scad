// ==============================================================================
// 專案名稱: Samsung Galaxy S24+ (SM-S926) 極簡圓潤人體工學 PETG 全包覆手機殼
// 設計版本: V4.0 (實機安裝終極調校版：無鏤空微彎薄壁按鍵 + T型加高加長零間隙凸台 + 零晃動緊配內腔 + 順暢快拆前唇)
// 適用機型: Samsung Galaxy S24+ / S24 Plus (官方基準 158.50 x 75.90 x 7.70 mm, R=8.28mm)
// 適用耗材: 專為 PETG 最佳化 (建議 0.4mm 噴嘴、0.16~0.20mm 層高、開啟薄壁偵測 / Arachne 最小牆寬 45%)
//
// V4.0 針對實機測試 5 大回饋全面修正重點:
//   1. [側按鍵上下取消鏤空，改為 100% 全封閉式 0.22mm 微彎薄壁鼓膜結構]
//      - 徹底取消按鍵上下的水平貫穿鏤空縫隙，整圈側壁從底到頂每一層皆為 100% 連續封閉外牆迴圈，
//        列印時完全無懸空架橋、無拉絲、極度好印！
//   2. [側按鍵內側凸點改為「T 型窄頸 + 6.0x3.6mm 加高加長大面積觸發板」並下移校正高度]
//      - 將按鍵垂直中心由 Z=5.65mm 下移校正至 Z=5.20mm（貼合真機按鍵高度），並將觸發板垂直高度由 2.25mm
//        大幅加高至 3.60mm (Z=3.40~7.00mm)；
//      - 同時將音量鍵中心下移校正 (音量+ Y=+45.40mm / 音量- Y=+33.80mm)，並將觸發板縱向長度由 1.35mm
//        大幅加長至 6.00~6.80mm，形成「T 型窄頸懸浮大面積觸發板」：以 1.50mm 窄頸連接 0.22mm 薄壁（不犧牲薄壁柔軟度），
//        內端展開為 6.0x3.6mm 大面積觸發板，徹底杜絕高低對不準問題！
//   3. [消除凸點與手機按鍵間隙：觸發板內推 0.46mm 至 X=38.12mm 實現「零空行程貼合」]
//      - 將觸發板內表面由舊版 X=38.58mm 大幅往內推進至 X=38.12mm（僅距內腔壁 0.16mm），
//        安裝後直接零間隙貼合手機實體按鍵，輕觸 0.15mm 即可清脆觸發，無須用力深按！
//   4. [消除手機在殼內極小移動：內腔尺寸精準收緊貼合 158.50 x 75.90 x 7.70mm 機身]
//      - 內腔寬度由 76.16mm 收緊至 75.92mm (半寬 37.96mm)、長度由 158.90mm 收緊至 158.55mm (半長 79.275mm)、
//        深度由 7.92mm 收緊至 7.75mm、四角 R=8.29mm，四邊與四角 100% 緊密貼合機身不晃動！
//   5. [解決過緊難以取出問題：縮減頂部防脫擋板內縮量 50%]
//      - 將正面頂部防脫卡扣擋板內縮量由舊版「長邊 1.10mm / 短邊 0.95mm」縮減為「長邊 0.55mm / 短邊與四角 0.45mm」，
//        並將卡扣高度精簡至 1.15mm，兼顧防脫落與雙手大拇指輕鬆推開拆殼！
// ==============================================================================

$fn = 72;

/* [視圖模式 / View Mode] */
// printable:       可直接切片列印之單件手機殼 (背板朝下平貼熱床 Z=0)
// assembled:       疊加 S24+ 精準裸機之完整裝配對位驗證
// cutaway_xz:      垂直截面 (X-Z 平面切過按鍵區，檢視上下無鏤空 0.22mm 薄壁、3.6mm 加高凸台與 0.55mm 適中前唇)
// cutaway_xy:      水平截面 (X-Y 平面切在 Z=5.20mm 按鍵中心，檢視 0.22mm 微彎薄壁與 T 型零間隙加長觸發板)
view_mode = "printable"; // [printable, assembled, cutaway_xz, cutaway_xy]

/* [S24+ 實機精準基準尺寸 / Verified Real Phone Dimensions (mm)] */
phone_l          = 158.50; // 裸機實測長度 (Y = -79.25 ~ +79.25mm)
phone_w          = 75.90;  // 裸機實測寬度 (X = -37.95 ~ +37.95mm)
phone_t          = 7.70;   // 裸機厚度 (Z軸)
phone_corner_r   = 8.28;   // 裸機四角圓弧半徑
phone_btn_ext    = 0.38;   // 裸機實體按鍵有效觸發頂面凸出機身邊框量 (頂面位於 X = 37.95 + 0.38 = 38.33mm)

/* [V4.0 零晃動貼身內腔公差與適中快拆前唇參數 / Zero-Play Cavity & Easy-Release Lip (mm)] */
tol_x            = 0.01;   // 單邊 X 零晃動貼合裕度 (內腔總寬 cav_w = 75.92mm, 半寬 37.96mm, 消除左右晃動)
tol_y            = 0.025;  // 單邊 Y 零晃動貼合裕度 (內腔總長 cav_l = 158.55mm, 半長 79.275mm, 消除上下移動)
tol_z            = 0.05;   // 垂直方向貼合裕度 (內腔直壁高度 cav_t = 7.75mm)

back_t           = 1.80;   // 背板厚度 (齊平保護 S24+ 凸出三鏡頭)
wall_t           = 1.75;   // 實心側壁厚度 (外壁半寬 = 39.71mm)
front_lip_ramp_h = 0.75;   // 正面擋板 45° 內縮斜坡高度 (100% 免支撐)
front_lip_rim_h  = 0.40;   // 正面擋板頂部平緣高度
lip_undercut_side= 0.55;   // 左右長邊頂部擋板內縮量 (由 1.10mm 縮小一半至 0.55mm，好裝好拆不卡死！)
lip_undercut_end = 0.45;   // 上下短邊與四角頂部擋板內縮量 (由 0.95mm 縮小至 0.45mm，拇指一推即可拆下！)

/* [後置三鏡頭與閃光燈精準 CAD 座標 / Verified Rear Camera & Flash Layout (mm)] */
cam_x            = 25.15;  // 三鏡頭中心 X 座標
cam1_y           = 66.74;  // 超廣角鏡頭中心 Y
cam2_y           = 49.57;  // 主廣角鏡頭中心 Y
cam3_y           = 32.41;  // 3x 長焦鏡頭中心 Y
cam_hole_d       = 16.54;  // 鏡頭保護開孔直徑

flash_x          = 11.75;  // 閃光燈中心 X 座標
flash_y          = 58.16;  // 閃光燈中心 Y 座標
flash_hole_d     = 7.10;   // 閃光燈開孔直徑

/* [V4.0 右側「上下無鏤空 0.22mm 微彎薄壁 + T型加高加長零間隙觸發板」座標參數 (mm)] */
vol_up_y         = 45.40;  // 音量+ 按鍵與凸台中心 Y (凸台覆蓋 Y = +42.40 ~ +48.40mm，完美對準音量+！)
vol_dn_y         = 33.80;  // 音量- 按鍵與凸台中心 Y (凸台覆蓋 Y = +30.80 ~ +36.80mm，完美對準音量-！)
pwr_center_y     = 15.87;  // 電源鍵按鍵與凸台中心 Y (凸台覆蓋 Y = +12.47 ~ +19.27mm，完美對準電源鍵！)

btn_span_v       = 10.80;  // 音量+ / 音量- 微彎薄壁區總跨度
btn_span_p       = 12.00;  // 電源鍵微彎薄壁區總跨度
btn_wall_t       = 0.22;   // 全封閉式微彎彈性膜壁厚 (0.22mm 極薄微彎壁厚，四周無鏤空連續好印且輕觸即凹)
btn_arch_amp     = 0.72;   // 餘弦微彎外拱幅度 (中央向外平滑微彎拱起 0.72mm)

// 內側 T 型加高加長零間隙觸發凸台 (T-Bar Large Zero-Gap Actuator Pad) 尺寸：
btn_z_mid        = back_t + 3.40; // 5.20 mm (由舊版 5.65mm 下移校正 0.45mm，解決凸點位置太高問題！)
btn_pocket_h     = 6.40;   // 內側薄壁掏空區總高度 (Z = 2.00 ~ 8.40mm，上下完全封閉無鏤空)
btn_pad_h        = 3.60;   // 內側觸發板垂直總高度 (由 2.25mm 加大至 3.60mm，覆蓋 Z = 3.40 ~ 7.00mm！)
btn_pad_len_v    = 6.00;   // 音量鍵內側觸發板縱向長度 (由 1.35mm 加大至 6.00mm！)
btn_pad_len_p    = 6.80;   // 電源鍵內側觸發板縱向長度 (由 1.35mm 加大至 6.80mm！)
btn_nub_tip_x    = 38.12;  // 觸發板內表面 X 座標 (由 38.58mm 大幅內推 0.46mm 至 38.12mm，零距離貼合手機按鍵！)

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
// V4.0 零晃動貼身內腔與「適中好拆型 0.55mm 防脫前唇」模組
// ==============================================================================
module inner_phone_cavity() {
    lip_open_w = cav_w - 2 * lip_undercut_side; // 75.92 - 1.10 = 74.82 mm (單邊適中扣住 0.54mm，好拆不死緊！)
    lip_open_l = cav_l - 2 * lip_undercut_end;  // 158.55 - 0.90 = 157.65 mm (單端適中扣住 0.425mm)
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

        // 3. 頂部防脫平緣與向外大導角口 (Z = 10.30 ~ 10.75mm，方便大拇指撥開拆殼)
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
// 後置三鏡頭與閃光燈精準斜切保護窗 (依據 gs24_plus.step 座標)
// ==============================================================================
module camera_and_flash_cutouts() {
    // 1. 三鏡頭一體化跑道型視窗
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

    // 2. LED 閃光燈獨立防眩光開孔
    translate([flash_x, flash_y, -0.1]) {
        cylinder(d1 = flash_hole_d + 1.6, d2 = flash_hole_d, h = 1.0);
        translate([0, 0, 0.8])
            cylinder(d = flash_hole_d, h = back_t + 1.0);
    }
}

// ==============================================================================
// 頂部與底部開孔模組
// ==============================================================================
module port_cutouts() {
    z_mid = back_t + 3.85;

    // 1. 底部正中央 USB Type-C 充電孔
    translate([0, -outer_l/2 - 1, z_mid])
        rotate([-90, 0, 0])
            support_free_slot(12.8, 6.2, wall_t + 4.0);

    // 2. 底部揚聲器與主麥克風開孔
    translate([-16.2, -outer_l/2 - 1, z_mid])
        rotate([-90, 0, 0])
            support_free_slot(11.5, 4.2, wall_t + 4.0);

    // 底部副麥克風孔
    translate([10.5, -outer_l/2 - 1, z_mid])
        rotate([-90, 0, 0])
            support_free_slot(4.5, 3.6, wall_t + 4.0);

    // 3. 頂部雙降噪麥克風開孔
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
// V4.0 核心升級：「上下無鏤空 100% 封閉式 0.22mm 微彎薄壁按鍵 + T 型加高加長零間隙觸發板」
// ==============================================================================
// 結構原理解析：
//   1. [上下完全無鏤空，100% 封閉連續外牆]：
//      先在側壁切出高 6.40mm (Z = 2.00 ~ 8.40mm)、頂部帶 45° 免支撐斜屋頂的內側避空窗，
//      再於外側補上「100% 封閉無縫之 0.22mm 餘弦微彎薄壁殼 (button_sealed_shell)」，
//      薄壁上下左右四邊皆完全熔入實心側壁，外觀與切片完全無任何鏤空或破洞！
//   2. [T 型窄頸 + 6.0x3.6mm 加高加長零間隙觸發板]：
//      為避免 6.0mm 長的凸台直接黏死整片薄壁導致變硬，採用「T 型懸浮結構」：
//      - 根部僅以寬 1.60mm 的中央彈性連桿連接 0.22mm 微彎薄壁中央（保留 85% 以上的自由微彎變形區）；
//      - 連桿向內延伸至 X = 38.12mm 處，展開為「長 6.0~6.8mm × 高 3.60mm」的大面積平整觸發板，
//        直接零間隙貼合手機實體按鍵，無論按壓高處、低處或中央皆能輕鬆觸發！

// 餘弦微彎曲線函數：u 從 -1 到 +1，回傳 0 ~ btn_arch_amp 之平滑微彎外凸量
function btn_arch_offset(u) =
    (abs(u) >= 1.0) ? 0.0 : btn_arch_amp * (1.0 + cos(180.0 * u)) / 2.0;

// 1. 側壁按鍵區內部避空槽 (供微彎薄壁與 T 型觸發板自由回彈，頂部帶 45° 自支撐斜坡)
module button_pocket_void(center_y, span_len) {
    roof_h = 0.85;
    translate([outer_w/2, center_y, btn_z_mid])
        hull() {
            cube([wall_t * 3, span_len, btn_pocket_h - 2 * roof_h], center = true);
            translate([0, 0, btn_pocket_h/2])
                cube([wall_t * 3, span_len - 1.20, 0.04], center = true);
            translate([0, 0, -btn_pocket_h/2])
                cube([wall_t * 3, span_len - 1.20, 0.04], center = true);
        }

    // 內腔邊緣擴口避空槽 (容納 T 型觸發板並避免刮擦裸機按鍵)
    translate([cav_w/2, center_y, btn_z_mid])
        hull() {
            cube([1.60, span_len + 0.40, btn_pocket_h - 1.20], center = true);
            cube([1.60, span_len - 0.80, btn_pocket_h + 0.10], center = true);
        }
}

// 2. 100% 全封閉無鏤空之「0.22mm 餘弦微彎薄壁殼」+「T 型加高加長零間隙觸發板」
module button_sealed_compliant_assembly(center_y, span_len, pad_len, has_dot=false) {
    steps  = 32;
    ext_u  = 1.10; // 左右兩端延伸 10% 熔入實心側壁
    seal_z = btn_pocket_h + 1.00; // 上下各延伸 0.50mm 熔入上下實心側壁，確保 100% 封閉無任何縫隙！
    arch_z = btn_pocket_h - 1.40; // 中段微彎外拱高度 (5.00mm)，上下以 45° 斜坡平滑過渡至外壁齊平處

    union() {
        // (A) 100% 全封閉無鏤空之 0.22mm 餘弦微彎薄壁鼓膜 (上下左右完全封閉，零架橋極度好印)
        for (i = [0 : steps - 1]) {
            u1 = -ext_u + (2 * ext_u * i) / steps;
            u2 = -ext_u + (2 * ext_u * (i + 1)) / steps;
            y1 = center_y + u1 * (span_len / 2);
            y2 = center_y + u2 * (span_len / 2);

            x_arch1 = outer_w/2 + btn_arch_offset(u1);
            x_arch2 = outer_w/2 + btn_arch_offset(u2);
            x_flat  = outer_w/2;

            // 中段微彎外拱區 (維持恆定 0.22mm 薄壁)
            hull() {
                translate([x_arch1 - btn_wall_t/2, y1, btn_z_mid])
                    cube([btn_wall_t, 0.03, arch_z], center = true);
                translate([x_arch2 - btn_wall_t/2, y2, btn_z_mid])
                    cube([btn_wall_t, 0.03, arch_z], center = true);
            }

            // 上方無鏤空封閉過渡斜坡 (維持恆定 0.22mm 薄壁，平滑收合至側壁外表面 X = outer_w/2)
            hull() {
                translate([x_arch1 - btn_wall_t/2, y1, btn_z_mid + arch_z/2 - 0.02])
                    cube([btn_wall_t, 0.03, 0.04], center = true);
                translate([x_arch2 - btn_wall_t/2, y2, btn_z_mid + arch_z/2 - 0.02])
                    cube([btn_wall_t, 0.03, 0.04], center = true);
                translate([x_flat - btn_wall_t/2, y1, btn_z_mid + seal_z/2])
                    cube([btn_wall_t, 0.03, 0.30], center = true);
                translate([x_flat - btn_wall_t/2, y2, btn_z_mid + seal_z/2])
                    cube([btn_wall_t, 0.03, 0.30], center = true);
            }

            // 下方無鏤空封閉過渡斜坡 (維持恆定 0.22mm 薄壁，平滑收合至側壁外表面 X = outer_w/2)
            hull() {
                translate([x_arch1 - btn_wall_t/2, y1, btn_z_mid - arch_z/2 + 0.02])
                    cube([btn_wall_t, 0.03, 0.04], center = true);
                translate([x_arch2 - btn_wall_t/2, y2, btn_z_mid - arch_z/2 + 0.02])
                    cube([btn_wall_t, 0.03, 0.04], center = true);
                translate([x_flat - btn_wall_t/2, y1, btn_z_mid - seal_z/2])
                    cube([btn_wall_t, 0.03, 0.30], center = true);
                translate([x_flat - btn_wall_t/2, y2, btn_z_mid - seal_z/2])
                    cube([btn_wall_t, 0.03, 0.30], center = true);
            }
        }

        // (B) 電源鍵專屬光滑球面盲操微凸點
        if (has_dot) {
            translate([outer_w/2 + btn_arch_amp, center_y, btn_z_mid])
                scale([0.28, 1.0, 1.0])
                    sphere(r = 0.95, $fn = 32);
        }

        // (C) 內側「T 型加高加長零間隙觸發板」(根部 1.60mm 窄頸不影響薄壁彈性，內端 6.0x3.6mm 大平板貼合按鍵！)
        center_x_in = outer_w/2 + btn_arch_amp - btn_wall_t; // 39.71 + 0.72 - 0.22 = 40.21 mm
        plate_t     = 0.85; // 內端大面積觸發板厚度 (位於 X = 38.12 ~ 38.97mm，與 0.22mm 薄壁之間留有 >0.9mm 彈性間隙！)
        stem_y      = 1.65; // 中央連接頸寬度
        stem_z      = 2.60; // 中央連接頸高度
        bevel_z     = 0.55; // 45° 自支撐導角

        // C1. 中央連接頸 (連接 X = 40.21mm 微彎薄壁中心 與 X = 38.97mm 觸發板背面)
        hull() {
            translate([center_x_in + 0.02, center_y, btn_z_mid])
                cube([0.04, stem_y, stem_z], center = true);
            translate([btn_nub_tip_x + plate_t - 0.05, center_y, btn_z_mid])
                cube([0.10, stem_y + 1.20, btn_pad_h - 0.30], center = true);
        }

        // C2. 內端「長 6.0~6.8mm × 高 3.60mm」零間隙大面積觸發平板 (頂面直達 X = 38.12mm)
        hull() {
            // 觸發板背面 (X = 38.12 + 0.85 = 38.97mm，底部與頂部帶 45° 免支撐導角)
            translate([btn_nub_tip_x + plate_t - 0.02, center_y, btn_z_mid])
                cube([0.04, pad_len, btn_pad_h], center = true);

            // 觸發板正面 (X = 38.12mm，直接貼合手機實體按鍵！)
            translate([btn_nub_tip_x + 0.02, center_y, btn_z_mid])
                cube([0.04, pad_len - 0.70, btn_pad_h - 2 * bevel_z], center = true);
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
            rrect_smooth(outer_w, outer_l, total_h, outer_r, 1.5, 1.0);

            // 2. 內部零晃動緊配腔體 + 0.55mm 適中好拆防脫前唇
            inner_phone_cavity();

            // 3. 後置三鏡頭與閃光燈開窗
            camera_and_flash_cutouts();

            // 4. 頂部麥克風與底部充電/喇叭開孔
            port_cutouts();

            // 5. 切出 3 顆按鍵之內部回彈槽
            button_pocket_void(vol_up_y, btn_span_v);
            button_pocket_void(vol_dn_y, btn_span_v);
            button_pocket_void(pwr_center_y, btn_span_p);
        }

        // 6. 置入 3 組「上下無鏤空 100% 封閉式 0.22mm 微彎薄壁 + T 型 6.0x3.6mm 零間隙觸發板」
        button_sealed_compliant_assembly(vol_up_y, btn_span_v, btn_pad_len_v, false);
        button_sealed_compliant_assembly(vol_dn_y, btn_span_v, btn_pad_len_v, false);
        button_sealed_compliant_assembly(pwr_center_y, btn_span_p, btn_pad_len_p, true);
    }
}

// ==============================================================================
// S24+ 精準參考裸機模型
// ==============================================================================
module dummy_s24_plus_phone() {
    translate([0, 0, back_t + tol_z/2]) {
        // 機身主體 (75.90 x 158.50 x 7.70mm, R=8.28mm)
        color("#2c3038")
            rrect_smooth(phone_w, phone_l, phone_t, phone_corner_r, 0.55, 0.55);
        // 螢幕面板
        color("#12161f")
            translate([0, 0, phone_t - 0.05])
                linear_extrude(height = 0.10)
                    rrect2d(phone_w - 2.6, phone_l - 2.6, phone_corner_r - 1.3);
        // 後置三鏡頭環
        color("#d0d5dd")
            for (cy = [cam1_y, cam2_y, cam3_y])
                translate([cam_x, cy, -1.55])
                    cylinder(d = 14.61, h = 1.60);
        color("#0b0e14")
            for (cy = [cam1_y, cam2_y, cam3_y])
                translate([cam_x, cy, -1.60])
                    cylinder(d = 11.0, h = 0.2);
        // LED 閃光燈
        color("#f5e6b3")
            translate([flash_x, flash_y, -0.25])
                cylinder(d = 4.74, h = 0.30);
        // 右側實體音量鍵與電源鍵 (頂面位於 X = 37.95 + 0.38 = 38.33mm，與 X=38.12mm 觸發板緊密零間隙接觸)
        color("#f6ad55") {
            translate([phone_w/2, 39.60, 3.40])
                cube([phone_btn_ext * 2, 20.20, 2.10], center = true);
            translate([phone_w/2, 15.87, 3.40])
                cube([phone_btn_ext * 2, 11.20, 2.10], center = true);
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
        translate([-50, -90, -10])
            cube([100, 180, 10 + btn_z_mid - 1.5]);
    }
}
