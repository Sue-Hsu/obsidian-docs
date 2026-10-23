# 變更紀錄 (CHANGELOG)

本文件依倒序記錄 `obsidian-docs` 技能之重大變更與版本歷程。

## [2.13.0] - 2026-10-23

### 增量資安評估架構、基準保存與去外部 Skill 依賴升級 (Baseline & Incremental Security Architecture)
- 評估基準與增量評估機制：將評估基準定義為一次可追溯的安全快照（assessment_id、版本/雜湊、環境、工具與覆蓋限制），支援以現行基準為對照的後續增量評估，範本內建連動影響分析與擴大測試理由。
- 總覽儀表板雙重呈現：SEC-000 總覽範本支援同時呈現「目前適用的評估基準」與「最近一次評估/增量變更」，保留歷次基準演進歷史。
- 驗證狀態全面對齊：統一定義驗證狀態為 `通過 (PASS)`、`發現弱點 (FAIL)`、`未受測 (NOT_TESTED)`、`結果未定 (INCONCLUSIVE)`、`不適用 (NOT_APPLICABLE)`。
- 跨代理人協作去依賴化：重構專案末段「跨代理人與開發工作流協作原則」，移除對特定外部技能名稱的硬編碼依賴，保持自包含與鬆耦合。
- MCP 優先與斷線主動通報：於技能 SOP 與排錯手冊正式規範優先使用 Obsidian MCP，當連線未就緒或異常時主動提醒使用者檢查連線狀態，經確認後再採用本機寫入備援。
- 增量評估完整示範：於 `security.md` 追加範例三（`SEC-006`），示範修改共用授權中間件時如何納入未直接修改但受連動影響的端點，並記錄實測客觀證據。

---

## [2.12.0] - 2026-10-22

### MCP 工具名稱勘誤與跨 Client Dataview 相容性升級 (MCP Tool Harmonization & Portability)
- 實際工具名稱勘誤：修正 `SKILL.md` 中不存在的 `update_vault_file` 為標準局部更新工具 `patch_vault_file`。
- 跨 Client DQL 抽象化：移除寫死單一 Client 工具名稱與固定 Token 數字之描述，改為引導 AI 動態適配目前環境提供之 Dataview 查詢工具（例如 Codex 之 `search_vault` 搭配 `queryType: "dataview"`）。
- 外掛缺失平滑降級 SOP：於 `SKILL.md`、`README.md` 與 `mcp-troubleshooting.md` 正式確立 `dataview_not_installed` 處置機制，遇外掛未安裝時自動回退讀取地圖焦點指針，無縫銜接。

### 資安範例狀態校準與 Frontmatter 規格統一 (Security Example & Spec Harmonization)
- 資安狀態一致性校準：修復 `security.md` 範例中架構審查與滲透測試之狀態矛盾，將已實測項目標為 PASS、拆出未受測之滲透測試，並將純規劃報告 SEC-001 驗證狀態正名為 NOT_TESTED，徹底符合客觀證據準則。
- Frontmatter 列舉值補齊與對齊：在 `frontmatter-spec.md` 中為「評估模式」補入 `綜合評估`，為「風險等級」補入 `待評估 (Pending)`，並明訂修復狀態在 Frontmatter 全稱與內文表格精簡版之對照標準。
- 換行字元全面規範化：新增標準化維護腳本，將全庫所有 Markdown 檔案統一轉為無 BOM UTF-8 與純 LF (`\n`) 結尾。

### AI 混合互補讀取架構與 Dataview 前端視覺解耦 (Dual-Track Read & Visual Decoupling)
- 雙軌解耦架構確立：確認 AI 原生讀取 Markdown 無法直接感知 Dataview / DataviewJS 動態渲染之限制，確立「人類視覺看 Dataview 動態看板、AI 代理人依賴純文字結構」的分工原則。
- 專案地圖焦點指針第一防線：開局與進度盤點優先讀取專案地圖頂部 `> [!FOCUS]` 現況焦點指針，單檔耗費不到 1,000 tokens 即掌握全局進度與斷點，免除遍歷目錄與逐篇開啟卡片的巨額開銷。
- MCP DQL 查詢第二防線：面對跨目錄關聯、多維度篩選或版本統計時，調用 Obsidian MCP 的 `execute_dataview_query` 由本地引擎秒級過濾並回傳精簡資料（約 100~300 tokens），兼顧即時性與極低 Token 消耗。
- 文件與指引同步：於 `README.md` 補充「推薦外掛與雙軌讀取架構」，於 `SKILL.md` 核心工作原則與步驟四補齊操作指引。

---

