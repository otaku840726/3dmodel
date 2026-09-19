// ==============================================================================
// 專案名稱: 80mm 磁吸式排風管轉接頭 (80mm Magnetic Exhaust Duct Adapter)
// 對應型號: 牆面排風網罩磁吸轉接底座 (magnetic-exhaust-base)
// 設計用途: 用於快速磁吸安裝於牆面底座，連接 80mm 標準排風軟管（鋁箔管 / PVC複合風管）。
// 特點功能:
//   1. ★★★ 真正的 100% 全角度免支撐架構 (Zero-Support Architecture) ★★★
//      - 徹底消除法蘭底部懸空平階：外壁採連續 >= 47.1 度導向斜面（高於 3D 列印 45 度臨界角）。
//      - 內部風道連續平滑漸層，無任何懸空內頂面與台階。
//      - 防脫倒鉤凸緣採雙向 58 度溫和斜坡，全件無任何觸發支撐之幾何特徵。
//   2. 8 顆 5x3 磁鐵 (6 齒彈性避讓槽)，與底座磁鐵 100% 精準對位，提供約 4kgf 強勁吸力。
//   3. 1.5mm 內嵌對位止口 (Alignment Lip)，消除風管拉扯剪切滑動，兼具高度氣密性。
//   4. 外套式 78.8mm 接頭 + 80.8mm 防脫倒鉤環 (Retention Barb)，喉箍鎖固絕不滑脫。
//   5. 氣動優化過渡錐段 (Lofted Funnel)，方孔轉圓管流線過渡，極低風阻無亂流。
// 建議列印材質: PETG / ABS / ASA (耐溫耐候)
// ==============================================================================

$fn = 64;

// ==================== 1. 列印方向與配置選擇 ====================
// "duct_down"             : (推薦首選) 管口朝下貼熱床。★★★ 全件 100% 免支撐（0 個懸空面）★★★
//                           磁鐵盲孔與對位止口皆由頂部朝上成型，精度最高、邊緣最銳利。
// "flange_down_flat"      : 法蘭朝下貼熱床，關閉對位止口 (全平面法蘭)。100% 免支撐，適合黏貼氣密矽膠片。
// "flange_down_supported" : 法蘭朝下且保留止口 (法蘭底部需極薄 1.5mm 邊緣支撐)。
print_mode = "duct_down";

// ==================== 2. 法蘭與幾何尺寸參數 ====================
frame_size_x = 97.0;        // 法蘭外框 X 邊長 (mm，對標底座 97.0 mm)
frame_size_y = 97.0;        // 法蘭外框 Y 邊長 (mm，對標底座 97.0 mm)
flange_rim_h = 2.5;         // 法蘭外圍直壁厚度 (mm，厚實堅固，防翹板與提供手指扳動抓握點)
flange_corner_r = 5.0;      // 法蘭四個外角圓角 (mm，與底座外角 R5 完全貼齊)

// ==================== 3. 內嵌防滑對位止口 (Alignment Lip) ====================
lip_enable = (print_mode == "flange_down_flat") ? false : true; // 是否啟用止口
lip_height = 1.5;           // 止口高度 (mm，嵌入底座 4mm 深度中，不干涉背後六角柱)
lip_clearance = 0.35;       // 單邊對位間隙 (mm，總間隙 0.7mm，保證滑順卡入不卡死)
lip_outer_x = 67.0 - lip_clearance * 2;   // 66.3 mm (對標底座 67.0mm 鏤空寬)
lip_outer_y = 69.75 - lip_clearance * 2;  // 69.05 mm (對標底座 69.75mm 鏤空高)
lip_corner_r = 2.2;         // 止口外角圓弧半徑 (mm)
lip_wall = 2.4;             // 止口壁厚 (mm)
lip_chamfer = 0.5;          // 止口前端 45 度導向倒角 (mm，自導向對中)

// 內部氣流通風開口尺寸
inner_open_x = lip_outer_x - lip_wall * 2; // 61.5 mm
inner_open_y = lip_outer_y - lip_wall * 2; // 64.25 mm
inner_corner_r = 1.2;

