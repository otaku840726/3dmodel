// ==============================================================================
// 專案名稱: 拓竹 Bambu Lab H2C (35kg 重型 CoreXY) 專屬高剛性減震腳座
// 適用五金: 8顆 Ø10mm 實心矽膠球 ＋ 7顆 Ø8mm 軸承鋼球 (單腳配置)
// 適用耗材: 推薦 PETG / ABS / ASA (建議 5 圈壁厚, 35%~40% Gyroid 填充)
// 檔案格式: OpenSCAD (支援 Customizer 參數自訂面板)
// ==============================================================================

/* [視圖模式 / View Mode] */
// 請選擇當前顯示模式
view_mode = "printable"; // [printable:打印排版(無支撐), assembled:完整組裝透視, cutaway:剖面透視, base_only:僅底座, top_only:僅上托盤]

/* [五金規格 / Hardware Specs] */
silicone_ball_dia    = 10.0; // 矽膠球直徑 (mm)
silicone_pcd         = 54.0; // 矽膠球分佈節圓直徑 (半徑 R = 27.0mm)
silicone_ball_count  = 8;    // 矽膠球數量 (8 顆等角度分佈)

steel_ball_dia       = 8.0;  // 鋼球直徑 (mm)
steel_cavity_dia     = 9.6;  // 鋼球微動阻尼腔內徑 (提供 0.8mm 徑向自由活動間隙)
steel_cavity_h       = 10.5; // 鋼球阻尼腔高度 (mm)
steel_pcd            = 76.0; // 外圈鋼球分佈節圓直徑 (半徑 R = 38.0mm)
enable_center_steel  = true; // 是否啟用中心第 7 顆鋼球腔 (true=啟用, false=僅外圈6顆)

/* [底座尺寸 / Base Dimensions] */
base_dia             = 90.0; // 底座外徑 (mm)
base_height          = 18.0; // 底座總高度 (mm)
platform_h           = 14.0; // 矽膠球安裝平台面高度 (mm)
cone_open_dia        = 12.0; // 45° 倒角錐坑頂部開口直徑 (mm)
cone_depth           = 5.0;  // 錐坑深度 (mm)
cone_relief_dia      = 3.0;  // 錐坑底部排氣/避空通孔直徑 (mm)

/* [上托蓋與 H2C 原廠腳配合 / Top Cup Dimensions] */
top_dia_skirt        = 78.8; // 上托盤下裙邊外徑 (配合底座 80mm 內壁，提供 0.6mm 安全防傾間隙)
top_total_h          = 26.0; // 上托盤總高度 (mm)
top_skirt_h          = 6.0;  // 防傾裙邊高度 (mm)
h2c_foot_dia         = 34.0; // H2C 原廠避震橡膠腳限位槽內徑 (留 0.3mm 裝配公差)
h2c_foot_depth       = 14.0; // H2C 原廠腳限位槽深度 (mm)
h2c_screw_relief_dia = 14.0; // 原廠中心 M3 螺栓墊片避空槽直徑 (mm)
h2c_screw_relief_h   = 2.5;  // 墊片避空槽深度 (mm)
h2c_center_hole_dia  = 4.0;  // 中心穿孔直徑 (mm)

/* [渲染解析度 / Mesh Quality] */
$fn = 100; // 圓弧細分面數

// ==============================================================================
// 基礎子模組 (Sub-modules)
// ==============================================================================

// 45° 倒角錐形球窩模組 (含消除 CSG 共面偽影的過切處理)
module cone_pocket() {
    // 錐孔部分 (頂大底小，單側 45° 斜坡)
    cylinder(r1 = cone_open_dia/2 - cone_depth, r2 = cone_open_dia/2, h = cone_depth);
    // 開口處延伸 0.2mm 圓柱過切，徹底消除布爾運算共面微薄膜
    translate([0, 0, cone_depth - 0.01])
        cylinder(r = cone_open_dia/2, h = 0.5);
    // 底部排氣/落塵/避空貫穿孔
    translate([0, 0, -15])
        cylinder(d = cone_relief_dia, h = 30);
}

