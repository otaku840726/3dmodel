// ==============================================================================
// 專案名稱: 閃鑄 Flashforge Creator 5 Pro (C5 Pro) 專屬高剛性抗震減震底座 (V2.2 零凸台純平檯版)
// 適用五金: 8顆 Ø10mm 實心矽膠球 (中載亦可對稱裝 4 顆) ＋ 7顆 Ø8mm 軸承鋼球 (單腳配置)
// 適用耗材: 推薦 PETG (亦適用 ABS / ASA, 建議 5 圈壁厚, 35%~40% Gyroid 填充)
// 腳墊規格: 嚴格適配原廠橡膠腳錐形孔 (底部半徑 11.22mm, 頂部半徑 12.127mm, 深度 5.998mm)
// 核心升級: 
//   1. [零凸台純平檯架構] 徹底消除底座中心凸出圓環，M36 螺紋蓋完全沉入平檯齊平 (Flush Cap)，
//      杜絕任何圓柱公母配合造成的干涉與階梯卡頓感！
//   2. [空載零阻力落座] 未放矽膠球時，上托蓋可直接平放落入底座自由旋轉、輕鬆取放，零卡死。
//   3. [超寬 3.0mm 浮動間隙] 外裙邊縮徑至 76.0mm (底座內壁 82.0mm)，徑向自由浮動餘量達 3.0mm，
//      大慣量劇烈震動時絕不刮碰側壁！
// ==============================================================================

use <threads.scad>

/* [視圖模式 / View Mode] */
view_mode = "printable"; // [printable:排版打印模式(含底座+上托+螺紋蓋), assembled:完整組裝透視, cutaway:剖面透視, base_only:僅底座, top_only:僅C5Pro上托盤, cap_only:僅螺紋蓋]

/* [螺紋渲染精細度 / Thread Resolution] */
screw_resolution = 1.2;

/* [五金規格 / Hardware Specs] */
silicone_ball_dia    = 10.0; // 矽膠球直徑 (mm)
silicone_pcd         = 54.0; // 矽膠球分佈節圓直徑 (半徑 R = 27.0mm)
silicone_ball_count  = 8;    // 矽膠球碗數量 (8 碗)

steel_ball_dia       = 8.0;  // 鋼球直徑 (mm)
steel_cavity_dia     = 9.6;  // 鋼球微動阻尼腔內徑 (提供 0.8mm 徑向自由活動間隙)
steel_cavity_h       = 8.8;  // 鋼球阻尼腔高度 (8.0mm球 + 0.8mm 垂直衝擊間隙)
steel_pcd            = 21.0; // 內圈 6 顆鋼球節圓直徑 (半徑 R = 10.5mm)

/* [螺紋規格 / Thread Specs] */
thread_dia           = 36.0; // 粗牙螺紋公稱直徑 (mm)
thread_pitch         = 2.0;  // 螺距 (mm)
thread_len           = 5.5;  // 螺紋深度 (mm, 2.75 圈完整齒形)
thread_tol           = 0.4;  // 3D 打印徑向公差

/* [底座尺寸 / Base Dimensions] */
base_dia             = 90.0; // 底座外徑 (mm)
base_height          = 20.0; // 底座總高度 (mm)
platform_h           = 16.0; // 矽膠球安裝平台面高度 (mm, 平面連續無凸台)
rim_inner_dia        = 82.0; // 外防脫護圈內徑 (mm, 提供 4mm 堅固壁厚與防傾脫護圈)

cone_open_dia        = 12.0; // 45° 倒角錐坑頂部開口直徑 (mm)
cone_depth           = 5.0;  // 錐坑深度 (mm)
cone_relief_dia      = 3.0;  // 錐坑底部排氣/避空通孔直徑 (mm)

/* [Flashforge C5 Pro 原廠腳墊規格 / C5 Pro Foot Pocket Specs] */
c5_foot_r_bottom     = 11.22;  // 底部半徑 (mm, 直徑 22.44mm)
c5_foot_r_top        = 12.127; // 頂部半徑 (mm, 直徑 24.254mm)
c5_foot_depth        = 5.998;  // 孔深度 (mm)

top_dia_skirt        = 76.0;   // 上托盤下裙邊外徑 (提供 3.0mm 超寬徑向自由浮動餘量)
top_total_h          = 18.0;   // C5 Pro 上托盤總高 (mm)
top_skirt_h          = 5.0;    // 防傾裙邊高 (mm)
top_pillar_dia       = 34.0;   // 頂部圓柱外徑 (mm)
top_recess_dia       = 38.0;   // 底部中心避空槽直徑 (mm)
top_recess_depth     = 2.0;    // 底部中心避空槽深度 (mm, 浮動時提供 >4.1mm 空氣絕緣餘量)

$fn = 60;

// 45° 倒角錐坑模組
module cone_pocket() {
    cylinder(r1 = cone_open_dia/2 - cone_depth, r2 = cone_open_dia/2, h = cone_depth);
    translate([0, 0, cone_depth - 0.01])
        cylinder(r = cone_open_dia/2, h = 0.5);
    translate([0, 0, -15])
        cylinder(d = cone_relief_dia, h = 30);
}

// 零件 1: 下底座 (Lower Base) - 零凸台純平檯設計
module base_part() {
    cavity_floor_z = 1.7;
    cavity_top_z   = cavity_floor_z + steel_cavity_h; // 10.5mm
    