// ==================== 4. 80mm 風管接頭 (外套式) ====================
duct_od = 78.8;             // 接頭外徑 (mm，標稱 80mm 軟管輕鬆套入)
duct_wall = 2.4;            // 接頭管壁厚度 (mm，高剛性，喉箍旋緊不壓扁)
duct_id = duct_od - duct_wall * 2; // 74.0 mm 內孔徑
duct_tube_h = 26.0;         // 直管段總長度 (mm，充足空間容納 9~14mm 喉箍或束帶)

// 防滑防脫倒鉤凸緣 (Retention Barb) - 雙向 58 度溫和斜坡 (完全免支撐)
ridge_h = 1.0;              // 防脫環凸起高度 (mm，直徑由 78.8 升至 80.8mm)
ridge_ramp = 1.8;           // 爬坡過渡長度 (mm，坡度 = arctan(1.8/1.0) = 61 度 > 45度)
ridge_z = 14.0;             // 防脫環距離過渡錐頂端的距離 (mm)

// 連續氣動過渡斜錐 (Continuous Support-Free Transition)
// 高度設為 28.0mm，使四個對角的外壁斜度達 47.1 度 (大於 45 度)，兩側外壁達 72 度
transition_h = 28.0;        // 過渡錐段高度 (mm)

// ==================== 5. 6 齒彈性避讓磁鐵盲孔 (對標底座 CAD 結構) ====================
magnet_inner_d = 5.06;       // 齒面夾緊內徑 (mm，5.0mm 磁鐵緊固夾持)
magnet_outer_d = 5.90;       // 齒谷外徑 (mm，深凹槽提供強大 Z 縫避讓與微彈性)
magnet_teeth = 6;            // 6 齒彈性結構
magnet_tooth_ratio = 0.52;   // 齒寬比率
magnet_depth = 3.20;         // 磁鐵盲孔深度 (mm，微沉 0.2mm 確保永不凸出)
magnet_lead_in = 0.35;       // 入口滑入倒角 (mm)

// 磁鐵孔分佈座標 (與底座 100% 鏡像完全吻合)
magnet_corner_x = 42.0;      // 四角磁鐵 X 座標
magnet_corner_y = 42.0;      // 四角磁鐵 Y 座標
magnet_edge_x = 43.0;        // 左右側邊中點 X 座標
magnet_edge_y = 43.5;        // 上下側邊中點 Y 座標

// ==================== 基礎造型模組 ====================

// 2D 圓角矩形 (中心對齊)
module rounded_rect_2d(size_x, size_y, r) {
    hull() {
        translate([size_x/2 - r, size_y/2 - r]) circle(r = r);
        translate([-(size_x/2 - r), size_y/2 - r]) circle(r = r);
        translate([-(size_x/2 - r), -(size_y/2 - r)]) circle(r = r);
        translate([size_x/2 - r, -(size_y/2 - r)]) circle(r = r);
    }
}

// 2D 6 齒彈性避讓槽輪廓產生器
module flex_magnet_pocket_2d(d_inner, d_outer, teeth, tooth_ratio) {
    difference() {
        circle(d = d_outer);
        for (i = [0 : teeth - 1]) {
            rotate([0, 0, i * (360 / teeth)]) {
                intersection() {
                    difference() {
                        circle(d = d_outer + 0.1);
                        circle(d = d_inner);
                    }
                    let(ang = (360 / teeth) * tooth_ratio)
                    polygon([
                        [0, 0],
                        [(d_outer) * cos(-ang/2), (d_outer) * sin(-ang/2)],
                        [(d_outer) * cos(0),      (d_outer) * sin(0)],
                        [(d_outer) * cos( ang/2), (d_outer) * sin( ang/2)]
                    ]);
                }
            }
        }
    }
}

// 單個磁鐵盲孔 (由貼合面 Z=0 向上沉入)
module magnet_pocket() {
    translate([0, 0, -0.05]) {
        linear_extrude(height = magnet_depth + 0.05)
            flex_magnet_pocket_2d(magnet_inner_d, magnet_outer_d, magnet_teeth, magnet_tooth_ratio);
        cylinder(h = magnet_lead_in + 0.05, d1 = magnet_inner_d + 0.8, d2 = magnet_inner_d, $fn = 48);
    }
}

// 全部 8 顆磁鐵安裝孔群
module all_magnet_pockets() {
    translate([ magnet_corner_x,  magnet_corner_y, 0]) magnet_pocket();
    translate([-magnet_corner_x,  magnet_corner_y, 0]) magnet_pocket();
    translate([ magnet_corner_x, -magnet_corner_y, 0]) magnet_pocket();
    translate([-magnet_corner_x, -magnet_corner_y, 0]) magnet_pocket();

