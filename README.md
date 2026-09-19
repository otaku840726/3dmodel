# 3D Model Repository (3D 列印模型庫)

個人 3D 列印模型集合庫，包含 OpenSCAD 參數化原始碼、已編譯可直接列印的 STL 檔案、以及高解析度渲染預覽圖。

---

## 📦 模型清單 (Model Catalog)

| 預覽圖 | 模型名稱 / 目錄 | 說明與用途 | 關鍵規格 / 特點 | 快速連結 |
| :---: | :--- | :--- | :--- | :---: |
| <img src="magnetic-exhaust-base/renders/isometric_view.png" width="160" alt="Magnetic Exhaust Base"> | **[magnetic-exhaust-base](magnetic-exhaust-base/)**<br>牆面排風網罩磁吸轉接底座 | 安裝於六角蜂巢孔排風罩的磁吸法蘭底座。用於快速拆裝、磁吸各類排風管或過濾配件。 | • 56 根六角定位柱 (方向/間距校正)<br>• 8 顆 5x3 磁鐵 (6 齒彈性避讓槽)<br>• 7~8mm 氣密帶、外角 R5 防翹板 | [📖 說明](magnetic-exhaust-base/README.md)<br>[📦 STL](magnetic-exhaust-base/magnetic_exhaust_base.stl)<br>[📐 SCAD](magnetic-exhaust-base/magnetic_exhaust_base.scad) |
| <img src="magnetic-exhaust-duct-80mm/renders/isometric_view.png" width="160" alt="Magnetic Exhaust Duct 80mm"> | **[magnetic-exhaust-duct-80mm](magnetic-exhaust-duct-80mm/)**<br>80mm 磁吸排風管轉接頭 | 搭配牆面底座的磁吸排風配件，快速轉接 80mm 軟管（鋁箔管/PVC管），抗拉脫、高氣密。 | • 8 顆 5x3 磁鐵 (6 齒避讓槽，約 4kgf 吸力)<br>• 1.5mm 內嵌對位止口 (防橫向滑動)<br>• 外徑 78.8mm + 80.6mm 防脫倒鉤環<br>• 100% 免支撐列印設計 (管口朝下) | [📖 說明](magnetic-exhaust-duct-80mm/README.md)<br>[📦 STL](magnetic-exhaust-duct-80mm/magnetic_exhaust_duct_80mm.stl)<br>[📐 SCAD](magnetic-exhaust-duct-80mm/magnetic_exhaust_duct_80mm.scad) |

*(後續新增模型時，可直接在上方表格繼續擴充)*

---

## 🛠️ 目錄組織規範 (Directory Structure)

本倉庫每個模型皆擁有獨立的子目錄，架構如下：

```
3dmodel/
├── README.md                          # 根目錄：全部模型的快速總覽清單與導覽
└── [model-name]/                      # 模型專屬子目錄 (小寫連字符命名)
    ├── README.md                      # 模型詳細說明、規格、BOM、列印建議
    ├── [model_name].scad              # OpenSCAD 參數化原始代碼 (若有)
    ├── [model_name].stl               # 可直接切片之 STL 模型檔案
    └── renders/                       # 模型各角度視覺渲染圖
        ├── isometric_view.png
        ├── bottom_magnets.png
        └── ...
```

---

## 🚀 後續新增模型步驟

1. **建立專屬目錄**：`mkdir -p [model-name]/renders`
2. **放置檔案**：將 `.scad` 程式碼、輸出的 `.stl` 及渲染圖放進該子目錄。
3. **編寫目錄文件**：在子目錄內撰寫 `README.md` 詳細說明其列印設定與安裝方法。
4. **更新根目錄清單**：在根目錄 `README.md` 表格新增一行，包含預覽圖縮圖與說明連結。