## [2.9.0] - 2026-10-22

### 企業級資安治理與 ISO 27001/9001 管制體系升級 (Enterprise Security & Information Asset Governance)
- **資安放行建議與實際發布授權嚴格分離 (Separation of Duties, SoD)**：
  - 資安檢測通過（如 0 Critical / 0 High）僅代表技術維度達到安全防護門檻，產生「資安放行建議」（`建議放行`、`條件式放行`、`不建議放行`、`未評估`）。
  - 絕不代表已取得 commit、部署、公開發布、DNS 或雲端設定變更授權；「實際發布授權」（`已授權`、`未授權`、`條件式授權`、`不適用`）嚴格保留由產品負責人、主管或發布審批委員會 (CAB) 核可。
- **原始掃描報告受控存放與淨化規範 (Raw Report Storage & Sanitization)**：
  - 原始報告優先保存在 Git repo 與 Obsidian Vault 之外的獨立受控安全儲存體中。
  - 若因管線需求暫存於 repo 內，必須確認已列入 `.gitignore` 排除於 Git 版控、CI/CD 建置產物 (Build Artifacts) 及正式部署內容，並強制移除 Cookie、token、Session、私人郵件、帳戶識別資訊 (PII) 及完整原始 HTTP 請求/回應內容。
  - Obsidian Vault 僅保留去識別化摘要、檔案完整性雜湊 (SHA-256)、保存期限與受控位置說明。
- **可驗證之永久刪除與金鑰銷毀程序 (Verifiable Deletion & Crypto-shredding)**：
  - 全面將傳統「安全覆寫」重構為依儲存媒體與平台（SSD NVMe、雲端 Object Storage 等）採用可驗證的永久刪除、加密金鑰銷毀 (Crypto-shredding) 或組織核准的資料清理程序。
- **弱點清單三軸獨立追蹤 (Findings Register Tri-State Disaggregation)**：
  - Findings 表格全面分離記錄：
    1. 弱點確認狀態：`待確認`／`已確認`／`誤報`
    2. 修復狀態：`待修復`／`修復中`／`已修復`／`接受風險`／`不適用`
    3. 複測狀態：`未複測`／`通過`／`未通過`／`不適用`
- **SEC-000 總覽儀表板統計分流與誠實原則 (Honest Metric & Coverage Partitioning)**：
  - SEC-000 弱點統計明確拆分為：
    1. 目前未結案弱點：Critical／High／Medium／Low／Info
    2. 處置進度：已修復、接受風險、誤報
    3. 未受測範圍：標記為未知或 `NOT_TESTED`
  - 只有實際受測的範圍才能填 0；尚未檢測的範圍標示為未知或 `NOT_TESTED`，嚴禁虛報。
- **ISO 27001 資訊資產密等分級治理 (Classification of Information Assets)**：
  - 去識別化脫敏之資安摘要預設為「內部使用」。
  - 凡內文包含具體可利用弱點 PoC、真實帳戶資訊、內部網路拓撲或敏感系統路徑時，密等強制標定為「機密」。
  - 對外版本必須另行於 `50 專案文件/05 對外發布/` 產出，嚴格完成去識別化脫敏及發布審查後始得標為「公開」。
- **統一資安 Frontmatter 10 大標準欄位與列舉值**：
  - 統一規範：`報告編號`、`評估編號`、`評估模式`、`來源版本`、`驗證狀態`、`風險等級`、`檢測工具`、`修復狀態`、`資安放行建議`、`實際發布授權`。
- **專案地圖精準收斂 (Project Map Decoupling)**：
  - 專案地圖 `> [!FOCUS]` 僅保留一句最新資安態勢指標及 `SEC-000` 連結；工具版本、掃描歷程、弱點詳情與實測證據集中收納於 SEC-000 總覽與個別 SEC 報告中，保持地圖輕量專注。
- **全量泛用與去識別化保證**：
  - 所有範本與範例維持泛用性、去識別化，使用虛構名稱、保留網域與佔位符，不綁定特定專案、模型或代理工具。

---

## [2.8.0] - 2026-10-15

