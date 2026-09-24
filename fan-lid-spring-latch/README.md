# 風扇快拆蓋子 - 雙側彈片防脫落改良版 (Snap-Fit Fan Lid with Compliant Spring Tabs)

本專案為針對 3D 列印風扇轉接座蓋子（原檔：`蓋子9.stl`）進行的結構優化改良。解決原始設計在長時間運轉震動與環境發熱下容易塑性潛變（Creep）、疲勞鬆動脫落的問題。透過引入**懸臂式柔性彈片（Compliant Cantilever Spring Tabs）**、**45° 裝配導角（Lead-in Chamfer）** 與 **加高拇指按壓指引（Thumb Release Tabs）**，實現清脆卡合、長效牢固且徒手秒拆的高可靠機構。

---

## 視覺渲染與機構圖 (Renders)

| 完整雙件套件 (Isometric Kit) | 原始剛性卡扣 vs 懸臂彈片特寫 |
| :---: | :---: |
| ![完整套件等角圖](renders/isometric_view.png) | ![彈片特寫對比](renders/comparison_closeup.png) |
| **機構工程細節與咬合截面** | **使用者設計概念參考圖** |
| ![多視角與咬合截面](renders/modified_details.png) | ![使用者概念參考圖](renders/reference_concept.png) |

---

## 原版脫落成因與改良工程細節

### 1. 原始設計脫落成因剖析
- **剛性直壁與潛變失效**：原蓋子外壁為連續 1.5mm 封閉直壁（高 16.5mm），內側卡扣（凸出 1.42mm）直接生長於直壁底角。裝配時強行將剛性側壁撐開，在風扇連續震動與熱環境下，材料迅速產生應力鬆弛與塑性潛變，失去緊扣力道而滑脫。
- **直角卡勾刮擦磨損**：原卡扣頂部為直角平底無導角，每次裝拆均會刮損卡齒邊緣，經幾次插拔後咬合深度大幅衰減。

### 2. 懸臂式彈片改良機制
- **雙側直貫穿切槽（1.2mm 槽寬）**：切斷側壁約束，使卡扣兩側形成獨立受力的懸臂樑結構。1.2mm 縫隙適配標準 0.4mm 噴頭列印 3 道外圈，列印時絕不沾黏，兼顧外觀整潔。
- **底板長懸臂延伸（13.6mm 槽深）**：切槽由外壁切入底板 13.6mm（至 $X = \pm 35.0\text{ mm}$），形成彈性充沛的長懸臂樑。底板內側開口周圍保留 **5.0mm 連續剛性框架**，本體剛性完全不受影響。
- **末端止裂圓角（R0.6mm Fillet）**：切槽底部設置應力釋放圓角，防止反覆按壓回彈造成層間微裂紋擴展。
- **45° 裝配導引斜角（Lead-in Chamfer）**：卡扣頂端（$Z = 2.0 \sim 3.2\text{ mm}$）新增 45° 導入斜面，推入時平順滑過底座外倒角，入位瞬間自動回彈咬合，卡感清脆不磨損。
- **加高 2.5mm 拇指按壓指引（按壓版）**：彈片頂端高出外壁 2.5mm（高度由 16.5mm 增至 19.0mm）並施加人體工學導角，拆卸時兩指輕壓即可輕鬆脫扣。

---

## 尺寸規格 (Specifications)

- **蓋子外廓尺寸 (Lid)**：$100.2 \times 100.2 \times 19.0\text{ mm}$ (加高按鈕版) / $16.5\text{ mm}$ (齊平版)
- **底座外廓尺寸 (Base)**：$97.0 \times 97.0 \times 6.5\text{ mm}$ (含 4 根風扇孔位定位柱，高度 2.5mm)
- **中央排風通孔 (Lid Opening)**：$60.0 \times 58.0\text{ mm}$
- **彈片寬度 (Tab Width)**：$16.0\text{ mm}$
- **切槽間隙 (Slot Width)**：$1.2\text{ mm}$
- **懸臂底板厚度**：$1.0\text{ mm}$ (彈力柔順，卡合力約 3.5 ~ 4.5 N)

---

## 3D 列印建議 (Print Settings)

- **擺盤方向**：底面朝下（$Z = 0$ 貼平熱床），開口朝上。
- **支撐設定**：**全件 100% 免支撐（Support-Free）**。所有切槽均垂直於熱床，卡勾導角為 45° 自支撐結構。
- **建議線材**：**PETG** 或 **ABS / ASA**（優選，耐候耐熱且抗疲勞壽命顯著優於普通 PLA）。
- **壁厚外圈 (Perimeters/Walls)**：建議 3～4 圈（確保 1.2mm 切槽兩側壁及彈片內部全實心）。
- **填充率**：25% ~ 40% (Gyroid 陀螺狀填充)。
- **層高**：0.20 mm。

---

## 檔案清單 (File Catalog)

| 檔案名稱 | 說明 | 適用情境 |
| :--- | :--- | :--- |
| [`fan_lid_kit_raised_thumb.stl`](fan_lid_kit_raised_thumb.stl) | **【最推薦】** 完整雙件套件（含底座與加高按鍵彈片蓋子，原座標佈局）。 | 直接匯入切片軟體一盤列印底座與蓋子。 |
| [`fan_lid_spring_raised_thumb.stl`](fan_lid_spring_raised_thumb.stl) | **【最推薦】** 僅加高按鍵彈片蓋子單件。 | 原有底座完好，僅需重印改版蓋子。 |
| [`fan_lid_kit_flush.stl`](fan_lid_kit_flush.stl) | 完整雙件套件，彈片頂端與外壁齊平（全高 16.5mm）。 | 安裝環境上方有極為嚴苛的高度淨空限制時。 |
| [`fan_lid_spring_flush.stl`](fan_lid_spring_flush.stl) | 僅齊平版彈片蓋子單件。 | 嚴格限高且僅需重印蓋子。 |
| [`fan_lid_original_kit.stl`](fan_lid_original_kit.stl) | 原始 `蓋子9.stl` 檔案備份。 | 原始模型歷史歸檔與比對用途。 |
| [`scripts/generate_lids.py`](scripts/generate_lids.py) | Python 幾何生成原始碼（基於 `manifold3d` 與 `trimesh`）。 | 可自訂修改切槽寬度、長度或按鈕高度。 |