    color("#2c3e50")
    ScrewHole(thread_dia, platform_h - cavity_top_z + 0.1, position=[0,0,cavity_top_z], pitch=thread_pitch, tolerance=thread_tol) {
        difference() {
            cylinder(d = base_dia, h = base_height);
            
            // 外圈護圈凹槽: 形成內徑 82mm, 高度 4mm 的外護圈 (從 platform_h=16mm 到 base_height=20mm)
            translate([0, 0, platform_h])
                cylinder(d = rim_inner_dia, h = base_height - platform_h + 1);
                
            // 8 個 45° 矽膠球自定心錐形窩
            for (i = [0 : silicone_ball_count - 1]) {
                rotate([0, 0, i * 360 / silicone_ball_count])
                    translate([silicone_pcd / 2, 0, platform_h - cone_depth])
                        cone_pocket();
            }
            
            // 7 顆鋼球微動阻尼腔 (從 Z=1.7 到 Z=10.5)
            translate([0, 0, cavity_floor_z])
                cylinder(d = steel_cavity_dia, h = steel_cavity_h + 0.1);
            for (i = [0 : 5]) {
                rotate([0, 0, i * 60])
                    translate([steel_pcd / 2, 0, cavity_floor_z])
                        cylinder(d = steel_cavity_dia, h = steel_cavity_h + 0.1);
            }
            
            // 底部外圈導角 (防翹邊與美觀)
            translate([0, 0, -0.1])
                difference() {
                    cylinder(d = base_dia + 2, h = 1.5);
                    cylinder(d1 = base_dia - 2, d2 = base_dia, h = 1.5);
                }
        }
    }
}

// 零件 2: 旋入式螺紋密封蓋 (Screw-in Threaded Cap) - 齊平安裝 (Flush Cap)
module cap_part() {
    color("#7f8c8d")
    difference() {
        ScrewThread(thread_dia, thread_len, pitch=thread_pitch, tolerance=thread_tol);
        // 頂部十字旋擰槽 (深度 2.0mm)
        translate([-13, -1.5, thread_len - 2.0])
            cube([26, 3.0, 2.1]);
        translate([-1.5, -13, thread_len - 2.0])
            cube([3.0, 26, 2.1]);
        // 螺紋底端導向導角
        translate([0, 0, -0.1])
            difference() {
                cylinder(r = thread_dia/2 + 1, h = 1.0);
                cylinder(r1 = thread_dia/2 - 2.0, r2 = thread_dia/2, h = 1.0);
            }
    }
}

// 零件 3: Flashforge C5 Pro 專屬上托盤 (Upper Top Cup)
module c5_top_part() {
    color("#34495e")
    difference() {
        union() {
            cylinder(d = top_dia_skirt, h = top_skirt_h);
            cylinder(d = top_pillar_dia, h = top_total_h);
            translate([0, 0, top_skirt_h])
                cylinder(d1 = top_dia_skirt, d2 = top_pillar_dia, h = 4.0);
        }
        
        // 8 個倒置矽膠球錐坑
        for (i = [0 : silicone_ball_count - 1]) {
            rotate([0, 0, i * 360 / silicone_ball_count])
                translate([silicone_pcd / 2, 0, cone_depth])
                    rotate([180, 0, 0])
                        cone_pocket();
        }
        
        // 底部中心避空槽 (直徑 38mm, 深 2.0mm)
        translate([0, 0, -0.1])
            cylinder(d = top_recess_dia, h = top_recess_depth + 0.1);
            
        // Flashforge C5 Pro 原廠錐形腳墊限位孔
        translate([0, 0, top_total_h - c5_foot_depth])
            cylinder(r1 = c5_foot_r_bottom, r2 = c5_foot_r_top, h = c5_foot_depth + 0.1);
            
        // 孔口導向導角 (0.8mm)
        translate([0, 0, top_total_h - 0.8])
            cylinder(r1 = c5_foot_r_top, r2 = c5_foot_r_top + 1.2, h = 0.9);
            
        // 中心排氣/頂出通孔
        translate([0, 0, -1])
            cylinder(d = 4.0, h = top_total_h + 2);
    }
}

// 裝配體五金
module assembled_hardware() {
    color("#e67e22")
    for (i = [0 : silicone_ball_count - 1]) {
        rotate([0, 0, i * 360 / silicone_ball_count])
            translate([silicone_pcd / 2, 0, 17.071])
                sphere(d = silicone_ball_dia);
    }
    
    color("#bdc3c7") {
        translate([0, 0, 1.7 + steel_cavity_h / 2])
            sphere(d = steel_ball_dia);
        for (i = [0 : 5]) {
            rotate([0, 0, i * 60])
                translate([steel_pcd / 2, 0, 1.7 + steel_cavity_h / 2])
                    sphere(d = steel_ball_dia);
        }
    }
}

// 主渲染邏輯
if (view_mode == "printable") {
    translate([-base_dia/2 - 8, 0, 0])
        base_part();
    translate([base_dia/2 + 8, 0, top_total_h])
        rotate([180, 0, 0])
            c5_top_part();
    translate([0, base_dia/2 + 25, 0])
        cap_part();
} else if (view_mode == "base_only") {
    base_part();
} else if (view_mode == "top_only") {
    c5_top_part();
} else if (view_mode == "cap_only") {
    cap_part();
} else if (view_mode == "assembled") {
    base_part();
    translate([0, 0, 10.5])
        cap_part();
    translate([0, 0, 18.142])
        c5_top_part();
    assembled_hardware();
} else if (view_mode == "cutaway") {
    difference() {
        union() {
            base_part();
            translate([0, 0, 10.5])
                cap_part();
            translate([0, 0, 18.142])
                c5_top_part();
            assembled_hardware();
        }
        translate([-base_dia, -base_dia*2, -5])
            cube([base_dia*2, base_dia*2, base_dia*2]);
    }
}