### 企業級文件管制與自適應治理升級 (Enterprise Doc-as-Code & Adaptive Governance)
- **專案規模自適應門檻機制 (Adaptive Scale Threshold)**：
  - 微小型專案（檔案數 ≤ 15 篇）：維持極簡一級扁平分類（`00`～`90` 直屬放檔），絕不增加多餘目錄層級與心智負擔。
  - 中大型專案（檔案數 > 15 篇，或具多規格/契約時）：自動啟用 `50 專案文件/` 標準二級子分類架構（維持至多兩層目錄，符合 MECE 原則）：
    1. `50 專案文件/01 規格與契約/`：現行生效之基準規格、資料契約、架構說明 (Living Docs / SSOT)。
    2. `50 專案文件/02 維運與指南/`：SOP、部署手冊、災備指引、CHANGELOG。
    3. `50 專案文件/03 驗收紀錄/`：工程驗收矩陣、跨模組核對等不可抹滅之品質證據。
    4. `50 專案文件/04 審閱歷史/`：階段性候選審核稿、過渡討論稿（ISO 9001 文件管制，杜絕過期草案污染生效規格）。
- **對外發布與交付協議 (Release Protocol - 按需啟用)**：
  - 按需原則：內部專案與無發布需求之系統嚴禁預先建立發布目錄。
  - 發布目錄標準：僅在確定對外公開交付時，按需啟用 `50 專案文件/05 對外發布/`。
  - 擴充 Frontmatter 屬性：`密等`（`公開`、`內部使用`、`機密`，預設為 `內部使用`）、`發布狀態`（`未發布`、`待發布`、`已發布`、`內部專用`）、`發布版本`（如 `v1.0.0`）。
  - 發布安全檢核閘門 (Release Gate Checklist - ISO 27001)：敏感資訊去識別化（脫敏本機絕對路徑、內網 IP/Port、測試 Token）；隔離內部 Wiki-link 杜絕內部知識庫外洩與死鏈。
- **發布後持續變更治理 (Day-2 Change Management)**：
  - 活文檔單一事實來源：規格就地更新並標記版本，嚴禁同名衍生複本（禁止另開 `_v2.md`）。
  - ISO 廢棄流程：嚴禁無痕偷刪；過時或廢棄功能須標記 `> [!WARNING] [已廢棄]`，並於 CHANGELOG 的 `### 移除 (Removed)` 或 `### 廢棄 (Deprecated)` 記載。
  - 工單流水號全週期自然遞增：`60 協作任務/` 工單流水號跨版本不重置，保持全生命週期追溯性。
  - 上線後資安持續巡檢：`70 資安審查/` 事件驅動流水號延續記錄例行複測與依賴 CVE 修補。
- **開局進度盤點與換窗接力升級（解決 AI Dataview 盲區）**：
  - 專案地圖增設「現況焦點指針 (Active Focus)」：`10 專案地圖/MAP-<專案名稱>.md` 頂部強制維護 `> [!FOCUS]` 靜態區塊（目標里程碑、進行中任務卡連結、最新斷點、下一步行動），換窗交接即時同步。
  - 開局盤點輕量化：優先讀取 `[!FOCUS]` 指針與任務卡，解耦巨型規格書，避免全量讀取龐大 SPEC 造成 Token 浪費。
  - 工單庫結案歸檔機制：當 `60 協作任務/` 累積超過 30 篇時，已驗收工單允許歸檔入 `60 協作任務/已結案/`，維持根目錄乾淨。
- **子代理調度備用指引與排版純淨化 (Subagent Guidelines & Clean Typography)**：
  - 獨立作業優先原則：明訂當前 Agent 具備獨立完成任務之完整能力，本技能絕無強制或預設引導開啟子代理；僅作為條件式備用防護。
  - 自主模型選型（經濟檔優先）：若自主決定啟動子代理，由當前 Agent 自主評估環境選取低消耗階梯（Antigravity 優先指定 `Model: "flash"` / `"flash_lite"`；其他環境指定 fast / mini 系列），非極重大深層推理避免繼承高階旗艦模型。
  - 集中 I/O 防護與防簡略把關：子代理僅產出純文字草稿，由主代理把關質量並統一落盤寫入 Vault，杜絕跨 Session 401 錯誤與 Token 浪費。
  - 排版無多餘星號：全文移除多餘粗體星號，僅在關鍵強調與警示處保留，保持極簡清爽視覺。

---

## [2.7.0] - 2026-10-14

### 重大架構收斂與嚴謹化 (Major Architectural Hardening)
- 權責分離與多 Agent 協作狀態邊界 (Role & Status Boundary Hardening)：
  - 任務卡單一事實來源：專案地圖（`MAP`）全面改為透過 Dataview 動態彙整狀態，移除易導致狀態衝突的人工待辦看板，避免多頭維護。
  - 明確劃分 Worker 與 Coordinator 之任務狀態維護權限：Worker 僅能將任務卡維護至 `進行中` 或 `待審閱`；`完成` 狀態嚴格保留由 Coordinator 於實質驗收後判定。
  - 文件狀態與任務狀態嚴格正交分流：
    - 文件狀態：`草稿`、`提案中`、`已驗證`、`使用中`、`已取代`、`已廢棄`（新建立或無實質驗證之文件預設為 `草稿`；唯有附帶真實重現/測試證據時始得標記為 `已驗證`）。
    - 任務狀態：`待辦`、`規劃中`、`進行中`、`待審閱`、`受阻`、`完成`。
