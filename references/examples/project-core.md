# 核心專案範例：地圖與規格 (Core Project Examples)

本文件收錄專案開局、導航與規格契約的核心示範，供 AI Agent 依情境精準參考，避免載入不必要的其他領域內容。

---

## 範例一：微小型專案完整專案地圖（含 [!FOCUS] 現況焦點指針）

適用情境：專案開局建立核心導航中樞、換窗接力斷點更新。
對應範本：`resources/templates/專案地圖.md`
目標目錄：`2026-10_ecommerce-web/10 專案地圖/MAP-ecommerce-web.md`

### 檔案完整內容：

```markdown
---
類型: 專案地圖
專案: ecommerce-web
建立日期: 2026-10-01
修改日期: 2026-10-15
狀態: 使用中
密等: 內部使用
標籤:
  - 專案地圖
  - 專案/ecommerce-web
儲存庫: 'C:\Projects\ecommerce-web'
---

# MAP-ecommerce-web 專案地圖

> [!FOCUS] 現況焦點指針 (Active Focus)
> - 當前目標里程碑：v1.0.0 核心購物車與金流結帳串接上線
> - 進行中任務卡：[[2026-10_ecommerce-web/60 協作任務/COLLAB-003-金流Webhook串接|COLLAB-003 金流Webhook串接]]
> - 最新中斷點：已完成藍新金流回傳簽章驗證演算法，停在訂單付款狀態異步更新邏輯 (`order.service.ts:48`)
> - 下一步行動：補齊資料庫交易樂觀鎖並撰寫單元測試驗證通過
> - 最新資安態勢：最新通過 SEC-005，全局 0 High，DAST 待複測，詳見 [[2026-10_ecommerce-web/70 資安審查/SEC-000-資安審查總覽|SEC-000]]

本文件為 `ecommerce-web` 專案之核心導航與進度中樞，提供程式碼庫、進度看板、關鍵文檔、研究成果與任務追蹤之連結地圖。

---

## 1. 專案概況
- 專案簡介：B2C 線上購物商城平台。
- 程式碼儲存庫 (Repo)：`C:\Projects\ecommerce-web`
- 主要技術棧：React, Next.js, TypeScript, Tailwind CSS, PostgreSQL
- 本地專案說明文件：`docs/PROJECT.md`

## 2. 協作任務（選用 Dataview）

```dataview
TABLE 狀態, 負責AI, 狀態維護者, 修改日期
FROM "2026-10_ecommerce-web/60 協作任務"
WHERE file.name != "已結案"
SORT 修改日期 DESC
```

未安裝 Dataview 時，請直接依據頂部 `> [!FOCUS]` 指針或從 `60 協作任務/` 開啟任務卡；不要在此手動複製狀態。

## 3. 專案文件動態總覽 (Dataview)

```dataview
TABLE 類型, 狀態, 修改日期
FROM "2026-10_ecommerce-web"
WHERE file.name != "MAP-ecommerce-web"
SORT file.folder ASC, file.name ASC
```

## 4. 導航

- Repo `docs/PROJECT.md`：`C:\Projects\ecommerce-web\docs\PROJECT.md`
- 規格與變更紀錄：[[2026-10_ecommerce-web/50 專案文件/SPEC-產品規格|產品規格]]、[[2026-10_ecommerce-web/50 專案文件/CHANGELOG|變更紀錄]]
- 需求訪談依據：[[2026-10_ecommerce-web/15 需求訪談/INTV-001-購物車與結帳訪談|INTV-001 購物車與結帳訪談]]
- 資安態勢總覽：[[2026-10_ecommerce-web/70 資安審查/SEC-000-資安審查總覽|SEC-000 資安審查總覽]]（工具版本、掃描歷程、弱點詳情與證據集中收納於此與個別 SEC 報告）

## 5. 目錄結構

```text
2026-10_ecommerce-web/
├── 10 專案地圖/
│   └── MAP-ecommerce-web.md
├── 15 需求訪談/
│   └── INTV-001-購物車與結帳訪談.md
├── 50 專案文件/
│   ├── SPEC-產品規格.md
│   └── CHANGELOG.md
├── 60 協作任務/
│   ├── COLLAB-001-架構初始化.md
│   └── COLLAB-003-金流Webhook串接.md
└── 70 資安審查/
    └── SEC-000-資安審查總覽.md
```
```

---

## 範例二：產品規格書 (SPEC) - 含 Living Document 與 ISO 廢棄標記

適用情境：定義系統功能需求、資料模型、驗收標準 (AC) 與功能廢棄程序。
對應範本：`resources/templates/產品規格.md`
目標目錄：`2026-10_ecommerce-web/50 專案文件/SPEC-產品規格.md`

### 檔案完整內容：