// 下底座 (Lower Base)
module base_part() {
    color("#2c3e50")
    difference() {
        // 1. 底座主體外形
        cylinder(d = base_dia, h = base_height);
        
        // 2. 內凹平台與防傾保護唇 (形成 4mm 高、內徑 80mm 的環形剛性唇)
        translate([0, 0, platform_h])
            cylinder(d = 80.0, h = base_height - platform_h + 1);
            
        // 3. 8 處 45° 倒角矽膠球錐坑 (呈 45° 等角度圓周分佈)
        for (i = [0 : silicone_ball_count - 1]) {
            rotate([0, 0, i * 360 / silicone_ball_count])
                translate([silicone_pcd / 2, 0, platform_h - cone_depth])
                    cone_pocket();
        }
        
        // 4. 鋼球微動顆粒阻尼腔 (底厚 1.8mm, 腔高 10.5mm, 頂部實心封閉層 1.7mm)
        // (在 3D 打印到 Z = 12.3mm 時暫停，放入鋼球後繼續打印封頂)
        // 中心第 1 顆鋼球腔
        if (enable_center_steel) {
            translate([0, 0, 1.8])
                cylinder(d = steel_cavity_dia, h = steel_cavity_h);
        }
        
        // 外圈 6 顆鋼球腔 (呈 60° 等角度圓周分佈，錯開矽膠球工位)
        for (i = [0 : 5]) {
            rotate([0, 0, 30 + i * 60])
                translate([steel_pcd / 2, 0, 1.8])
                    cylinder(d = steel_cavity_dia, h = steel_cavity_h);
        }
        
        // 5. 底部防滑腳倒角 (1.5mm 邊緣倒角，減少應力集中)
        translate([0, 0, -0.1])
            difference() {
                cylinder(d = base_dia + 2, h = 1.5);
                cylinder(d1 = base_dia - 2, d2 = base_dia, h = 1.5);
            }
    }
}

// 上托盤 (Upper Top Cup)
module top_part() {
    color("#34495e")
    difference() {
        // 1. 上托盤外形 (階梯裙邊 + 套筒主柱)
        union() {
            // 下部防傾裙邊
            cylinder(d = top_dia_skirt, h = top_skirt_h);
            // 上部剛性套筒柱體
            cylinder(d = 44.0, h = top_total_h);
            // 裙邊至柱體的平滑過渡加強錐面
            translate([0, 0, top_skirt_h])
                cylinder(d1 = top_dia_skirt, d2 = 44.0, h = 5.0);
        }
        
        // 2. 底部 8 處對稱 45° 錐孔 (朝下開口)
        for (i = [0 : silicone_ball_count - 1]) {
            rotate([0, 0, i * 360 / silicone_ball_count])
                translate([silicone_pcd / 2, 0, cone_depth])
                    rotate([180, 0, 0])
                        cone_pocket();
        }
        
        // 3. 頂部 H2C 原廠避震橡膠腳緊固套筒
        translate([0, 0, top_total_h - h2c_foot_depth])
            cylinder(d = h2c_foot_dia, h = h2c_foot_depth + 2);
            
        // 4. 套筒頂緣導角 (1.5mm 喇叭口導角，利於原廠腳平滑壓入)
        translate([0, 0, top_total_h - 1.5])
            cylinder(d1 = h2c_foot_dia, d2 = h2c_foot_dia + 3.0, h = 2.0);
            
        // 5. 原廠中心 M3 螺栓頭與金屬平墊片避空凹槽
        translate([0, 0, top_total_h - h2c_foot_depth - h2c_screw_relief_h])
            cylinder(d = h2c_screw_relief_dia, h = h2c_screw_relief_h + 0.1);
            
        // 6. 中心貫穿通孔 (便於觀察螺栓或氣壓平衡)
        translate([0, 0, -1])
            cylinder(d = h2c_center_hole_dia, h = top_total_h + 2);
    }
}

// ==============================================================================
// 裝配體及渲染控制
// ==============================================================================

module assembled_hardware() {
    // 渲染 8 顆 10mm 矽膠球 (高光橘色)
    color("#e67e22")
    for (i = [0 : silicone_ball_count - 1]) {
        rotate([0, 0, i * 360 / silicone_ball_count])
            translate([silicone_pcd / 2, 0, platform_h - cone_depth/2 + 1.0])
                sphere(d = silicone_ball_dia);
    }
    
    // 渲染 7 顆 8mm 鋼球 (金屬銀色)
    color("#bdc3c7") {
        if (enable_center_steel) {
            translate([0, 0, 1.8 + steel_cavity_h / 2])
                sphere(d = steel_ball_dia);
        }
        for (i = [0 : 5]) {
            rotate([0, 0, 30 + i * 60])
                translate([steel_pcd / 2, 0, 1.8 + steel_cavity_h / 2])
                    sphere(d = steel_ball_dia);
        }
    }
}

// 主渲染邏輯
if (view_mode == "printable") {
    // 【排版打印模式】：兩組件平鋪在熱床上，均無需任何支撐！
    translate([-base_dia/2 - 8, 0, 0])
        base_part();
        
    translate([base_dia/2 + 8, 0, top_total_h])
        rotate([180, 0, 0])
            top_part();
            
} else if (view_mode == "base_only") {
    base_part();
    
} else if (view_mode == "top_only") {
    top_part();
    
} else if (view_mode == "assembled") {
    base_part();
    translate([0, 0, 16.0])
        top_part();
    assembled_hardware();
    
} else if (view_mode == "cutaway") {
    difference() {
        union() {
            base_part();
            translate([0, 0, 16.0])
                top_part();
            assembled_hardware();
        }
        translate([-base_dia, -base_dia*2, -5])
            cube([base_dia*2, base_dia*2, base_dia*2]);
    }
}