- 嚴格界定 Vault Wiki-link 邊界 (Vault vs Repo Wiki-link Boundary)：
  - 明確規範 Vault 內部 Wiki-link（`[[...]]`）僅得連結 Vault 實體筆記；儲存庫外部檔案（如 `docs/PROJECT.md`、`AGENTS.md`）一律採用檔案路徑或 Markdown 外部連結標註，杜絕無效連結。
- 專用範本精準化升級：
  - `協作任務.md`：移除硬編碼狀態維護者，強化驗收交接紀錄章節。
  - `通用文件.md`：新增「對應版本」與「關聯PR」等代碼版本實質證據欄位。
- 自動化驗證測試套件升級 (`scripts/test-skill.ps1`)：
  - 新增協作與範本邊界檢驗、預設文件狀態驗證、非規範狀態過濾及 Wiki-link 跨界檢查。

---

## [2.6.0] - 2026-10-13

### 新增與強化 (Added & Enhanced)
- 獨立「15 需求訪談/」目錄與完整選項歸檔機制 (`INTV-001-<主題>.md`)：
  - 新增獨立分類目錄 `15 需求訪談/`（位於 `10 專案地圖/` 與 `20 研究/` 之間，貼合軟體工程從訪談到調研、規格、開發的生命週期）。
  - 新增全域範本 `resources/templates/需求訪談.md` 與 `references/examples.md` 範例六：完整記錄每一道問題背景、當時提出的所有候選選項（以 `- [x]` 標示使用者最終選擇、`- [ ]` 標示其餘未選方案），並將「使用者補充說明」設為選填（若僅直接點選選項則自然省略該行），最後附帶收斂結論總表。
- 需求訪談跨文件雙向織網 (End-to-End Requirement Traceability)：
  - 升級 `產品規格.md` 範本第 5 章：新增 `需求訪談依據：[[15 需求訪談/INTV-001-xxx|INTV-001 需求訪談]]`。
  - 升級 `協作任務.md` 範本第 1 章：`需求來源` 支援直接連結至 `[[15 需求訪談/INTV-001-xxx|INTV-001 需求訪談]]`。
  - 升級 `專案地圖.md` 範本與 `taxonomy-guide.md` 雙向織網矩陣：將需求訪談納入專案地圖里程碑與全局導航。

---

## [2.5.0] - 2026-10-13

### 新增與強化 (Added & Enhanced)
- 開局三層進度感知機制 (Session Startup Context Check)：
  - 於 `SKILL.md` 核心工作原則 4 與步驟一新增「開局進度盤點三部曲」：引導 AI Agent 在開啟新對話或接手既有專案時，主動依序讀取專案地圖（`MAP`）、進行中任務卡（`COLLAB`）與產品規格書（`SPEC`），即時掌握當前進度、中斷點與剩餘待辦事項。
- 專案地圖「進度與待辦看板 (Roadmap & Backlog)」升級：
  - 升級 `resources/templates/專案地圖.md` 與 `references/examples.md`：新增第 2 章「專案進度與待辦看板」，整合「進行中任務 (In Progress)」、「待辦事項清單 (Backlog / Todo)」與「已完成里程碑 (Completed)」，讓 AI 與開發者只需檢視 `MAP` 單一入口即可掌握全局進度。
  - 雙向進度同步：新建任務工單時自動列入 `MAP` 進行中任務；任務完成時移至已完成里程碑並回填 `SPEC` 驗收勾選。
- 版面純淨化與無星號輕量排版 (Clean Typography)：
  - 全面移除 `SKILL.md`、`references/taxonomy-guide.md` 及核心範本中不必要的多餘粗體星號（`**`）與斜體星號（`*`），依靠自然標題層級與清單結構呈現，減少視覺與 Token 雜訊，並保持 100% 正面提示詞引導。

---

## [2.4.0] - 2026-10-09

