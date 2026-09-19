// ==============================================================================
// 專案名稱: 牆面排風網罩 - 磁吸式轉接底座 (Magnetic Exhaust Base Mount)
// 設計用途: 用於安裝在六角蜂巢孔排風牆面上，透過六角柱精準定位並固定。
//           底面配置 8 顆 5x3 圓形磁鐵 (帶 6 齒彈性避讓槽)，提供高氣密性磁吸法蘭，
//           便於後續快速更換、磁吸安裝各式排風管與擴充配件。
// 建議列印材質: PETG / ABS / ASA (耐溫耐候)
// ==============================================================================

$fn = 48;

// ==================== 1. 幾何基礎與鏤空參數 ====================
frame_size_x = 97.0;        // 底座外框 X 邊長 (mm)
frame_size_y = 97.0;        // 底座外框 Y 邊長 (mm)
base_thickness = 4.0;       // 六角柱底板厚度 (4.0 mm)

// 底座圓角與底部防象腳倒角參數
base_corner_radius = 5.0;       // 底座四個外角圓弧半徑 (mm)，消除尖角應力集中防止 3D 列印翹板
base_inner_corner_radius = 2.5; // 底座內部四個凹角圓弧半徑 (mm)，消除應力集中防裂、平順列印噴頭路徑
base_bottom_chamfer = 1.0;      // 最底部外圈微縮倒角高度與寬度 (mm)

// 底座中央鏤空尺寸 (向內延伸 3mm 徹底承托柱腳)
base_extend_inward_x = 3.0; // X 軸底板向內延伸量 (mm)
base_inner_gap_x = 73.0 - (base_extend_inward_x * 2); // 67.0 mm
base_inner_gap_y = 69.75;   // 底座上下鏤空淨距 (Y 軸) (mm)

// ==================== 2. 六角柱尺寸與容差參數 ====================
hex_flat_nominal = 2.53;    // 原始標準對邊寬度 (mm，原始排風孔尺寸 2.53 mm)
hex_print_tolerance = 0.03; // 3D 列印縮小容差 (mm，實測 0.03 mm 最佳，實際柱寬 2.50 mm)

hex_height = 2.5;           // 柱高 (mm)
hex_top_chamfer = 0.4;      // 柱頂導入導角高度 (mm，方便 56 根柱子輕鬆對位插入孔洞)

// 六角柱陣列數量 (包含既有角柱)
posts_count_x = 11;         // 上下側總柱數 (含兩端角柱共 11 個，10 個間隔)
posts_count_y = 19;         // 左右側總柱數 (含兩端角柱共 19 個，18 個間隔)

// ==================== 3. 柱距與跨距參數 ====================
post_center_dist_x = 73.9214; // 上下側 (X 軸) 固定跨距 (mm)
post_pitch_y = 4.314;         // 左右側 (Y 軸) 精確柱距 (mm，對應總跨距約 77.65 mm，修正 0.9mm 累積誤差)
post_center_dist_y = post_pitch_y * (posts_count_y - 1);

// 實際列印柱寬 = 原始尺寸 (2.53) - 列印容差 (0.03) = 2.50 mm
hex_flat_to_flat = hex_flat_nominal - hex_print_tolerance;
hex_r_inner = hex_flat_to_flat / 2;
hex_r_outer = hex_r_inner / cos(30);

// ==================== 4. 6齒彈性容差磁鐵孔 (對標 CAD 結構，專門解決 Z 縫卡死) ====================
magnet_diameter = 5.0;       // 磁鐵標稱直徑 (mm，規格 5x3)
magnet_thickness = 3.0;      // 磁鐵標稱厚度 (mm，規格 5x3)

// ★★★ 6 齒彈性容差槽參數 ★★★
// 原理：孔壁由 6 個獨立內凸齒構成，齒間留有深槽。
// 磁鐵壓入時僅接觸 6 個齒面並產生彈性微形變，Z 縫與多餘塑料完全落入深槽中，手壓即可入座！
magnet_inner_d = 5.06;       // 齒面接觸內徑 (mm，微過盈夾緊磁鐵)
magnet_outer_d = 5.90;       // 齒谷外徑 (mm，深凹槽提供強大的避讓空間與彈性形變量)
magnet_teeth = 6;            // 齒數 (6 齒)
magnet_tooth_ratio = 0.52;   // 齒寬比例 (約 31 度齒寬，29 度避讓槽)
magnet_hole_depth = 3.20;    // 盲孔總深度 (mm，微沉 0.2mm 確保不凸出)
magnet_lead_in = 0.35;       // 入口導引斜角 (mm，引導磁鐵滑順對中)

magnet_count_mode = 8;       // 磁鐵配置: 8 (4角落+4邊中點，氣密性最佳) 或 4 (僅4角落)

// 磁鐵分佈座標
magnet_corner_x = 42.0; // 四角磁鐵 X 座標
magnet_corner_y = 42.0; // 四角磁鐵 Y 座標
magnet_edge_x = 43.0;   // 左右側邊中點磁鐵 X 座標
magnet_edge_y = 43.5;   // 上下側邊中點磁鐵 Y 座標

