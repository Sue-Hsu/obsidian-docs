# Obsidian MCP 連線監控與故障通報指引 (MCP Troubleshooting)

本文件說明如何使用 Obsidian MCP 與本機回退機制，以及連線異常、子代理 401 授權問題時的排查與防護 SOP。

---

## 1. 跨 Client MCP 設定路徑與連線檢查 (Multi-Client Setup & Health Check)

先檢查目前可用的 MCP server 與工具；Obsidian Connector 的名稱可能包含識別碼，不能硬編碼為 `obsidian`。本機端點與設定格式以 Connector 目前的整合頁面為準，不從舊範例推定。

### 1.1 Antigravity Client 配置 (`mcp_config.json`)
- 設定檔路徑：`~/.gemini/config/mcp_config.json`（Windows: `C:\Users\<使用者>\.gemini\config\mcp_config.json`）
- 從 Connector 的 Antigravity 專用整合設定複製目前格式，使用獨立且可撤銷的 token；不要把 token 貼入 Repo、Vault 筆記、聊天或範例。

### 1.2 Codex Client 配置 (`config.toml`)
- 設定檔路徑：`~/.codex/config.toml`（Windows: `C:\Users\<使用者>\.codex\config.toml`）
- 優先用 Connector 的 Codex integration／Install Codex config。`[mcp_servers.<name>]` 的名稱可帶識別碼；用 `codex mcp list` 或目前工具清單查證。手動設定時讓 token 由本機 secret／環境變數管理，不寫入專案設定。

### 1.3 Claude Desktop / Claude Code 配置 (`claude_desktop_config.json`)
- 設定檔路徑：`~/.claude/claude_desktop_config.json`（Windows: `%APPDATA%\Claude\claude_desktop_config.json`）
- 於 `mcpServers` 區塊配置 Obsidian Connector，Token 透過環境變數或設定檔獨立維護。

### 1.4 Cursor / Windsurf 配置 (`mcp.json`)
- 設定檔路徑：專案或全域 `.cursor/mcp.json`（Windsurf: `~/.codeium/windsurf/mcp_config.json`）
- 依 IDE 設定介面填寫 Obsidian MCP 伺服器端點與授權標頭，確保與本機 Connector 保持同步。

### 1.5 連線健康檢查 (Health Check)
需要 Vault 作業前，先確認目前工具清單中有 Obsidian server，再依它實際提供的工具 schema 做唯讀連線／搜尋檢查；不要假設固定工具名稱、回應欄位或 server 名稱。

---

## 2. 異常通報 SOP（依訪談決策強制執行）

若呼叫 Obsidian MCP 工具時出現異常，Agent 必須立即向使用者發出警告，並依錯誤類型精確通報：

### 2.0 MCP 未連線或未掛載主動通報 (MCP Disconnected / Unmounted)
當環境尚未掛載 Obsidian MCP，或執行初期偵測到連線不存在時：

> [!WARNING]
> 偵測到 Obsidian MCP 尚未連線或未掛載
>
> 目前無法透過 MCP 與 Obsidian 知識庫連通。
> - 建議動作：請檢查 Obsidian 應用程式是否開啟，以及 Local REST API / MCP Connector 是否處於 Running 狀態。
> - 請問是否需要切換至「本機磁碟直接寫入」備援模式，或待您確認 MCP 連線後重試？

### 2.1 401 Unauthorized 憑證脫鉤通報規範 (Credential Drift)
當 Server 回傳 HTTP 401 時，表示身分驗證失敗，應明確識別並通報為憑證脫鉤。

> [!WARNING]
> Obsidian MCP 憑證驗證失敗 (401 Unauthorized)
>
> 偵測到與 Obsidian MCP Server 的認證失敗。
> - 根本原因：Client 端設定檔之 Token 與 Obsidian 外掛目前生效之 Token 不一致（憑證脫鉤）。常見於在 Obsidian 重新產生過 API 金鑰或外掛重載。
> - 建議動作：
>   1. 請至 Obsidian「設定 -> 社群外掛 -> MCP Connector」確認目前的 Token。
>   2. 同步更新 Client 設定檔（Antigravity: `~/.gemini/config/mcp_config.json`，Codex: `~/.codex/config.toml`）。
>   3. 安全提示：排查時僅核對 Token 首尾 4 碼，妥善保密完整金鑰，維護憑證安全。
>
> 請問是否需要切換至「本機磁碟直接寫入」備援模式，或待您更新 Token 後重試？

### 2.2 連線中斷或逾時通報規範 (Connection Refused / Timeout)
若發生連線逾時（Connection timeout）、連線被拒（ECONNREFUSED）或 500 錯誤：