### 優化 (Refactored & Polished)
- **正面提示詞全面重構 (Positive Prompting Refactoring)**：
  - 全面審視並重構 `SKILL.md` 與 `references/taxonomy-guide.md`，將所有否定、限制或禁令語氣（如「嚴禁」、「絕不可」、「強制」、「嚴格限縮」等）重構為清晰、建設性的正面黃金路徑指引 (Positive Golden Path Guidance)。
  - **核心原則 7**：重寫為「筆記內文保持純淨」與「URI 跳轉連結的正確歸位」，以正面引導確立 Markdown 文件本體專注於標準正文、Frontmatter 與 Wiki-link，並使 URI 專門服務於對話互動。
  - **核心原則 6**：移除 `[MANDATORY]` 與 `[PRAGMATIC]` 等強迫式標籤，改以「視覺保真，完整沉澱」與「依複雜度靈活配置圖表」之正面最佳實踐呈現。
  - **步驟四 (MCP 操作)**：重構為「MCP 內容純淨回寫處理」，正面說明於編輯或回寫時確保僅保留純粹 Markdown 內文並過濾輔助系統行。
  - **關聯矩陣**：轉為正面說明「促進文件間雙向參照與追溯」，提升模型遵循主動織網與上下文連貫的意願與穩定度。

---

## [2.3.0] - 2026-10-09

### 新增與強化 (Added & Enhanced)
- **筆記內文純淨原則與 MCP 讀取清洗機制 (Clean Note Content & Sanitize MCP)**：
  - 確立核心工作原則 7「筆記內文純淨原則」：嚴禁在 Obsidian 筆記檔案本體（Markdown 實體）內部寫入自身之 `URI: obsidian://open?...` 或 URL 跳轉字串。
  - 明確界定 `obsidian://open` URI 唯一合法位置：僅允許且必須只出現在 IDE 對話框的回覆結尾 Callout 中，供使用者一鍵跳轉至 Obsidian。
  - 建立「MCP 讀取清洗規範」：透過 `get_vault_file` 讀取筆記進行編輯或回寫時，強制剝除 (Strip) MCP 伺服器自動附加之末尾 `URI:` 字尾，徹底根除重疊污染。
- **跨文件雙向織網機制 (Bi-Directional Interlinking Framework)**：
  - 升級 `resources/templates/協作任務.md` 範本：章節 1 增設明確的「關聯規格」與「參考研究」Wiki-link 欄位（`[[50 專案文件/SPEC-xxx|產品規格]]`、`[[20 研究/RES-xxx|調研筆記]]`）。
  - 升級 `resources/templates/研究筆記.md` 範本：章節 4 增設「落地協作任務」與「關聯規格文件」Wiki-link 欄位。
  - 升級 `resources/templates/產品規格.md` 範本：章節 5 明確規格與「前置技術調研」及「關聯協作任務」之 Wiki-link 結構。
  - 更新 `SKILL.md` 與 `references/taxonomy-guide.md`：建立雙向織網關聯矩陣 (Interlinking Matrix)，要求 Agent 建立任務時關聯規格、任務完成時反向回填追溯，杜絕孤島文件。

---

## [2.2.0] - 2026-10-06

### 新增與強化 (Added & Enhanced)
- **外部資源評估中樞 (`※_外部評估/`)**：
  - 確立全新全域頂層目錄 `※_外部評估/`，專門收錄使用者丟入之外部網址、Chrome 插件、第三方 GitHub 倉庫與 SaaS 服務之功能及資安評估。
  - 確立**扁平兩層分類機制**（`※_外部評估/<大主題領域>/EVA-YYYYMMDD-<主題>-<類型>.md`），避免三層過度巢狀造成維護負擔；多維屬性（來源類型、風險等級等）全面交由 Frontmatter 與 Dataview 篩選。
  - 推薦常見大主題領域（`01_AI與提示詞/`、`02_資安與檢測/`、`03_生活與訂閱服務/`、`04_開發與工程工具/` 等），未涵蓋者 AI 自動靈活建檔。
- **意圖感知自動歸檔（零提示詞自動建檔）**：
  - 在核心工作原則 4 增設「外部評估意圖感知觸發器」：凡對話中提及外部連結/第三方工具並詢問功能、可行性或資安風險時，AI 自動於背景完成分析並歸檔至 Obsidian，無需使用者反覆提醒。
- **全新外部評估範本 (`resources/templates/外部評估.md`)**：
  - 包含概況、安全性與隱私審查、功能亮點與痛點、費用機制、以及 AI 總結與操作守則。
- **跨 Client MCP 設定支援 (Antigravity & Codex)**：
  - 更新 `references/mcp-troubleshooting.md`，提供 Antigravity (`mcp_config.json`) 與 Codex (`~/.codex/config.toml`) 專屬之 Obsidian MCP 連線設定指引。
  - 更新 `references/frontmatter-spec.md` 與 `references/examples.md`（新增範例五：PromptGenius Chrome 插件評估）。

---

## [2.1.0] - 2026-10-05

