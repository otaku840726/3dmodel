# 3D Model Repository (3D 列印模型庫)

個人 3D 列印模型集合庫，包含 OpenSCAD 參數化原始碼、已編譯可直接列印的 STL 檔案、以及高解析度渲染預覽圖。

---

## 📦 模型清單 (Model Catalog)

| 預覽圖 | 模型名稱 / 目錄 | 說明與用途 | 關鍵規格 / 特點 | 快速連結 |
| :---: | :--- | :--- | :--- | :---: |
| <img src="magnetic-exhaust-base/renders/isometric_view.png" width="160" alt="Magnetic Exhaust Base"> | **[magnetic-exhaust-base](magnetic-exhaust-base/)**<br>牆面排風網罩磁吸轉接底座 | 安裝於六角蜂巢孔排風罩的磁吸法蘭底座。用於快速拆裝、磁吸各類排風管或過濾配件。 | • 56 根六角定位柱 (方向/間距校正)<br>• 8 顆 5x3 磁鐵 (6 齒彈性避讓槽)<br>• 7~8mm 氣密帶、外角 R5 防翹板 | [📖 說明](magnetic-exhaust-base/README.md)<br>[📦 STL](magnetic-exhaust-base/magnetic_exhaust_base.stl)<br>[📐 SCAD](magnetic-exhaust-base/magnetic_exhaust_base.scad) |
| <img src="magnetic-exhaust-duct-80mm/renders/isometric_view.png" width="160" alt="Magnetic Exhaust Duct 80mm"> | **[magnetic-exhaust-duct-80mm](magnetic-exhaust-duct-80mm/)**<br>80mm 磁吸排風管轉接頭 | 搭配牆面底座的磁吸排風配件，快速轉接 80mm 軟管（鋁箔管/PVC管），抗拉脫、高氣密。 | • 8 顆 5x3 磁鐵 (6 齒避讓槽，約 4kgf 吸力)<br>• 1.5mm 內嵌對位止口 (防橫向滑動)<br>• 外徑 78.8mm + 80.6mm 防脫倒鉤環<br>• 100% 免支撐列印設計 (管口朝下) | [📖 說明](magnetic-exhaust-duct-80mm/README.md)<br>[📦 STL](magnetic-exhaust-duct-80mm/magnetic_exhaust_duct_80mm.stl)<br>[📐 SCAD](magnetic-exhaust-duct-80mm/magnetic_exhaust_duct_80mm.scad) |
| <img src="chibi-ledge-cat/renders/perspective_ledge.png" width="160" alt="Chibi Ledge Cat"> | **[chibi-ledge-cat](chibi-ledge-cat/)**<br>桌緣趴姿萌貓公仔 | 依循仿生學幾何與黃金比例設計的趴姿貓咪桌緣擺飾。雙腿懸垂桌外，低重心幾何配重，自平衡穩坐桌緣無須黏膠。 | • 黃金比例 ($\phi \approx 1.618$) 造型<br>• 超橢球有機體 + 貝茲四肢 + 對數螺線尾巴<br>• 隱藏式低重心後臀配重，自平衡抗傾覆<br>• 總高 < 50mm，小巧精緻 | [📖 說明](chibi-ledge-cat/README.md)<br>[📦 STL](chibi-ledge-cat/chibi_ledge_cat.stl)<br>[📐 SCAD](chibi-ledge-cat/chibi_ledge_cat.scad) |
| <img src="chibi-ledge-bear/renders/final_perspective.png" width="160" alt="Chibi Ledge Bear (Faceted)"> | **[chibi-ledge-bear](chibi-ledge-bear/)**<br>桌緣趴姿幾何萌熊公仔 (菱角幾何風) | 承襲原版 SCAD 經典低多邊形菱角幾何美學（Faceted Low-Poly Mesh）的小熊公仔。領結蜜罐配備，自平衡穩坐桌緣。 | • 俐落折紙/鑽石菱角切面美學風格<br>• 折紙領結、幾何蜜罐、厚實膝關節<br>• 100% 封閉水密實體，自平衡抗傾覆<br>• 總高 < 50mm，雕塑感極強 | [📖 說明](chibi-ledge-bear/README.md)<br>[📦 STL](chibi-ledge-bear/chibi_ledge_bear.stl)<br>[📐 SCAD](chibi-ledge-bear/chibi_ledge_bear.scad) |
| <img src="cute-ledge-bear/renders/cute_bear_perspective.png" width="160" alt="Cute Ledge Bear (Classic Smooth)"> | **[cute-ledge-bear](cute-ledge-bear/)**<br>桌緣趴姿經典萌熊公仔 (平滑超萌版) | 回歸極致溫潤、圓滾憨厚的正常泰迪小熊風格。圓耳、凸圓紐扣眼、微笑嘴、小領結與懷中蜜罐，自平衡穩坐桌緣無須黏膠。 | • 經典平滑有機曲面 ($fn=48~64)<br>• 圓耳立體耳廓、微凸紐扣眼、親切微笑嘴<br>• 懷抱迷你蜂蜜罐、蝴蝶結領結、腳底肉球<br>• 100% 水密 2-Manifold，自平衡抗傾覆 | [📖 說明](cute-ledge-bear/README.md)<br>[📦 STL](cute-ledge-bear/cute_ledge_bear.stl)<br>[📐 SCAD](cute-ledge-bear/cute_ledge_bear.scad) |
| <img src="cute-ledge-bear-supportfree/renders/sf_monitor_perspective.png" width="160" alt="Cute Ledge Bear Support-Free & Monitor Mount"> | **[cute-ledge-bear-supportfree](cute-ledge-bear-supportfree/)**<br>桌緣/螢幕兩用萌熊公仔 (一體成型免支撐+防滑擋板) | 針對 FDM 3D 列印 100% 一體免支撐與電腦螢幕掛載全新重構。經典圓潤泰迪萌態，前伸環抱蜜罐，底部內嵌免支撐尖拱插槽，搭配模組化薄片擋板，穩放螢幕頂端不掉落！ | • 100% 一體成型免支撐 (0.00g 支撐廢料)<br>• 底部內嵌 45° 尖拱插槽 + 獨立薄片擋板<br>• 電腦螢幕頂部 / 桌緣兩用自由切換<br>• 徹底消除舊版拆分組裝缺陷與雙腿凸起贅肉 | [📖 說明](cute-ledge-bear-supportfree/README.md)<br>[📦 STL](cute-ledge-bear-supportfree/cute_ledge_bear_supportfree.stl)<br>[📐 SCAD](cute-ledge-bear-supportfree/cute_ledge_bear_supportfree.scad) |
| <img src="luxury-wall-toothbrush-holder/renders/faceted_assembled_perspective.png" width="160" alt="Luxury Wall Toothbrush Holder"> | **[luxury-wall-toothbrush-holder](luxury-wall-toothbrush-holder/)**<br>奢華壁掛前壁一體化牙刷洗面乳牙膏收納套裝 (水晶切面版) | 專為玫瑰金絲綢線材打造的五星級衛浴收納套裝。全新「前壁立面一體化」重構，將 6 位前推自定位牙刷架（完美繼承 621-01.stp 人體工學，9mm 卡槽、45° 斜鞍座、19.4mm 喇叭口、25mm 節距，完美相容小米電動牙刷與普通手動牙刷）直接雕刻於洗面乳牙膏艙的前垂立面上，總進深自 94mm 壓縮至僅 74.6mm！後排雙洗面乳大艙（相容 Ø44mm 厚實大圓蓋）+ 雙牙膏大艙（相容 Ø36mm 厚實大圓蓋）+ 直通開放空氣層的 Ø14mm/Ø12mm 垂直大排空孔與防密閉十字導風溝槽。 | • 旗艦 10 合 1 收納套裝 (雙洗面乳 + 雙牙膏 + 6 位牙刷位)<br>• 前壁立面一體化 (總深僅 74.6mm，無懸挑展台與夾層死角，極致輕盈貼牆)<br>• 100% 逆向工程 621-01 人體工學 (9mm 卡槽 + 45° 鞍座，小米電動與普通牙刷全相容)<br>• 全貫穿直通開放排空孔 (洗面乳 Ø14mm / 牙膏 Ø12mm) + 十字防密閉風道 (水滴秒排，煙囪效應對流通風)<br>• 裝飾藝術水晶鑽石切面 (鏡前燈璀璨反光，無多餘凸起贅肉)<br>• 單盤同印 204x116mm (100% 免支撐列印 0 廢料，適配標準 220x220 熱床) | [📖 說明](luxury-wall-toothbrush-holder/README.md)<br>[📦 STL (切面主推)](luxury-wall-toothbrush-holder/combo_plate_grand_faceted.stl)<br>[📐 SCAD](luxury-wall-toothbrush-holder/luxury_wall_toothbrush_holder.scad) |
| <img src="fan-lid-spring-latch/renders/isometric_view.png" width="160" alt="Fan Lid with Spring Latch"> | **[fan-lid-spring-latch](fan-lid-spring-latch/)**<br>風扇快拆蓋子 (雙側彈片防脫落改良版 - 開口端咬合微齒版) | 針對風扇轉接蓋（蓋子9.stl）的抗疲勞防鬆脫改良。依實際安裝情境修正：底座面向凹槽牆面安裝，蓋子蓋上最多齊平（底座僅深入開口端）。完全取消底部多餘卡筍，將咬合摩擦微齒精準配置於開口端（Z=12.8~16.2mm），利用側面彈片微彈性兼顧列印容差並提供強大夾持力。 | • 完全無底扣卡榫 (底部直通平滑，無多餘凸起，徹底消除頂死)<br>• 咬合微齒精準對位開口端 (Z=12.8~16.2mm，緊咬底座側壁)<br>• 純側面彈片 (底板保持 93% 實心剛性，維持全框高強度)<br>• 兼顧列印公差 (彈片自主吸收 ±0.2mm 公差並持續提供預緊力)<br>• 彈片頂端加高 2.5mm 拇指按鍵 + 45° 導引斜坡，100% 免支撐水密直印 | [📖 說明](fan-lid-spring-latch/README.md)<br>[📦 STL 套件](fan-lid-spring-latch/fan_lid_kit_raised_thumb.stl)<br>[📦 STL 單件](fan-lid-spring-latch/fan_lid_spring_raised_thumb.stl) |

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
