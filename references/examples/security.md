# 資安審查範例：總覽儀表板與檢測報告 (Security Examples)

本文件收錄資安領域的標準對照示範，包含全局態勢儀表板（`SEC-000`）與具體檢測報告（`SEC-xxx`）。AI Agent 於進行資安規劃、工具掃描、弱點評估或複測驗證時，優先讀取本文件以精準掌握結構。

---

## 範例一：企業級資安態勢總覽儀表板（`SEC-000` 示範）

適用情境：專案建立 `70 資安審查/` 時作為首篇必備總覽，或每次完成工具掃描後同步更新整體態勢。
對應範本：`resources/templates/資安總覽.md`
目標目錄：`2026-10_ecommerce-web/70 資安審查/SEC-000-資安審查總覽.md`

### 檔案完整內容：

```markdown
---
類型: 資安總覽
專案: ecommerce-web
報告編號: "SEC-000"
評估編號: "ASM-20261022-01"
評估模式: 綜合評估
來源版本: "main @ commit:a1b2c3d"
驗證狀態: 發現弱點 (FAIL)
風險等級: 低危 (Low)
檢測工具: "Semgrep OSS v1.90.0 / Gitleaks v8.18.0 / OWASP ZAP v2.14.0 / Trivy v0.50.0"
修復狀態: 修復中
資安放行建議: 條件式放行
實際發布授權: 未授權
建立日期: 2026-10-15
修改日期: 2026-10-22
密等: 內部使用
狀態: 使用中
標籤:
  - 資安總覽
  - 資安審查
  - 專案/ecommerce-web
---

# SEC-000 資安審查總覽 (ecommerce-web)

> [!FOCUS] 資安現況焦點 (Security Focus)
> - 當前整體安全評級：部分範圍已測（SAST/SCA/Secrets 通過，DAST 待複測，整體低風險）
> - 弱點總數統計（誠實原則：僅實測範圍可填 0；未受測範圍標示為未知或 NOT_TESTED）：
>   - 目前未結案弱點：嚴重 (Critical): 0 | 高危 (High): 0 | 中危 (Medium): 0 | 低危 (Low): 1 | 資訊 (Info): 1
>   - 已處置與排除統計：已修復: 1 | 接受風險: 0 | 誤報: 0
>   - 未受測範圍: 外部網路滲透測試 (NOT_TESTED)
> - 資安放行建議 (Security Gate)：條件式放行（技術安全門檻：待修復 HSTS 標頭並完成預覽環境複測）
> - 實際發布授權 (Release Authorization)：未授權（尚未取得正式生產環境部署及 DNS 變更審批）
> - 當前適用基準版本：main @ commit:a1b2c3d
> - 最新評估依據報告：[[2026-10_ecommerce-web/70 資安審查/SEC-005-相依套件漏洞檢測|SEC-005]]（日期：2026-10-22）
> - 下一步資安行動：修復 `public/_headers` 中缺失之 HSTS 標頭，並排程開發依賴套件升級

本文件為 `ecommerce-web` 專案之資安唯一事實來源 (SSOT) 與總體態勢儀表板。專案地圖僅保留一句最新資安態勢指標及本文件連結；所有工具版本、掃描歷程、弱點詳情與實測證據集中收納於本文件與各別 SEC 報告中。

---

## 1. 當前安全水位與放行審查 (Overall Security Posture & Release Gate)

- 最近一次全面評估日期：2026-10-22
- 當前受測版本與基準：分支 main @ commit:a1b2c3d
- 當前授權邊界與測試範圍：本機核心流程與單元測試 100% 通過，受控預覽環境已限制存取白名單；未授權外部網路破壞性滲透測試。
- 核心防護機制與各領域驗證現況：
  - 機密保護 (Secrets)：通過 (PASS) — Git 歷史與產物目錄經 Gitleaks 掃描確認 0 憑證殘留，見 [[2026-10_ecommerce-web/70 資安審查/SEC-002-Gitleaks掃描結果|SEC-002]]。
  - 靜態分析 (SAST)：通過 (PASS) — 代碼語意與型別檢測通過，0 發現（受限於開源規則集覆蓋），見 [[2026-10_ecommerce-web/70 資安審查/SEC-003-Semgrep靜態掃描|SEC-003]]。
  - 動態檢測 (DAST)：發現弱點 (FAIL) — 受控預覽端點完成安全標頭掃描，缺失 HSTS 標頭待修復，見 [[2026-10_ecommerce-web/70 資安審查/SEC-004-ZAP動態檢測結果|SEC-004]]。
  - 依賴安全 (SCA)：通過 (PASS) — 正式執行期相依 0 已知 CVE 漏洞，見 [[2026-10_ecommerce-web/70 資安審查/SEC-005-相依套件漏洞檢測|SEC-005]]。
  - 架構與授權審查：未受測 (NOT_TESTED) — 外部網路主動滲透測試尚未排程。
- 放行判定與簽核結論（職責分離）：
  - 資安放行建議：條件式放行（技術防護門檻達到內部受控預覽標準）
  - 實際發布授權：未授權（尚未取得發布審批委員會 CAB 與產品負責人正式部署與公開發布許可）
  - 放行依據與限制條件：待 HSTS 修正上線並於預覽環境複測通過後，始得提請正式發布授權。

---

## 2. 未結案弱點追蹤表 (Open Findings & Action Items)

| 弱點編號 | 弱點類型 / CWE | 風險等級 | 影響元件或檔案 | 弱點確認狀態 | 修復狀態 | 複測狀態 | 處置策略與進度 | 對應協作任務 | 來源報告 |
|---|---|---|---|---|---|---|---|---|---|
| FIND-01 | CWE-523 Missing HSTS Header | 低危 (Low) | `public/_headers` | 已確認 | 修復中 | 未複測 | 已配置候選標頭，排定部署後複測 | [[2026-10_ecommerce-web/60 協作任務/COLLAB-012-安全標頭調整|COLLAB-012]] | [[2026-10_ecommerce-web/70 資安審查/SEC-004-ZAP動態檢測結果|SEC-004]] |
| FIND-02 | CWE-1395 Dev Dependency Notice | 資訊 (Info) | `package.json (bundler)` | 已確認 | 待修復 | 未複測 | 列入下個迭代套件定期升級排程 | [[2026-10_ecommerce-web/60 協作任務/COLLAB-015-套件定期更新|COLLAB-015]] | [[2026-10_ecommerce-web/70 資安審查/SEC-005-相依套件漏洞檢測|SEC-005]] |

> [!NOTE]
> - 弱點確認狀態：`待確認` / `已確認` / `誤報`
> - 修復狀態：`待修復` / `修復中` / `已修復` / `接受風險` / `不適用`
> - 複測狀態：`未複測` / `通過` / `未通過` / `不適用`

---

## 3. 檢測工具與防禦覆蓋矩陣 (Tool & Domain Coverage Matrix)

| 檢測領域 (Domain) | 採用工具與版本 | 檢測規則集 | 最新執行日期 | 驗證狀態 | 覆蓋限制與說明 | 對應報告鏈接 |
|---|---|---|---|---|---|---|
| 秘密掃描 (Secrets) | Gitleaks v8.18.0 | 全庫 Commit 歷史與產物 | 2026-10-18 | 通過 (PASS) | 覆蓋正則模式；未覆蓋私有加密金鑰 | [[2026-10_ecommerce-web/70 資安審查/SEC-002-Gitleaks掃描結果|SEC-002]] |
| 靜態分析 (SAST) | Semgrep OSS v1.90.0 | p/default, p/owasp-top-ten | 2026-10-19 | 通過 (PASS) | 覆蓋後端 TypeScript；未覆蓋前端樣式 | [[2026-10_ecommerce-web/70 資安審查/SEC-003-Semgrep靜態掃描|SEC-003]] |
| 動態檢測 (DAST) | OWASP ZAP v2.14.0 | 安全標頭檢測規則 | 2026-10-21 | 發現弱點 (FAIL) | 僅受控預覽端點；未執行破壞性滲透測試 | [[2026-10_ecommerce-web/70 資安審查/SEC-004-ZAP動態檢測結果|SEC-004]] |
| 依賴掃描 (SCA) | Trivy v0.50.0 / npm audit | CVE 資料庫最新同步 | 2026-10-22 | 通過 (PASS) | 覆蓋直接與間接相依；未覆蓋私有模組 | [[2026-10_ecommerce-web/70 資安審查/SEC-005-相依套件漏洞檢測|SEC-005]] |
| 架構與授權審查 | 手動架構稽核 | OWASP API Security | 2026-10-15 | 通過 (PASS) | 金流簽章防偽與授權校驗通過 | [[2026-10_ecommerce-web/70 資安審查/SEC-001-資安基準規劃|SEC-001]] |

---

## 4. 歷次審查報告全景清冊 (Audit Log Register)

| 報告編號 | 審查主題與對象 | 評估模式 | 檢測工具與版本 | 執行日期 | 主要結論與驗證狀態 |
|---|---|---|---|---|---|
| [[2026-10_ecommerce-web/70 資安審查/SEC-005-相依套件漏洞檢測|SEC-005]] | 生產與開發相依套件漏洞掃描 | 依賴分析 (SCA) | Trivy v0.50.0 | 2026-10-22 | 正式相依 0 漏洞 / 通過 (PASS) |
| [[2026-10_ecommerce-web/70 資安審查/SEC-004-ZAP動態檢測結果|SEC-004]] | 受控預覽環境安全標頭檢測 | 動態檢測 (DAST) | OWASP ZAP v2.14.0 | 2026-10-21 | 缺失 HSTS 標頭 / 發現弱點 (FAIL) |
| [[2026-10_ecommerce-web/70 資安審查/SEC-003-Semgrep靜態掃描|SEC-003]] | 核心購物車與結帳模組 SAST | 靜態分析 (SAST) | Semgrep OSS v1.90.0 | 2026-10-19 | 0 發現 (受限於規則集) / 通過 (PASS) |
| [[2026-10_ecommerce-web/70 資安審查/SEC-002-Gitleaks掃描結果|SEC-002]] | 全歷史與發布產物金鑰排查 | 秘密掃描 (Secrets) | Gitleaks v8.18.0 | 2026-10-18 | 確認無憑證殘留 / 通過 (PASS) |
| [[2026-10_ecommerce-web/70 資安審查/SEC-001-資安基準規劃|SEC-001]] | 上線前資安檢測維度與工具規劃 | 規劃 | 手動架構稽核 | 2026-10-15 | 確立四大檢測維度 / 通過 (PASS) |

---

## 5. 機密保護、原始報告與受控證據管制 (Confidentiality & Evidence Control)

本專案遵循 ISO 27001 資訊資產保護原則實施受控管理：
- 密等分級治理：本脫敏資安總覽預設標記為「內部使用」。若衍生之專題報告包含可利用弱點 PoC、帳戶資訊、內部拓撲或敏感路徑時強制標為「機密」；對外版本須另行於發布目錄完成去識別化脫敏與發布審查。
- 原始掃描報告受控存放：原始掃描報告優先保存在 Git repo 與 Obsidian Vault 之外的獨立受控安全儲存體（例如安全伺服器存檔目錄）。若暫存於 repo 內，須確認已排除於 Git、建置產物及部署內容，並移除 Cookie、token、Session、私人郵件、帳戶識別資訊 (PII) 及完整請求內容。Vault 內只保留脫敏摘要、檔案完整性雜湊 (SHA-256)、保存期限與受控位置說明。
- 安全清理與銷毀程序：期滿清理時，依儲存媒體與平台採用可驗證的永久刪除、加密金鑰銷毀或組織核准的資料清理程序。
```

