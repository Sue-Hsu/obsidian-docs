# 對外發布與架構演進範例 (Release & Enterprise Architecture Examples)

本文件收錄專案達到中大型規模（> 15 篇文件）、工單歸檔（> 30 篇工單）以及對外發布純淨交付文件的標準對照示範。

---

## 範例一：中大型專案二級子分類、工單歸檔與對外發布全景

適用情境：專案文件累積超過 15 篇，或需啟用 `50 專案文件/05 對外發布/` 進行公開交付時。
對應範本：`resources/templates/通用文件.md`、`resources/templates/專案地圖.md`
目標目錄：`2026-10_enterprise-system/`

### 目錄結構全景 (Text Tree)：

```text
2026-10_enterprise-system/
├── 10 專案地圖/
│   └── MAP-enterprise-system.md
├── 15 需求訪談/
│   └── INTV-001-多租戶架構訪談.md
├── 50 專案文件/
│   ├── 01 規格與契約/
│   │   ├── SPEC-使用者認證服務.md
│   │   ├── CONTRACT-金流Webhook.md
│   │   └── ARCH-分散式快取架構.md
│   ├── 02 維運與指南/
│   │   ├── CHANGELOG.md
│   │   ├── SOP-高可用部署手冊.md
│   │   └── GUIDE-災難復原指引.md
│   ├── 03 驗收紀錄/
│   │   ├── AC-MATRIX-v1.0.md
│   │   └── VERIFY-壓力測試驗收報告.md
│   ├── 04 審閱歷史/
│   │   ├── DRAFT-舊版金流架構草稿.md
│   │   └── REV-HIST-結帳重構討論稿.md
│   └── 05 對外發布/                    <-- 按需啟用，存放純淨版對外產物
│       ├── USER-GUIDE.md               <-- 已去識別化，隔離內部 Wiki-link
│       └── RELEASE-NOTES-v1.0.md
├── 60 協作任務/
│   ├── 已結案/                         <-- 工單超過 30 篇時歸檔
│   │   ├── COLLAB-001-架構初始化.md
│   │   └── COLLAB-002-資料庫設定.md
│   ├── COLLAB-031-多租戶權限隔離.md
│   └── COLLAB-032-OpenTelemetry監控.md
└── 70 資安審查/
    ├── SEC-000-資安審查總覽.md
    └── SEC-001-CodeQL掃描報告.md
```

---

## 範例二：對外發布純淨使用者手冊（發布安全檢核閘門示範）

適用情境：公開釋出給外部開發者、客戶或開源社群的文件，必須徹底脫敏並隔離內部鏈接。
對應範本：`resources/templates/通用文件.md`
目標目錄：`2026-10_enterprise-system/50 專案文件/05 對外發布/USER-GUIDE.md`

### 檔案完整內容：

```markdown
---
類型: 通用文件
專案: enterprise-system
建立日期: 2026-10-15
修改日期: 2026-10-15
狀態: 使用中
密等: 公開
發布狀態: 已發布
發布版本: "v1.0.0"
目標對象: "外部開發者與客戶團隊"
標籤:
  - 對外發布
  - 專案/enterprise-system
---

# Enterprise System 使用者手冊 (v1.0.0)

本指南說明 Enterprise System 的基本配置、API 串接指引與常見問題排查。

> [!NOTE]
> 本文件已通過發布安全檢核閘門，所有本機路徑、內部私有 IP 與真實憑證皆已完成去識別化。

## 1. 快速開始 (Quick Start)

### 1.1 環境配置
請將環境設定檔案放置於 `<install-dir>/.env`：

```bash
# 伺服器端點設定（示範佔位符，請填寫對外公開之安全端點）
API_ENDPOINT=https://api.example.com/v1
APP_KEY=<your-license-key>
```

### 1.2 呼叫範例
```bash
curl -X GET "https://api.example.com/v1/health" \
  -H "Authorization: Bearer <your-access-token>"
```

## 2. 核心架構概念
詳細介面規範與契約定義，請參閱本公開目錄之 [發布紀錄說明](RELEASE-NOTES-v1.0.md)。
（注意：依發布協議規範，一律鏈結同屬發布目錄之公開筆記，保持鏈接純淨自包含）。
```