### 新增與強化 (Added & Enhanced)
- **Mermaid 響應式排版最佳實踐 (Responsive Layout Best Practices)**：
  - 於「6. 圖表與視覺沉澱原則」增補 5 大響應式視覺排版規範，確保產出筆記在任何視窗與裝置均清晰可讀：
    1. **圖表寬度收斂於視窗內 (Compact Width)**：寬度控制於 1200px 內，避免分割視窗、筆記本模式與行動端橫向捲動。
    2. **子圖內部明確宣告 `direction TB`**：`subgraph` 第一行明確宣告垂直排列，確保版面行為穩定。
    3. **使用隱形垂直錨點堆疊並列節點 (`~~~`)**：列舉無因果關係節點時以隱形鏈接整齊堆疊為卡片欄位。
    4. **多步驟流程優先採用縱向佈局 (`flowchart TB`)**：超過 3 步之線性流程統一縱向排列，提供單欄流暢閱讀體驗。
    5. **多維比對優先採用 Markdown 表格**：矩陣對比場景優先採用輕量原生 Markdown 表格。
  - 同步更新 [`references/taxonomy-guide.md`](file:///w:/Source2/=skill/obsidian-docs/references/taxonomy-guide.md) Section 3.5。

---

## [2.0.0] - 2026-10-02

### 重大架構升級 (Major Architectural Refactor)
- **正面提示詞工程全面重構 (Positive Prompt Engineering Overhaul)**：
  - 全面檢視並重構 `SKILL.md`、`references/` 與 `resources/templates/`，將限制約束語句（如「嚴禁」、「禁止」、「不得」等負向否定詞）全面改寫為明確引導的正面提示詞（Positive Prompts）。
  - **核心效益**：引導 LLM 聚焦於「最佳實踐作業路徑（Golden Path）」與「應當完成的標準動作」，大幅提升指令遵循度（Instruction Adherence）並降低語言模型的抗性與非預期行為。
  - **原則升級**：
    - 「目錄架構原則」：清晰指引專案分流層級與有序歸檔路徑。
    - 「自包含與專案聚焦」：強化對當前專案資料夾的專屬作業與內部標準範本引用。
    - 「專用 MCP 工具操作」：明確宣導使用專用 Obsidian MCP 工具以實現無彈窗干擾、零對話阻礙的流暢背景同步。
    - 「實用導向靈活剪裁」：正面引導依專案業務特性靈活調適結構，維持精簡高價值產出。
    - 「視覺保真與完整沉澱」：指引完整保留 Mermaid、目錄樹、結構化表格等視覺元素，落實真實無損記錄。

---

## [1.9.0] - 2026-10-02

### 新增與強化 (Added & Enhanced)
- **圖表與視覺沉澱原則 (Visual-First & Presentation-Preserving Archiving)**：
  - 確立「**保真強制，生成自律**」雙軌制規範：
    1. **【強制保真】**：凡對話中為向使用者清晰說明而產生之 Mermaid 圖表、結構化表格、目錄樹、或生成之 UI 原型/架構圖片，歸檔至 Obsidian 時**強制 100% 原樣保留視覺格式**，嚴禁擅自簡化降級為純文字條列。
    2. **【資產歸檔】**：對話中產生之圖檔統一保存於 `<專案>/assets/` 目錄，並於筆記中以 `![[assets/<檔名>.png]]` 引用。
    3. **【複雜度導向】**：避免盲目無腦畫圖；3 步以內簡易單向線性流程維持純文字，涉及多角色時序、多狀態轉移或多表 ER 模型時才主動補圖。
- **指引與範本升級**：
  - 更新 `SKILL.md` 加入核心原則 6 與 SOP 資產規範。
  - 更新 `references/taxonomy-guide.md` 新增 Section 3.5「圖表與視覺沉澱指引」與 `assets/` 目錄結構。
  - 更新 `resources/templates/產品規格.md` 注入視覺沉澱引導註解。

---

## [1.8.0] - 2026-10-02

### 新增 (Added)
- **全新「70 資安審查/」分類目錄**：
  - 專屬歸檔資安相關產出：包含 SAST 靜態掃描（CodeQL, Semgrep）、弱點評估（security-audit）、PR 安全審查（security-review）、以及安全性修復 (Fix) 與複測驗證報告。
  - 統一採用大寫語意代號前綴 `SEC-`（如 `SEC-001-CodeQL掃描報告.md`、`SEC-002-SQL注入漏洞修復.md`）。
- **全新資安審查專用範本 (`resources/templates/資安審查.md`)**：
  - 包含弱點清單 (Findings)、CWE/危害評估、PoC 重現邏輯、修復前後 Diff 對照、複測指令與乾淨通過證據 (Zero Findings)、以及任務/CHANGELOG 關聯追蹤。
- **Frontmatter 屬性規格擴充 (`references/frontmatter-spec.md`)**：
  - 支援 `類型: 資安審查`。
  - 擴充專用欄位：`報告編號`、`風險等級`（嚴重/高危/中危/低危/資訊）、`檢測工具`（CodeQL/Semgrep 等）、`修復狀態`（待修復/修復中/已修復/誤報/接受風險）。
- **黃金示範手冊新增範例 (`references/examples.md`)**：
  - 新增「範例四：完整資安審查與修復報告」，提供完整的 SQL 注入修復與 CodeQL 複測示範。

---

## [1.7.0] - 2026-10-01

### 新增與強化 (Added & Enhanced)
- **換窗接力協議 (Session Handoff & Window Rollover SOP)**：
  - 新增「步驟六：換窗接力與進度歸檔」，當對話長度增加、使用者需要開新對話或交接其他 AI 時，自動在 `60 協作任務/` 更新最新斷點、已驗證事項與下一步動作。
  - 自動生成【一鍵換窗接力提示詞】，新視窗 AI 讀取後可瞬間透過 Obsidian MCP 抓取上下文（Context Rehydration），達到 0 資訊遺失的無縫接力。
- **協作任務範本結構升級 (`resources/templates/協作任務.md`)**：
  - 章節 5 升級為標準化接力結構：包含「最新狀態」、「已完成事項」、「當前中斷點 (Current Breakpoint)」、「下一步行動 (Next Action)」與「換窗接力提示詞」。
- **與 bootstrap-ai-project 協作架構對齊**：
  - 正式定義兩者協作模式：採用 100% 互通的 9 大目錄架構，共用 Obsidian 專案空間，將 `60 協作任務/` 作為所有 AI Agent（Coordinator / Worker）共享的單一事實來源。

---

## [1.6.0] - 2026-09-29

### 新增與強化 (Added & Enhanced)
- **完全自包含原則 (100% Self-Contained) 與嚴禁跨專案窺探**：
  - 新增最高指導原則：嚴禁 AI Agent 為當前專案建立或更新筆記時，讀取、檢視或列出 Vault 內其他既有專案之文件作為參考。
  - 嚴禁使用 PowerShell / Bash 等終端機指令（如 `Get-ChildItem`、`ls`、`dir`）探索 Obsidian Vault，所有操作強制透過 Obsidian MCP 完成。
- **去除真實專案範例 (De-identification)**：全面替換指引中殘留的真實專案名稱（如 `塔羅抽牌`、`obsidian-docs`），改為通用範例（`ecommerce-web`、`data-scraper`），杜絕 LLM 產生好奇心跑去檢視真實磁碟檔案之幻覺。
- **全新黃金示範手冊 (`references/examples.md`)**：提供一般專案與 SKILL 專案之完整專案地圖與產品規格書開箱即用範例，包含 Frontmatter 與 Dataview 語法，消除 AI 填寫時的任何不確定性。
- **範本變數指引優化**：更新 `resources/templates/專案地圖.md`，直接在範本中註記 `<專案名稱>` 與 `<專案路徑>` 之明確填寫公式。

---

## [1.5.0] - 2026-09-28

### 變更 (Changed)
- **※_SKILL 無空格路徑標準化**：將技能專案母目錄從 `※ SKILL/` 全面調整為 `※_SKILL/`，消除路徑中的空白字元，防止終端機指令、URL 跳脫、以及跨平台路徑解析之潛在相容性問題。
- **內部筆記與 Dataview 查詢同步更新**：全面更新 Obsidian 專案地圖 `MAP-obsidian-docs.md`（Dataview FROM `"※_SKILL/2026-09_obsidian-docs"`）、產品規格書 `SPEC-產品規格.md`、協作任務 `COLLAB-001` 等筆記內部之路徑與結構。
- **全域指引與規範同步**：更新 `SKILL.md`、`references/taxonomy-guide.md`，並修正 Frontmatter 屬性規則以確保 `專案` 與 `標籤` 屬性精簡無年月贅詞。

---

## [1.4.0] - 2026-09-28

### 變更 (Changed)
- **※ SKILL 目錄分流標準化**：技能專案在 Obsidian 中的母目錄全面正名為 `※ SKILL/`，徹底杜絕 `=` 符號觸發 Dataview 行內查詢的解析錯誤。
- **Dataview 動態總覽查詢同步**：專案地圖之 Dataview DQL 查詢路徑同步調整為 `FROM "※ SKILL/2026-09_obsidian-docs"`。
- **全域檔案與文檔同步修復**：修復 Obsidian 與技能倉庫內所有路徑為 `※ SKILL`。

---

## [1.3.0] - 2026-09-28

### 新增 (Added)
- **語意代號前綴體系 (Semantic Code Prefix System)**：
  - 專案文件全面拋棄冗長專案前綴與年月，改採大寫短代號命名：`SPEC-產品規格.md`、`CHANGELOG.md`、`MAP-<專案名>.md`、`COLLAB-001-xxx.md`、`RES-001-xxx.md`、`ADR-001-xxx.md`、`PROP-001-xxx.md`。
  - 側邊欄文字大幅縮減，文件類別與主題一目了然。
- **Wiki-link 結構化路徑別名規範**：在 Obsidian 內部連結一律採用 `[[目錄/代號檔名|顯示別名]]`（如 `[[50 專案文件/SPEC-產品規格|產品規格]]`），徹底解決同名檔案跨專案碰撞。
- **專案地圖 Dataview 防解析衝突規範**：專案地圖中之目錄結構強制使用 ```` ```text ```` 程式碼區塊呈現，消除 Dataview 將 `：=` 誤判為行內運算式的解析報錯。
- **Obsidian 專案筆記重構**：完成本專案在 Vault 內之檔案重命名與雙向路徑別名修正。

---

## [1.2.0] - 2026-09-28

### 新增 (Added)
- **兩層範本架構與演進機制 (Two-Tier Template Evolution)**：
  - 第一層：SKILL 全域範本庫（專案預設無需複製整套空白 `05 範本/`）。
  - 第二層：專案專用範本（當全域範本不合用時，AI 可自主在專案 `05 範本/` 建立並套用）。
  - 向上回饋擴充提議：若專案範本具高泛用性，AI 主動提示使用者收納進 SKILL 全域範本庫。
- **檔案命名與 Wiki-link 防碰撞規範**：
  - 閱讀類文件統一遵循 `<專案名稱>-<主題>.md`（如 `2026-09_obsidian-docs-產品規格.md`）。
  - 連結一律使用別名 `[[<專案名稱>-<主題>|<簡稱>]]`，徹底解決跨專案同名筆記碰撞問題。
- **Obsidian 筆記重構修復**：修正 `=SKILL/2026-09_obsidian-docs/` 下的檔案名稱與雙向連結。

---

## [1.1.0] - 2026-09-28

### 新增 (Added)
- **=SKILL 專案分流規範**：技能開發專案統一集中於 Obsidian `<Vault>/=SKILL/<YYYY-MM_專案名稱>/`，第三層起存放分類文件。
- **年份-月份專案命名規則**：所有專案一律遵循 `YYYY-MM_<專案名稱>` 格式（如 `2026-09_obsidian-docs`）。一般專案直接在最外層建立，SKILL 專案在 `=SKILL/` 內建立。
- **Obsidian 專案筆記初始化與歸檔**：透過 Obsidian MCP 成功在 `=SKILL/2026-09_obsidian-docs/` 建立專案地圖、產品規格、變更紀錄與 COLLAB-001 任務筆記。

---

## [1.0.0] - 2026-09-28

### 新增 (Added)
- **核心技能定義 (`SKILL.md`)**：提供自動歸檔、Project-First 組織、自適應分類與動態範本之核心 SOP。
- **分類架構指引 (`references/taxonomy-guide.md`)**：定義 9 大標準目錄、領域自適應擴展原則與 CHANGELOG 維護規範。
- **Properties 規範 (`references/frontmatter-spec.md`)**：定義標準中文化 YAML Frontmatter 格式與日期防呆要求。
- **MCP 監控與故障排除 (`references/mcp-troubleshooting.md`)**：規範連線健康檢查、連線中斷主動警告與本機檔案備援流程。
- **8 大預設參考範本 (`resources/templates/`)**：包含產品規格、變更紀錄、研究筆記、跨專案決策、協作任務、通用文件、AI 提案、專案地圖。
- **自動化腳本 (`scripts/`)**：
  - `scripts/test-skill.ps1`：檔案完整性、YAML 語法與無 BOM UTF-8 編碼驗證。
  - `scripts/install-global.ps1`：一鍵安全安裝/同步至全域 `~/.gemini/config/skills/obsidian-docs`，支援 `-WhatIf` 預覽。
- **需求與規格文檔 (`docs/`)**：包含訪談紀錄 (`docs/interviews/`) 與規格計畫書 (`docs/plans/`)。