```markdown
---
類型: 產品規格
專案: ecommerce-web
建立日期: 2026-10-01
修改日期: 2026-10-15
狀態: 使用中
密等: 內部使用
對應版本: "v1.0.0-rc2"
關聯PR: "#42"
標籤:
  - 產品規格
  - 專案/ecommerce-web
---

# ecommerce-web 產品規格書

> [!NOTE]
> Living Document 與變更管制原則：
> 1. 本文件為現行生效的單一事實來源 (SSOT)。功能更新一律採就地修訂，所有變更與演進均集中於本文件記載。
> 2. 功能廢棄嚴格遵循 ISO 流程，於內文加註 `[已廢棄]` 標記並同步於 CHANGELOG 記錄。

## 1. 背景與目標
- 背景與核心挑戰：建立高轉化率、流暢且支援行動端的電商平台。
- 目標讀者／使用者：線上一般消費者與商城管理員。
- 預期產出與效益：支援購物車、結帳金流串接與訂單追蹤功能。

## 2. 功能範疇與規格說明
### 2.1 本階段核心功能需求
- 商品瀏覽、搜尋與分類篩選。
- 會員購物車與結帳金流串接（藍新金流信用卡與 LINE Pay）。
- 後台商品管理與庫存控管。

### 2.2 已廢棄歷史介面 (ISO 廢棄程序記錄)
> [!WARNING] [已廢棄] 訪客 Cookie 暫存購物車自 v1.0.0-rc1 起停用
> 原 `CartCookieStorage` 存在大小限制與資安弱點，已全面改由 `CartLocalStorageService` 與後端同步取代。

### 2.3 邊界條件與後續階段規劃 (Future Phases)
- 第二階段支援多幣別結帳。
- 第二階段規劃即時客服聊天室。

## 3. 驗收標準 (Acceptance Criteria, AC)
- [x] AC 1: 使用者能將商品加入購物車並順利完成結帳。
- [x] AC 2: 購物車資料在重新整理後維持保存。
- [ ] AC 3: 金流回傳 Webhook 簽章驗證正確性 100%。

## 4. 相關連結與依據
- 需求訪談依據：[[2026-10_ecommerce-web/15 需求訪談/INTV-001-購物車與結帳訪談|INTV-001 購物車與結帳訪談]]
- 專案地圖：[[2026-10_ecommerce-web/10 專案地圖/MAP-ecommerce-web|專案地圖]]
- 變更紀錄：[[2026-10_ecommerce-web/50 專案文件/CHANGELOG|變更紀錄]]
- 關聯任務：[[2026-10_ecommerce-web/60 協作任務/COLLAB-003-金流Webhook串接|COLLAB-003 金流Webhook串接]]
```

---

## 範例三：SKILL 技能專案完整專案地圖

適用情境：專門用於開發 Antigravity / Codex Skill 專案的地圖結構（存放於 `※_SKILL/`）。
對應範本：`resources/templates/專案地圖.md`
目標目錄：`※_SKILL/2026-10_data-scraper/10 專案地圖/MAP-data-scraper.md`

### 檔案完整內容：

```markdown
---
類型: 專案地圖
專案: data-scraper
建立日期: 2026-10-01
修改日期: 2026-10-15
狀態: 使用中
密等: 內部使用
標籤:
  - 專案地圖
  - 專案/data-scraper
  - 類型/SKILL
儲存庫: 'C:\Projects\skills\data-scraper'
---

# MAP-data-scraper 技能專案地圖

> [!FOCUS] 現況焦點指針 (Active Focus)
> - 當前目標里程碑：v0.1.0 支援動態 SPA 頁面非同步資料擷取
> - 進行中任務卡：[[※_SKILL/2026-10_data-scraper/60 協作任務/DEV-002-動態渲染管線|DEV-002 動態渲染管線]]
> - 最新中斷點：已完成 Playwright 無頭瀏覽器驅動封裝，停在擷取重試等待機制
> - 下一步行動：執行單元測試並整合至 SKILL.md 指令集
> - 最新資安態勢：初次依賴與靜態掃描通過，全局 0 弱點，詳見 [[※_SKILL/2026-10_data-scraper/70 資安審查/SEC-000-資安審查總覽|SEC-000]]

---

## 1. 專案概況
- 技能名稱：data-scraper
- 技能儲存庫：`C:\Projects\skills\data-scraper`
- 核心功能：網頁靜態與動態資料結構化萃取。
- 本地專案說明文件：`docs/PROJECT.md`

## 2. 協作任務（選用 Dataview）

```dataview
TABLE 狀態, 負責AI, 狀態維護者, 修改日期
FROM "※_SKILL/2026-10_data-scraper/60 協作任務"
WHERE file.name != "已結案"
SORT 修改日期 DESC
```

## 3. 導航
- 技能入口說明：`docs/PROJECT.md`
- 產品規格：[[※_SKILL/2026-10_data-scraper/50 專案文件/SPEC-產品規格|產品規格]]
- 變更紀錄：[[※_SKILL/2026-10_data-scraper/50 專案文件/CHANGELOG|變更紀錄]]
- 資安態勢總覽：[[※_SKILL/2026-10_data-scraper/70 資安審查/SEC-000-資安審查總覽|SEC-000 資安審查總覽]]（工具版本、掃描歷程、弱點詳情與證據集中收納於此與個別 SEC 報告）
```
