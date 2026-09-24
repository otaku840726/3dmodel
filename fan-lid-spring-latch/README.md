# 風扇快拆蓋子 - 雙側彈片防脫落改良版 (Snap-Fit Fan Lid with Friction-Grip Compliant Spring Tabs)

本專案為針對 3D 列印風扇轉接座蓋子（原檔：`蓋子9.stl`）進行的結構優化改良。解決原始設計在長時間運轉震動與環境發熱下容易塑性潛變（Creep）、疲勞鬆動脫落的問題。

依據最新工程反饋，本版本**完全捨棄傳統底扣卡榫（No Catch Hooks）**，改採**純側面懸臂彈片 + 內壁水平咬合摩擦微齒（Friction-Grip Serrations）**的彈性預緊夾持機構。不僅徹底消除卡齒頂死或難以卡入的困擾，更能透過彈片自主吸收 3D 列印的公差變化，同時提供紮實的摩擦防脫鎖定力！

---

## 視覺渲染與機構圖 (Renders)

| 完整雙件套件 (Isometric Kit) | 原版 vs 底扣版(難卡入) vs 最新咬合摩擦版 對比 |
| :---: | :---: |
| ![完整套件等角圖](renders/isometric_view.png) | ![三代演化特寫對比](renders/comparison_closeup.png) |
| **機構工程細節與咬合截面** | **使用者設計概念參考圖** |
| ![多視角與咬合截面](renders/modified_details.png) | ![使用者概念參考圖](renders/reference_concept.png) |

---

## 機構設計核心理念 (Design Principles)

### 1. 完全取消卡筍，避免插拔卡死 (No Catch Teeth)
- **傳統卡榫痛點**：底扣式卡榫必須精確落入底座倒角，然而 3D 列印的層厚誤差、收縮與底座公差極易導致卡扣太厚頂死、或是太薄鬆脫，插拔時也容易刮傷磨損。
- **最新改良**：底部完全平滑直通（內壁平整），**完全無任何向內勾掛的倒扣卡勾**。蓋子推到底座底面平順無阻，絕不頂死、絕不刮傷。

### 2. 彈片維持在側面，底框保持完整連續
- 彈片回歸側壁本體（雙側垂直貫穿切槽），切槽不向底板大幅開口（底板保有超過 91% 的完整剛性實心框體）。
- 兩側彈片形成高度 16.5mm（加高版 19.0mm）的彈性板簧樑，兼具堅固骨架與充沛的側向彈性。

### 3. 彈片內壁增設「水平咬合摩擦微齒」(Friction-Grip Serrations)
- **多道水平防滑橫紋**：在彈片內壁（$Z = 1.8 \sim 6.8\text{ mm}$）設置 4 道精準梯形摩擦橫紋，微凸 $0.30\text{ mm}$。
- **過盈量 $0.20\text{ mm}$**：風扇底座外壁為 $48.50\text{ mm}$，蓋子內壁平坦處為 $48.60\text{ mm}$，微齒尖端為 $48.30\text{ mm}$。推入時微齒與底座形成 $0.20\text{ mm}$ 的精密微過盈夾持。
- **兼顧容差**：彈片的柔性撓度可在 $\pm 0.2\text{ mm}$ 的列印公差範圍內彈性張開或回彈，無論列印件略大略小均能順暢滑入，絕不崩裂或卡死。
- **增強咬合力**：彈片提供持續向內的彈性預緊法向力（Normal Clamping Force），使微齒深咬底座側壁的列印層紋，大幅提升摩擦力與咬合力，風扇劇烈震動亦絕不脫落。
- **$25^\circ$ 自定心導引斜坡**：微齒頂端設有平順的導入斜角，安裝時自動擴開彈片，一推即入，徒手直拔即可秒拆。

---

## 尺寸規格 (Specifications)

- **蓋子外廓尺寸 (Lid)**：$100.2 \times 100.2 \times 19.0\text{ mm}$ (加高按鈕版) / $16.5\text{ mm}$ (齊平版)
- **底座外廓尺寸 (Base)**：$97.0 \times 97.0 \times 6.5\text{ mm}$ (含 4 根風扇定位柱)
- **中央排風通孔 (Lid Opening)**：$60.0 \times 58.0\text{ mm}$
- **彈片寬度 (Tab Width)**：$12.0\text{ mm}$
- **切槽間隙 (Slot Width)**：$1.0\text{ mm}$
- **內壁摩擦齒微凸量**：$0.30\text{ mm}$ (過盈夾持量 $0.20\text{ mm}$)
- **卡扣形式**：**無底扣卡榫**，純側面彈性夾持 + 內壁多道咬合橫紋

---

## 3D 列印建議 (Print Settings)

- **擺盤方向**：底面朝下（$Z = 0$ 貼平熱床），開口朝上。
- **支撐設定**：**全件 100% 免支撐（Support-Free）**。所有切槽與摩擦斜角皆在自支撐範圍內。
- **建議線材**：**PETG** 或 **ABS / ASA**（優選，抗疲勞韌性最佳；PLA 亦可順暢使用）。
- **壁厚外圈 (Perimeters/Walls)**：建議 3～4 圈（確保彈片本體為實心列印）。
- **填充率**：25% ~ 40% (建議 Gyroid 陀螺狀填充)。
- **層高**：0.20 mm。

---

## 檔案清單 (File Catalog)

| 檔案名稱 | 說明 | 適用情境 |
| :--- | :--- | :--- |
| [`fan_lid_kit_raised_thumb.stl`](fan_lid_kit_raised_thumb.stl) | **【最推薦】** 完整雙件套件（含底座與加高按鍵咬合彈片蓋子，原座標佈局）。 | 直接匯入切片軟體一盤列印底座與蓋子。 |
| [`fan_lid_spring_raised_thumb.stl`](fan_lid_spring_raised_thumb.stl) | **【最推薦】** 僅加高按鍵咬合彈片蓋子單件。 | 原有底座完好，僅需重印改版蓋子。 |
| [`fan_lid_kit_flush.stl`](fan_lid_kit_flush.stl) | 完整雙件套件，彈片頂端與外壁齊平（全高 16.5mm）。 | 安裝環境上方有極為嚴苛的高度淨空限制時。 |
| [`fan_lid_spring_flush.stl`](fan_lid_spring_flush.stl) | 僅齊平版咬合彈片蓋子單件。 | 嚴格限高且僅需重印蓋子。 |
| [`fan_lid_original_kit.stl`](fan_lid_original_kit.stl) | 原始 `蓋子9.stl` 檔案備份。 | 原始模型歷史歸檔與比對用途。 |
| [`scripts/generate_lids.py`](scripts/generate_lids.py) | Python 幾何生成原始碼（基於 `manifold3d` 與 `trimesh`）。 | 可自訂修改切槽參數或咬合微齒尺寸。 |
