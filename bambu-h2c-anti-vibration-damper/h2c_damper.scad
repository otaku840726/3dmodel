// ==============================================================================
// 專案名稱: 拓竹 Bambu Lab H2C (35kg 重型 CoreXY) 專屬高剛性減震腳座 (V2.1 實體公制螺紋版)
// 適用五金: 8顆 Ø10mm 實心矽膠球 ＋ 7顆 Ø8mm 軸承鋼球 (單腳配置)
// 適用耗材: 推薦 PETG (亦適用 ABS / ASA, 建議 5 圈壁厚, 35%~40% Gyroid 填充)
// 核心升級: 100% 實體 M36x2.0 內/外螺紋，旋入式後裝密封，全程免暫停、零廢件風險！
// 檔案格式: OpenSCAD (支援 Customizer 參數自訂面板)
// ==============================================================================

use <threads.scad>

/* [視圖模式 / View Mode] */
view_mode = "printable"; // [printable:排版打印模式(含底座+上托+螺紋蓋), assembled:完整組裝透視, cutaway:剖面透視, base_only:僅底座, top_only:僅上托盤, cap_only:僅螺紋蓋]

/* [螺紋渲染精細度 / Thread Resolution] */
screw_resolution = 1.2; // 螺紋網格解析度 (mm, 推薦 1.0~1.2，兼顧快速編譯與高光順度)

/* [五金規格 / Hardware Specs] */
silicone_ball_dia    = 10.0; // 矽膠球直徑 (mm)
silicone_pcd         = 54.0; // 矽膠球分佈節圓直徑 (半徑 R = 27.0mm)
silicone_ball_count  = 8;    // 矽膠球數量 (8 顆等角度分佈)

steel_ball_dia       = 8.0;  // 鋼球直徑 (mm)
steel_cavity_dia     = 9.6;  // 鋼球微動阻尼腔內徑 (提供 0.8mm 徑向自由活動間隙)
steel_cavity_h       = 8.8;  // 鋼球阻尼腔高度 (8.0mm球 + 0.8mm 垂直非彈性碰撞間隙)
steel_pcd            = 21.0; // 內圈 6 顆鋼球節圓直徑 (半徑 R = 10.5mm，完整避讓螺紋根部)

/* [螺紋規格 / Thread Specs] */
thread_dia           = 36.0; // 粗牙螺紋公稱直徑 (mm)
thread_pitch         = 2.0;  // 螺距 (mm)
thread_len           = 5.5;  // 螺紋深度 (mm, 2.75 圈完整齒形)
thread_tol           = 0.4;  // 3D 打印徑向公差 (PETG 順暢旋合不卡滯)

/* [底座尺寸 / Base Dimensions] */
base_dia             = 90.0; // 底座外徑 (mm)
base_height          = 18.0; // 底座總高度 (mm)
platform_h           = 14.0; // 矽膠球安裝平台面高度 (mm)
collar_dia           = 40.0; // 中心螺紋凸台外徑 (mm)
collar_h             = 16.0; // 中心螺紋凸台高度 (mm, 保證 5.5mm 深牙)
cone_open_dia        = 12.0; // 45° 倒角錐坑頂部開口直徑 (mm)
cone_depth           = 5.0;  // 錐坑深度 (mm)
cone_relief_dia      = 3.0;  // 錐坑底部排氣/避空通孔直徑 (mm)

/* [上托蓋與 H2C 原廠腳配合 / Top Cup Dimensions] */
top_dia_skirt        = 78.8; // 上托盤下裙邊外徑 (配合底座 80mm 內壁，提供 0.6mm 安全防傾間隙)
top_total_h          = 26.0; // 上托盤總高度 (mm)
top_skirt_h          = 6.0;  // 防傾裙邊高度 (mm)
top_recess_dia       = 40.0; // 底部中心螺紋蓋避空沈頭槽直徑 (mm)
top_recess_depth     = 4.5;  // 底部中心避空槽深度 (mm, 提供 >3.6mm 動態安全餘隙)
h2c_foot_dia         = 34.0; // H2C 原廠避震橡膠腳限位槽內徑 (留 0.3mm 裝配公差)
h2c_foot_depth       = 14.0; // H2C 原廠腳限位槽深度 (mm)
h2c_screw_relief_dia = 14.0; // 原廠中心 M3 螺栓墊片避空槽直徑 (mm)
h2c_screw_relief_h   = 2.5;  // 墊片避空槽深度 (mm)
h2c_center_hole_dia  = 4.0;  // 中心穿孔直徑 (mm)

/* [渲染解析度 / Mesh Quality] */
$fn = 60;

// 45° 倒角錐形球窩模組
module cone_pocket() {
    cylinder(r1 = cone_open_dia/2 - cone_depth, r2 = cone_open_dia/2, h = cone_depth);
    translate([0, 0, cone_depth - 0.01])
        cylinder(r = cone_open_dia/2, h = 0.5);
    translate([0, 0, -15])
        cylinder(d = cone_relief_dia, h = 30);
}