// ==================== 基礎模組 ====================
// 2D 圓角矩形 (以中心對齊)
module rounded_rect_2d(size_x, size_y, r) {
    hull() {
        translate([size_x/2 - r, size_y/2 - r]) circle(r = r);
        translate([-(size_x/2 - r), size_y/2 - r]) circle(r = r);
        translate([-(size_x/2 - r), -(size_y/2 - r)]) circle(r = r);
        translate([size_x/2 - r, -(size_y/2 - r)]) circle(r = r);
    }
}

// 2D 6齒彈性容差輪廓產生器
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

// 六角柱：相鄰柱在橫向(上下側)頂角對頂角，在縱向(左右側)邊對邊
module hex_post() {
    if (hex_top_chamfer > 0) {
        hull() {
            cylinder(h = hex_height - hex_top_chamfer, r = hex_r_outer, $fn = 6);
            translate([0, 0, hex_height - 0.01])
                cylinder(h = 0.01, r = max(0.5, hex_r_outer - (hex_top_chamfer * 0.7)), $fn = 6);
        }
    } else {
        cylinder(h = hex_height, r = hex_r_outer, $fn = 6, center = false);
    }
}

// 6齒彈性容差磁鐵盲孔 (由底面 Z=0 向上沉入)
module magnet_pocket() {
    translate([0, 0, -0.1]) {
        // 6 齒彈性槽主體
        linear_extrude(height = magnet_hole_depth + 0.1)
            flex_magnet_pocket_2d(magnet_inner_d, magnet_outer_d, magnet_teeth, magnet_tooth_ratio);

        // 入口處導引喇叭斜角 (在齒面上切出 0.35mm 斜角，一推就順滑進入)
        cylinder(h = magnet_lead_in + 0.1, d1 = magnet_inner_d + 0.8, d2 = magnet_inner_d, $fn = 48);
    }
}

// 全部磁鐵安裝孔組群
module all_magnet_pockets() {
    // 4 個角落磁鐵
    translate([ magnet_corner_x,  magnet_corner_y, 0]) magnet_pocket();
    translate([-magnet_corner_x,  magnet_corner_y, 0]) magnet_pocket();
    translate([ magnet_corner_x, -magnet_corner_y, 0]) magnet_pocket();
    translate([-magnet_corner_x, -magnet_corner_y, 0]) magnet_pocket();

    // 4 個邊緣中點磁鐵 (氣密壓緊)
    if (magnet_count_mode == 8) {
        translate([0,  magnet_edge_y, 0]) magnet_pocket();
        translate([0, -magnet_edge_y, 0]) magnet_pocket();
        translate([ magnet_edge_x, 0, 0]) magnet_pocket();
        translate([-magnet_edge_x, 0, 0]) magnet_pocket();
    }
}

// 全部六角柱陣列 (上下側各 11 根，左右側各 19 根)
module all_hex_posts() {
    // 上下側：每側 11 個 (含四個角落，相鄰柱頂角對頂角)
    for (i = [0 : posts_count_x - 1]) {
        x = -post_center_dist_x / 2 + i * (post_center_dist_x / (posts_count_x - 1));
        translate([x, post_center_dist_y / 2, 0]) hex_post();
        translate([x, -post_center_dist_y / 2, 0]) hex_post();
    }

    // 左右側：每側中間各 17 個 (不重複生成四個角落，相鄰柱邊對邊)
    for (j = [1 : posts_count_y - 2]) {
        y = -post_center_dist_y / 2 + j * (post_center_dist_y / (posts_count_y - 1));
        translate([-post_center_dist_x / 2, y, 0]) hex_post();
        translate([post_center_dist_x / 2, y, 0]) hex_post();
    }
}

// ==================== 底座盒組件 ====================
module base_part() {
    union() {
        // (1) 4mm 厚度圓角底盒主體 (四外角圓弧防翹板 + 最底部 Z: 0~1mm 防象腳倒角)
        difference() {
            hull() {
                // 最底面 (Z=0) 微縮 1.0mm
                translate([0, 0, 0])
                    linear_extrude(height = 0.01)
                        rounded_rect_2d(frame_size_x - base_bottom_chamfer * 2,
                                        frame_size_y - base_bottom_chamfer * 2,
                                        max(0.1, base_corner_radius - base_bottom_chamfer));

                // 過渡到標準尺寸 (Z = base_bottom_chamfer)
                translate([0, 0, base_bottom_chamfer])
                    linear_extrude(height = 0.01)
                        rounded_rect_2d(frame_size_x, frame_size_y, base_corner_radius);

                // 頂部標準尺寸 (Z = base_thickness)
                translate([0, 0, base_thickness - 0.01])
                    linear_extrude(height = 0.01)
                        rounded_rect_2d(frame_size_x, frame_size_y, base_corner_radius);
            }

            // 底座中央貫穿通風鏤空 (內部四角圓弧化)
            translate([0, 0, -0.5])
                linear_extrude(height = base_thickness + 1.0)
                    rounded_rect_2d(base_inner_gap_x, base_inner_gap_y, base_inner_corner_radius);

            // 底面 6 齒彈性容差磁鐵盲孔 (對標 CAD 原圖結構，避讓 Z 縫)
            all_magnet_pockets();
        }

        // (2) 全部六角柱 (Z: 4.0 ~ 6.5 mm)
        translate([0, 0, base_thickness])
            all_hex_posts();
    }
}

// ==================== 輸出 ====================
base_part();
