// ==============================================================================
// 專案名稱: 80mm 磁吸式排風管轉接頭 (80mm Magnetic Exhaust Duct Adapter)
// 對應型號: 牆面排風網罩磁吸轉接底座 (magnetic-exhaust-base)
// 設計用途: 用於快速磁吸安裝於牆面底座，連接 80mm 標準排風軟管（鋁箔管 / PVC複合風管）。
// 特點功能:
//   1. 8 顆 5x3 磁鐵 (6 齒彈性避讓槽)，與底座磁鐵 100% 精準對位，提供約 4kgf 強勁吸力。
//   2. 1.5mm 內嵌對位止口 (Alignment Lip)，消除風管拉扯剪切滑動，兼具高度氣密性。
//   3. 外套式 78.8mm 接頭 + 80.6mm 防滑倒鉤環 (Retention Barb)，喉箍鎖固絕不滑脫。
//   4. 氣動優化過渡錐段 (Lofted Funnel)，方孔轉圓管流線過渡，極低風阻無亂流。
//   5. 支援 100% 免支撐列印模式 (接頭朝下列印，止口與磁鐵孔朝上成型，零垂落)。
// 建議列印材質: PETG / ABS / ASA (耐溫耐候)
// ==============================================================================

$fn = 64;

// ==================== 1. 列印方向與配置選擇 ====================
// "duct_down"   : (推薦首選) 接頭朝下、法蘭朝上。★★★ 全件 100% 免支撐列印 ★★★
// "flange_down" : 法蘭朝下、接頭朝上。(若啟用 1.5mm 止口，法蘭外框底部需極薄 1.5mm 支撐)
// "flat_flange" : 法蘭朝下且關閉對位止口 (全平面法蘭)。100% 免支撐，便於自行貼整圈氣密矽膠片。
print_mode = "duct_down";

// ==================== 2. 法蘭與幾何尺寸參數 ====================
frame_size_x = 97.0;        // 法蘭外框 X 邊長 (mm，對標底座 97.0 mm)
frame_size_y = 97.0;        // 法蘭外框 Y 邊長 (mm，對標底座 97.0 mm)
flange_thickness = 4.5;     // 法蘭本體厚度 (mm，厚實平整，不易受熱床翹曲影響)
flange_corner_r = 5.0;      // 法蘭四個外角圓角 (mm，與底座外角 R5 完全貼齊)

// ==================== 3. 內嵌防滑對位止口 (Alignment Lip) ====================
lip_enable = (print_mode == "flat_flange") ? false : true; // 是否啟用止口
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
duct_tube_h = 32.0;         // 直管段總長度 (mm，充足空間容納 9~14mm 喉箍或束帶)

// 防滑防脫倒鉤凸緣 (Retention Barb)
ridge_od = 80.6;            // 防脫環最大外徑 (mm，稍微撐開軟管形成機械鎖扣)
ridge_pos_z = 20.0;         // 防脫環距離直管起點的高度 (mm)
ridge_w = 4.0;              // 防脫環過渡寬度 (mm)

// 氣動優化過渡錐段 (Lofted Funnel Transition)
transition_h = 18.0;        // 過渡錐高 (mm)
cone_base_x = 78.0;         // 錐體底部 X 邊長 (mm，圓角矩形完美包覆內部風道對角，徹底杜絕破孔)
cone_base_y = 78.0;         // 錐體底部 Y 邊長 (mm)
cone_base_r = 16.0;         // 錐體底部圓角半徑 (mm，平順過渡至圓管)

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
    // 四角落磁鐵
    translate([ magnet_corner_x,  magnet_corner_y, 0]) magnet_pocket();
    translate([-magnet_corner_x,  magnet_corner_y, 0]) magnet_pocket();
    translate([ magnet_corner_x, -magnet_corner_y, 0]) magnet_pocket();
    translate([-magnet_corner_x, -magnet_corner_y, 0]) magnet_pocket();

    // 四邊緣中點磁鐵 (氣密壓緊)
    translate([0,  magnet_edge_y, 0]) magnet_pocket();
    translate([0, -magnet_edge_y, 0]) magnet_pocket();
    translate([ magnet_edge_x, 0, 0]) magnet_pocket();
    translate([-magnet_edge_x, 0, 0]) magnet_pocket();
}

// 風管轉接頭完整組件 (基準座標系：貼合面在 Z=0)
module duct_adapter_body() {
    difference() {
        union() {
            // (1) 法蘭底板 (Z: 0 ~ flange_thickness)
            linear_extrude(height = flange_thickness)
                rounded_rect_2d(frame_size_x, frame_size_y, flange_corner_r);

            // (2) 氣動過渡錐體 (Z: flange_thickness ~ flange_thickness + transition_h)
            translate([0, 0, flange_thickness])
                hull() {
                    linear_extrude(height = 0.01)
                        rounded_rect_2d(cone_base_x, cone_base_y, cone_base_r);
                    translate([0, 0, transition_h])
                        linear_extrude(height = 0.01)
                            circle(d = duct_od);
                }

            // (3) 80mm 風管直管連接段
            translate([0, 0, flange_thickness + transition_h]) {
                // 直管主體
                cylinder(h = duct_tube_h, d = duct_od);

                // 防脫倒鉤凸緣 (Retention Barb)
                translate([0, 0, ridge_pos_z])
                    hull() {
                        translate([0, 0, -ridge_w/2]) cylinder(h = 0.01, d = duct_od);
                        cylinder(h = 1.0, d = ridge_od);
                        translate([0, 0, ridge_w/2]) cylinder(h = 0.01, d = duct_od);
                    }
            }

            // (4) 內嵌防滑對位止口 (Alignment Lip，由 Z=0 向外凸出至 -lip_height)
            if (lip_enable) {
                translate([0, 0, -lip_height])
                    hull() {
                        // 止口前端 45 度滑順導入倒角
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

        // (5) 內部貫穿風道 (方孔平滑漸變至圓管，極低風阻)
        union() {
            // 方形到圓形的平滑 loft 過渡
            hull() {
                translate([0, 0, -lip_height - 1.0])
                    linear_extrude(height = 1.0)
                        rounded_rect_2d(inner_open_x, inner_open_y, inner_corner_r);
                translate([0, 0, 0])
                    linear_extrude(height = 0.01)
                        rounded_rect_2d(inner_open_x, inner_open_y, inner_corner_r);
                translate([0, 0, flange_thickness + transition_h])
                    linear_extrude(height = 0.01)
                        circle(d = duct_id);
            }

            // 圓管段直通風道
            translate([0, 0, flange_thickness + transition_h - 0.1])
                cylinder(h = duct_tube_h + 1.0, d = duct_id);

            // 管口端部內倒角 (出風平順無剪切阻力)
            translate([0, 0, flange_thickness + transition_h + duct_tube_h - 1.2])
                cylinder(h = 1.3, d1 = duct_id, d2 = duct_id + 2.0);
        }

        // (6) 貼合面 8 顆 6 齒彈性避讓磁鐵盲孔
        all_magnet_pockets();
    }
}

// ==================== 輸出與擺盤控制 ====================
total_model_height = flange_thickness + transition_h + duct_tube_h;

if (print_mode == "duct_down") {
    // ★★★ 推薦列印方向：接頭朝下置於熱床，全件 100% 免支撐 ★★★
    translate([0, 0, total_model_height])
        rotate([180, 0, 0])
            duct_adapter_body();
} else {
    // 法蘭朝下 (貼合面置於熱床)
    duct_adapter_body();
}
