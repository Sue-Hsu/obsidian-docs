# 標準文檔對照範例索引與路由指引 (Golden Examples Index)

本文件為專案文檔範例的輕量化導航中樞。為節省對話 Context 與 Token 消耗，範例已依領域拆分為獨立模組。AI Agent 請依當前任務情境，精準讀取對應的範例文件：

---

## 範例模組路由表 (Examples Router)

| 任務情境與文件類型 | 目標分類與職責 | 建議參照範例檔案 | 包含範例內容 |
|---|---|---|---|
| **專案地圖與核心規格** | `10 專案地圖/`、`50 專案文件/SPEC` | [references/examples/project-core.md](examples/project-core.md) | 一般專案地圖（含 `[!FOCUS]`）、產品規格書（Living Doc/廢棄標記）、技能專案地圖 |
| **資安審查與態勢總覽** | `70 資安審查/SEC-` | [references/examples/security.md](examples/security.md) | 資安審查總覽儀表板 (`SEC-000`)、具體審查報告 (`SEC-003` 含三維狀態與實測證據) |
| **中大型架構與對外發布** | `50 專案文件/05 對外發布/`、工單歸檔 | [references/examples/release.md](examples/release.md) | 中大型二級子目錄全景、工單 >30 篇歸檔、對外發布純淨使用者手冊（脫敏與死鏈隔離） |
| **外部工具與套件評估** | `※_外部評估/` | [references/examples/external-eval.md](examples/external-eval.md) | Chrome 插件評估報告 (`PromptGenius` 權限與安全性分析) |

---

## 範本與範例對應速查

- 專案開局或接力 ➔ 套用 `resources/templates/專案地圖.md`，參考 [project-core.md](examples/project-core.md) 範例一
- 撰寫產品規格 ➔ 套用 `resources/templates/產品規格.md`，參考 [project-core.md](examples/project-core.md) 範例二
- 資安首篇總覽 ➔ 套用 `resources/templates/資安總覽.md`，參考 [security.md](examples/security.md) 範例一
- 工具掃描報告 ➔ 套用 `resources/templates/資安審查.md`，參考 [security.md](examples/security.md) 範例二
- 對外發布文件 ➔ 套用 `resources/templates/通用文件.md`，參考 [release.md](examples/release.md) 範例二
- 外部資源評估 ➔ 套用 `resources/templates/外部評估.md`，參考 [external-eval.md](examples/external-eval.md) 範例一