// 零件 1: 下底座 (Lower Base)
module base_part() {
    cavity_floor_z = 1.7;
    cavity_top_z   = cavity_floor_z + steel_cavity_h; // 1.7 + 8.8 = 10.5mm
    
    color("#2c3e50")
    ScrewHole(thread_dia, collar_h - cavity_top_z + 0.1, position=[0,0,cavity_top_z], pitch=thread_pitch, tolerance=thread_tol) {
        difference() {
            cylinder(d = base_dia, h = base_height);
            
            translate([0, 0, platform_h])
                difference() {
                    cylinder(d = 80.0, h = base_height - platform_h + 1);
                    cylinder(d = collar_dia, h = base_height - platform_h + 2);
                }
                
            translate([0, 0, collar_h])
                cylinder(d = collar_dia, h = base_height - collar_h + 1);
                
            for (i = [0 : silicone_ball_count - 1]) {
                rotate([0, 0, i * 360 / silicone_ball_count])
                    translate([silicone_pcd / 2, 0, platform_h - cone_depth])
                        cone_pocket();
            }
            
            translate([0, 0, cavity_floor_z])
                cylinder(d = steel_cavity_dia, h = steel_cavity_h + 0.1);
            for (i = [0 : 5]) {
                rotate([0, 0, i * 60])
                    translate([steel_pcd / 2, 0, cavity_floor_z])
                        cylinder(d = steel_cavity_dia, h = steel_cavity_h + 0.1);
            }
            
            translate([0, 0, -0.1])
                difference() {
                    cylinder(d = base_dia + 2, h = 1.5);
                    cylinder(d1 = base_dia - 2, d2 = base_dia, h = 1.5);
                }
        }
    }
}

// 零件 2: 旋入式螺紋密封蓋 (Screw-in Threaded Cap)
module cap_part() {
    color("#7f8c8d")
    difference() {
        ScrewThread(thread_dia, thread_len, pitch=thread_pitch, tolerance=thread_tol);
        
        translate([-13, -1.5, thread_len - 2.0])
            cube([26, 3.0, 2.1]);
            
        translate([-1.5, -13, thread_len - 2.0])
            cube([3.0, 26, 2.1]);
            
        translate([0, 0, -0.1])
            difference() {
                cylinder(r = thread_dia/2 + 1, h = 1.0);
                cylinder(r1 = thread_dia/2 - 2.0, r2 = thread_dia/2, h = 1.0);
            }
    }
}

// 零件 3: 上托盤 (Upper Top Cup)
module top_part() {
    color("#34495e")
    difference() {
        union() {
            cylinder(d = top_dia_skirt, h = top_skirt_h);
            cylinder(d = 44.0, h = top_total_h);
            translate([0, 0, top_skirt_h])
                cylinder(d1 = top_dia_skirt, d2 = 44.0, h = 5.0);
        }
        
        for (i = [0 : silicone_ball_count - 1]) {
            rotate([0, 0, i * 360 / silicone_ball_count])
                translate([silicone_pcd / 2, 0, cone_depth])
                    rotate([180, 0, 0])
                        cone_pocket();
        }
        
        translate([0, 0, -0.1])
            cylinder(d = top_recess_dia, h = top_recess_depth + 0.1);
            
        translate([0, 0, top_total_h - h2c_foot_depth])
            cylinder(d = h2c_foot_dia, h = h2c_foot_depth + 2);
            
        translate([0, 0, top_total_h - 1.5])
            cylinder(d1 = h2c_foot_dia, d2 = h2c_foot_dia + 3.0, h = 2.0);
            
        translate([0, 0, top_total_h - h2c_foot_depth - h2c_screw_relief_h])
            cylinder(d = h2c_screw_relief_dia, h = h2c_screw_relief_h + 0.1);
            
        translate([0, 0, -1])
            cylinder(d = h2c_center_hole_dia, h = top_total_h + 2);
    }
}

// 裝配體五金
module assembled_hardware() {
    color("#e67e22")
    for (i = [0 : silicone_ball_count - 1]) {
        rotate([0, 0, i * 360 / silicone_ball_count])
            translate([silicone_pcd / 2, 0, platform_h - cone_depth/2 + 1.0])
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
            top_part();
    translate([0, base_dia/2 + 25, 0])
        cap_part();
} else if (view_mode == "base_only") {
    base_part();
} else if (view_mode == "top_only") {
    top_part();
} else if (view_mode == "cap_only") {
    cap_part();
} else if (view_mode == "assembled") {
    base_part();
    translate([0, 0, 10.5])
        cap_part();
    translate([0, 0, 16.0])
        top_part();
    assembled_hardware();
} else if (view_mode == "cutaway") {
    difference() {
        union() {
            base_part();
            translate([0, 0, 10.5])
                cap_part();
            translate([0, 0, 16.0])
                top_part();
            assembled_hardware();
        }
        translate([-base_dia, -base_dia*2, -5])
            cube([base_dia*2, base_dia*2, base_dia*2]);
    }
}
