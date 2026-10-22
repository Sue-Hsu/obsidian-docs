# obsidian-docs

自己使用的跨AI Agent共用的Obsidian 知識庫文件治理技能庫。

---

## 本機快速部署與驗證

### 1. 同步到 Antigravity 全域技能目錄
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-global.ps1
```
路徑會同步至 `~/.gemini/config/skills/obsidian-docs/`。

### 2. 測試與結構檢查
每次修改範本或規則後，執行檢查腳本確認格式無誤：
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\test-skill.ps1
```

### 3. 其他 AI 工具使用方式
- Claude Code / Desktop：直接指向或複製本目錄，設定檔掛載 Obsidian MCP。
- Cursor / Windsurf：放於專案 `.cursor/rules` 或工作區技能目錄，載入 `SKILL.md`。

---

## 推薦外掛與雙軌讀取架構

為在 Obsidian 中獲得最佳視覺看板體驗，建議搭配以下社群外掛：
- Dataview 外掛（推薦）：專案地圖與協作任務卡中內嵌 Dataview 查詢代碼塊，能在 Obsidian 前端為人類使用者提供即時動態看板與關聯卡片清單。
- 雙軌解耦設計：AI 代理人原生讀取純文字 Markdown，無法直接看見 DataviewJS 的動態渲染結果。因此技能採用「專案地圖焦點指針優先、MCP DQL 即時查詢輔助」的雙軌架構。即便未安裝 Dataview 外掛，亦完全不影響 AI 進行筆記讀寫、狀態追蹤與知識治理。

---

## 倉庫內容架構

```text
obsidian-docs/
├── SKILL.md                          # 技能主規則（含情境選型決策矩陣）
├── README.md                         # 本維護手冊
├── references/                       # 規範指南與按需讀取範例
│   ├── taxonomy-guide.md             # 目錄命名與生命週期指南
│   ├── frontmatter-spec.md           # YAML 屬性與狀態枚舉規範
│   ├── mcp-troubleshooting.md        # 各 Client MCP 設定與 401 排錯
│   ├── examples.md                   # 範例路由索引
│   └── examples/                     # 拆分後的模組化範例（節省 Token）
│       ├── project-core.md           # 專案地圖與產品規格範例
│       ├── security.md               # 資安總覽 (SEC-000) 與工具報告範例
│       ├── release.md                # 中大型架構與發布手冊範例
│       └── external-eval.md          # 外部工具評估報告範例
├── resources/
│   └── templates/                    # 12 份標準 Markdown 範本庫
│       ├── 專案地圖.md
│       ├── 產品規格.md
│       ├── 協作任務.md
│       ├── 需求訪談.md
│       ├── 研究筆記.md
│       ├── 變更紀錄.md
│       ├── 通用文件.md
│       ├── 跨專案決策.md
│       ├── AI 提案.md
│       ├── 外部評估.md
│       ├── 資安審查.md
│       └── 資安總覽.md
└── scripts/                          # 維護腳本
    ├── test-skill.ps1                # 格式驗證
    └── install-global.ps1            # Antigravity 全域安裝
```

---

## 常用情境與範本速查

| 情境 | 目標目錄 | 使用範本 | 參考範例 |
|---|---|---|---|
| 專案開局、建立導航地圖 | `10 專案地圖/` | `專案地圖.md` | `project-core.md` #範例一 |
| 需求訪談、候選選項記錄 | `15 需求訪談/` | `需求訪談.md` | `project-core.md` #範例二引用 |
| 撰寫系統產品規格書 | `50 專案文件/` | `產品規格.md` | `project-core.md` #範例二 |
| 開發工單與具體任務卡 | `60 協作任務/` | `協作任務.md` | `project-core.md` #範例一引用 |
| 資安態勢總覽頁 | `70 資安審查/` | `資安總覽.md` | `security.md` #範例一 |
| 工具掃描或弱點複測報告 | `70 資安審查/` | `資安審查.md` | `security.md` #範例二 |
| 對外公開交付的使用手冊 | `50 專案文件/05 對外發布/` | `通用文件.md` | `release.md` #範例二 |
| 外部工具與 Chrome 插件評估 | `※_外部評估/` | `外部評估.md` | `external-eval.md` #範例一 |