    translate([0,  magnet_edge_y, 0]) magnet_pocket();
    translate([0, -magnet_edge_y, 0]) magnet_pocket();
    translate([ magnet_edge_x, 0, 0]) magnet_pocket();
    translate([-magnet_edge_x, 0, 0]) magnet_pocket();
}

// 實體主結構 (基準：貼合面在 Z=0)
module duct_adapter_body() {
    difference() {
        union() {
            // (1) 外部整體外觀：由 97x97 法蘭外圍連續以 >= 47.1 度斜面收束至 78.8 圓管
            // 徹底消除水平懸空台階！
            hull() {
                translate([0, 0, 0])
                    linear_extrude(height = flange_rim_h)
                        rounded_rect_2d(frame_size_x, frame_size_y, flange_corner_r);

                translate([0, 0, flange_rim_h + transition_h])
                    linear_extrude(height = 0.01)
                        circle(d = duct_od);
            }

            // (2) 80mm 風管直管連接段
            translate([0, 0, flange_rim_h + transition_h]) {
                cylinder(h = duct_tube_h, d = duct_od);

                // 防脫倒鉤凸緣 (Retention Barb) - 雙向 58 度溫和坡度，完全免支撐
                translate([0, 0, ridge_z])
                    hull() {
                        translate([0, 0, -ridge_ramp]) cylinder(h = 0.01, d = duct_od);
                        cylinder(h = 0.8, d = duct_od + ridge_h * 2);
                        translate([0, 0, ridge_ramp + 0.8]) cylinder(h = 0.01, d = duct_od);
                    }
            }

            // (3) 內嵌防滑對位止口 (Alignment Lip，由 Z=0 向下延伸至 -lip_height)
            if (lip_enable) {
                translate([0, 0, -lip_height])
                    hull() {
                        linear_extrude(height = 0.01)
                            rounded_rect_2d(lip_outer_x - lip_chamfer*2, lip_outer_y - lip_chamfer*2, max(0.5, lip_corner_r - lip_chamfer));
                        translate([0, 0, lip_chamfer])
                            linear_extrude(height = 0.01)
                                rounded_rect_2d(lip_outer_x, lip_outer_y, lip_corner_r);
                        translate([0, 0, lip_height])
                            linear_extrude(height = 0.01)
                                rounded_rect_2d(lip_outer_x, lip_outer_y, lip_corner_r);
                    }
            }
        }

        // (4) 內部貫穿風道 (完全流暢無階梯、消除端面)
        union() {
            // 止口段
            if (lip_enable) {
                translate([0, 0, -lip_height - 1.0])
                    linear_extrude(height = lip_height + 1.01)
                        rounded_rect_2d(inner_open_x, inner_open_y, inner_corner_r);
            }

            // 錐體過渡段：方孔平順 loft 到圓孔 (斜度 >= 76 度，近乎垂直)
            hull() {
                translate([0, 0, 0])
                    linear_extrude(height = 0.01)
                        rounded_rect_2d(inner_open_x, inner_open_y, inner_corner_r);
                translate([0, 0, flange_rim_h + transition_h])
                    linear_extrude(height = 0.01)
                        circle(d = duct_id);
            }

            // 直管段風道：底端內嵌錐度引導，消除平面底蓋
            translate([0, 0, flange_rim_h + transition_h - 5.0])
                cylinder(h = 5.01, d1 = duct_id - 10.0, d2 = duct_id);

            translate([0, 0, flange_rim_h + transition_h])
                cylinder(h = duct_tube_h + 2.0, d = duct_id);
        }

        // (5) 貼合面 8 顆 6 齒彈性避讓磁鐵盲孔
        all_magnet_pockets();
    }
}

// ==================== 輸出與擺盤控制 ====================
total_model_height = flange_rim_h + transition_h + duct_tube_h;

if (print_mode == "duct_down") {
    // ★★★ 推薦列印方向：管口朝下置於熱床，全件 100% 免支撐 ★★★
    translate([0, 0, total_model_height])
        rotate([180, 0, 0])
            duct_adapter_body();
} else {
    // 法蘭朝下 (貼合面置於熱床)
    duct_adapter_body();
}