> [!WARNING]
> Obsidian MCP 通道連線異常
>
> 偵測到與 Obsidian MCP Server (`http://127.0.0.1:27200/mcp`) 的連線中斷或失敗。
> - 可能原因：Obsidian 應用程式未開啟、MCP Connector 外掛未啟用，或連接埠衝突。
> - 建議動作：請檢查 Obsidian 中的 Local REST API / MCP Connector 外掛是否處於 Running 狀態。
>
### 2.3 Dataview 外掛未安裝或查詢失敗 (dataview_not_installed)
當調用 DQL 查詢工具回傳 `dataview_not_installed`、`dataview_not_ready` 或 `dataview_query_failed` 時：
- 根本原因：使用者尚未安裝或啟用 Obsidian Dataview 社群外掛，或索引尚未建置完成。
- 平滑降級機制：Agent 無需中斷工作流，立即切換為「靜態地圖索引模式」，改為讀取 `10 專案地圖/MAP-<專案名稱>.md` 頂部的 `> [!FOCUS]` 現況焦點指針，並精準存取目標卡片。
- 選用建議：在交付對話中以簡潔提示告知使用者可按需安裝 Dataview 外掛以獲得前端動態看板體驗。

---

## 3. 401 Unauthorized 根本原因診斷與排查清單

排查 401 錯誤時，遵循以下 4 項檢核標準：

1. 憑證一致性（Credential Drift - 最常見）：
   - 核對 Client 端設定檔與 Obsidian 外掛顯示的金鑰是否一致。
   - 重新生成金鑰後，必須重啟 IDE 或重載 MCP 服務以使新憑證生效。
2. Authorization Header 規格比對：
   - 確認外掛預期的驗證標頭規格（例如需帶 `Bearer <token>` 還是純 `<token>`，或是 `x-api-key`）。
3. Client 專屬身份對齊：
   - 在多客戶端外掛中，確認指派給 Antigravity 或 Codex 的專屬 Token 未被其他客戶端或預設金鑰覆蓋。
4. 憑證安全與脫敏防護：
   - 排查時一律採用脫敏遮罩（如 mxJU...42I），妥善保護金鑰資產安全（如 `mxJU...42I`）。

---

## 4. 本機檔案系統備援模式與沙盒感知預警 (Sandbox-Aware Fallback)

當使用者確認 MCP 暫時無法修復，但希望繼續寫入時，方可切換至本機備援：

### 4.1 沙盒跨目錄感知預警 (重要)
- 若當前對話的工作區位於專案程式碼目錄（例如 /workspace/my-project/ 或 C:\Projects\my-project\），而寫入目標為外部的 Obsidian Vault（例如 /path/to/vault/ 或 C:\Obsidian\Vault\）：
- Agent 必須主動向使用者說明：
  > 「由於當前工作區為專案程式庫，退回本機寫入時將跨目錄存取外部 Vault，會觸發 IDE 安全沙盒的逐次權限授權確認視窗。建議修復 MCP Token 以獲得流暢體驗，或請確認授權本機寫入。」

### 4.2 本機落盤執行規範
1. 確認 Obsidian Vault 的本機絕對路徑（例如：使用者告知之路徑，或已知的 Vault 路徑）。
2. 使用原生檔案寫入工具（`write_to_file` 或 `replace_file_content`）直接寫入對應的 Markdown 檔案。
3. 嚴格遵守相同的 Frontmatter 規範與 LF / UTF-8 編碼要求。

---

## 5. 子代理自主寫入權能與防並發架構 (Subagent Direct Write & Concurrency Safety)

在多代理（Multi-Agent）協作場景下，子代理的文檔處理遵循「自主落盤、防範衝突、靈活降級」三大原則：

### 5.1 子代理自主寫入原則 (Direct Write Permitted)
- 子代理可以直接寫入檔案：當子代理具備檔案寫入工具或繼承連線通道時，允許子代理直接建立與維護其職責範圍內的獨立專案筆記（例如獨立的研究調研 `20 研究/RES-`、訪談紀錄 `15 需求訪談/INTV-`、或被指派的協作任務卡 `60 協作任務/COLLAB-`）。
- 效益：免除子代理將大量內文回傳給主代理二次轉發的 Context 稀釋與等待延遲。

### 5.2 核心文件防並發衝突防線 (Concurrency & SSOT Safety)
- 多代理並發防護：若同時存在多個平行運作的子代理，專案共用核心文件一律由主代理在收斂成果時統一更新，維持單一寫入來源：
  - `10 專案地圖/MAP-<專案名稱>.md`
  - `50 專案文件/SPEC-產品規格.md`
  - `50 專案文件/CHANGELOG.md`
- 治理邊界：共用核心文件一律由主代理（或主要負責的協調者）在彙整各子代理產出後統一更新，避免引發寫入覆寫衝突（Race Condition）。

### 5.3 子代理 401 異常時的集中 I/O 降級
- 若子代理在特定獨立容器或隔離子環境運行，因環境變數未繼承導致呼叫 MCP 出現 401 Unauthorized 時，子代理應將產出之純 Markdown 內文回傳給主代理，由主代理代為統一寫入落盤。

