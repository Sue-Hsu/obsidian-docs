# 外部評估報告範例 (External Resource Evaluation Examples)

本文件收錄針對非本專案開發之外部工具、第三方 GitHub 倉庫、Chrome 擴充或 SaaS 服務進行安全性與可行性評估的標準範例。

---

## 範例一：Chrome 插件安全性與功能外部評估報告

適用情境：使用者詢問外部 Chrome 擴充套件、GitHub 庫或第三方工具之權限與安全性分析。
對應範本：`resources/templates/外部評估.md`
目標目錄：`※_外部評估/01_AI與提示詞/EVA-20261006-PromptGenius-Chrome插件.md`

### 檔案完整內容：

```markdown
---
類型: 外部評估
評估主題: PromptGenius
來源網址: "https://chromewebstore.google.com/detail/prompt-genius/xxx"
來源類型: Chrome插件
評估目的: 綜合評估
風險等級: 低危 (Low)
建立日期: 2026-10-06
修改日期: 2026-10-06
評估AI: Antigravity
狀態: 草稿
密等: 內部使用
標籤:
  - 外部評估
  - 主題/AI與提示詞
  - 來源/Chrome插件
---

# EVA-20261006-PromptGenius 外部評估報告

> [!NOTE]
> 本文件為示範外部評估報告結構之虛構假設草案 (Hypothetical Draft)。依核心工作原則，AI 僅在使用者明確要求保存或已授權流程指定記錄時始建立歸檔；所載權限與隱私安全性分析為範例格式示意，非實測依據。

---

## 1. 評估對象概況 (Overview)
- 主題名稱：PromptGenius
- 來源類型：Chrome插件
- 原始網址：https://chromewebstore.google.com/detail/prompt-genius/xxx
- 核心定位與主要功能：支援在 ChatGPT 介面側邊欄快速儲存、分類與插入常用提示詞範本。

## 2. 安全性與隱私審查 (Security & Privacy Audit)
- 權限存取分析：宣告 `storage` 權限；`host_permissions: ["https://chatgpt.com/*"]`，未請求全局 `<all_urls>`。
- 資料傳輸與隱私政策：提示詞儲存於本機 Local Storage，未發現外連第三方伺服器。
- 潛在風險識別：低危，目前版本為純本地前端執行。

## 3. AI 總結與評估結論
- 總體推薦度：推薦 (Recommended)
- 核心結論：權限劃分乾淨、無不必要隱私收集，為提升效率的輕量安全擴充工具。
```