---

## 範例二：具體資安審查報告（`SEC-003` 靜態掃描示範）

適用情境：記錄特定工具掃描、弱點分析、修復方案前後 Diff 與複測客觀證據。
對應範本：`resources/templates/資安審查.md`
目標目錄：`2026-10_ecommerce-web/70 資安審查/SEC-003-Semgrep靜態掃描.md`

### 檔案完整內容：

```markdown
---
類型: 資安審查
專案: ecommerce-web
報告編號: "SEC-003"
評估編號: "ASM-20261019-01"
評估模式: 靜態分析 (SAST)
來源版本: "main @ commit:c7d8e9f"
驗證狀態: 通過 (PASS)
風險等級: 低危 (Low)
檢測工具: "Semgrep OSS v1.90.0"
修復狀態: 已修復
資安放行建議: 建議放行
實際發布授權: 不適用
建立日期: 2026-10-19
修改日期: 2026-10-19
密等: 內部使用
狀態: 使用中
標籤:
  - 資安審查
  - 專案/ecommerce-web
---

# SEC-003 核心購物車與結帳模組 SAST 代碼掃描

> [!NOTE]
> 本文件記錄針對購物車與結帳服務核心邏輯之靜態代碼安全檢測、工具版本、覆蓋限制與驗證結果。

---

## 1. 審查目標、授權範圍與執行背景 (Scope & Authorization)
- 審查目的：結帳金流串接上線前靜態代碼安全審計。
- 評估模式：靜態分析 (SAST)
- 測試對象與來源版本：`src/services/cart/` 與 `src/services/checkout/`（`main @ commit:c7d8e9f`）。
- 授權依據與邊界：依據任務卡 [[2026-10_ecommerce-web/60 協作任務/COLLAB-003-金流Webhook串接|COLLAB-003]] 授權執行本地靜態分析。
- 執行日期：2026-10-19
- 原始受控報告保存參照：
  - 儲存位置說明：儲存於 Git 與 Vault 之外的獨立受控安全儲存體 `/secure-artifacts/security/semgrep-20261019.json`
  - 完整性雜湊 (SHA-256)：`a7c3e5f88921b0451a329d661e7b8f99401209b5eef9221147dc8a45cfb20199`
  - 保存期限：90 天
  - 清理與銷毀程序：依儲存媒體與平台採用可驗證的永久刪除或加密金鑰銷毀程序

---

## 2. 工具版本與檢測範圍限制 (Tools, Rulesets & Coverage Limitations)
- 採用工具與版本：Semgrep OSS v1.90.0
- 檢測規則集：`p/default`, `p/owasp-top-ten`, `p/jwt`
- 覆蓋範圍與限制說明：
  - 納入檢測：所有 TypeScript 後端業務邏輯與 API Handler。
  - 排除範圍：靜態 UI 資源與第三方相依套件。
  - 工具能力邊界提示：本檢測僅涵蓋已定義規則之靜態語意模式；不包含動態執行期授權檢查與環境變數注入檢驗。

---

## 3. 弱點與風險清單 (Findings Register)

| 弱點編號 | 弱點類型 / CWE | 嚴重等級 | 影響檔案與行號 | 弱點確認狀態 | 修復狀態 | 複測狀態 | 對應任務卡 |
|---|---|---|---|---|---|---|---|
| FIND-01 | CWE-20 Insecure Direct Object Reference | 中危 (Medium) | `src/services/cart/cart.service.ts:88` | 已確認 | 已修復 | 通過 | [[2026-10_ecommerce-web/60 協作任務/COLLAB-008-購物車防護|COLLAB-008]] |

> [!NOTE]
> - 弱點確認狀態：`待確認` / `已確認` / `誤報`
> - 修復狀態：`待修復` / `修復中` / `已修復` / `接受風險` / `不適用`
> - 複測狀態：`未複測` / `通過` / `未通過` / `不適用`

---

## 4. 弱點詳情與概念驗證 (Vulnerability Details - 去識別化)

### 4.1 FIND-01: 購物車項目刪除缺少租戶與用戶所有權檢驗
- 問題描述：刪除購物車單項商品時，僅驗證 cartItemId，未校驗當前登入用戶之 userId。
- 危害等級與影響：水平越權 (IDOR)，可能導致惡意使用者遍歷刪除其他顧客之購物車內容。
- 觸發邏輯（已脫敏）：
  ```typescript
  // 修正前：直接依傳入 id 刪除
  await db.cartItem.delete({ where: { id: inputCartItemId } });
  ```

---

## 5. 修復方案與實作 (Remediation & Fix)
- 根本原因分析：資料存取層缺少複合鍵約束。
- 修正措施說明：加入 `userId` 複合查詢條件，非擁有者拋出 `403 Forbidden`。
- 程式碼修復前後對照 (Diff - 已脫敏)：
  ```diff
  - await db.cartItem.delete({ where: { id: inputCartItemId } });
  + await db.cartItem.delete({ where: { id: inputCartItemId, cart: { userId: session.userId } } });
  ```

---

## 6. 複測命令、實測證據與驗證結論 (Verification Evidence)
- 複測指令與環境：
  ```bash
  semgrep scan --config p/owasp-top-ten --error src/services/cart/
  ```
- 實測客觀證據摘要：
  ```text
  Ran 142 rules on 18 files: 0 findings.
  Scan completed with exit code 0.
  ```
- 驗證結論：通過 (PASS) — 弱點已消除，符合驗收標準；工具 0 發現受限於上述規則集覆蓋範圍。
- 放行評估與授權現況：
  - 資安放行建議：建議放行（核心購物車模組 SAST 技術門檻通過，0 殘留風險）
  - 實際發布授權：不適用（單一模組靜態檢測報告不具備發布授權決策權，由總覽 SEC-000 與發布審批委員會統一治理）

---

## 7. 關聯追蹤與儀表板同步 (Traceability)
- 資安總覽儀表板：[[2026-10_ecommerce-web/70 資安審查/SEC-000-資安審查總覽|SEC-000 資安審查總覽]]
- 對應協作任務：[[2026-10_ecommerce-web/60 協作任務/COLLAB-008-購物車防護|COLLAB-008 購物車防護]]
- 變更紀錄：[[2026-10_ecommerce-web/50 專案文件/CHANGELOG|變更紀錄]]
- 專案地圖：[[2026-10_ecommerce-web/10 專案地圖/MAP-ecommerce-web|專案地圖]]
```
