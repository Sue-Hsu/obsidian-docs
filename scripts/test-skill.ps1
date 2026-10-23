<#
.SYNOPSIS
    Verify obsidian-docs skill integrity and encoding standard.
#>

[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillRoot = Split-Path -Parent $scriptDir

Write-Host "=== Validating obsidian-docs skill ===" -ForegroundColor Cyan
Write-Host "Skill root: $skillRoot"

$errors = [System.Collections.Generic.List[string]]::new()

# 1. Check SKILL.md
$skillMdPath = Join-Path $skillRoot "SKILL.md"
if (-not (Test-Path $skillMdPath)) {
    $errors.Add("Missing core file: SKILL.md")
} else {
    $content = [System.IO.File]::ReadAllText($skillMdPath, [System.Text.Encoding]::UTF8)
    if (-not ($content -match "(?s)^---\r?\nname:\s*obsidian-docs\r?\ndescription:.*?---")) {
        $errors.Add("SKILL.md frontmatter is invalid or missing required fields")
    }
}

# 2. Check references
$expectedRefs = @(
    "taxonomy-guide.md",
    "frontmatter-spec.md",
    "mcp-troubleshooting.md",
    "examples.md"
)
foreach ($ref in $expectedRefs) {
    $refPath = Join-Path $skillRoot "references\$ref"
    if (-not (Test-Path $refPath)) {
        $errors.Add("Missing reference: references\$ref")
    }
}

# 3. Check resources/templates
$templateDir = Join-Path $skillRoot "resources\templates"
if (-not (Test-Path $templateDir)) {
    $errors.Add("Missing directory: resources\templates")
} else {
    $existingTemplates = Get-ChildItem -Path $templateDir -Filter "*.md"
    if ($existingTemplates.Count -lt 10) {
        $errors.Add("Expected at least 10 template files in resources\templates, found $($existingTemplates.Count)")
    }
}

# 4. Check for UTF-8 BOM
$mdFiles = Get-ChildItem -Path $skillRoot -Recurse -Filter "*.md"
foreach ($file in $mdFiles) {
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        $errors.Add("File has UTF-8 BOM (Rule 6 violation): $($file.FullName)")
    }
}

# 5. Check collaboration and template boundaries
$taskTemplate = [System.IO.File]::ReadAllText((Join-Path $templateDir "協作任務.md"))
$mapTemplate = [System.IO.File]::ReadAllText((Join-Path $templateDir "專案地圖.md"))
$generalTemplate = [System.IO.File]::ReadAllText((Join-Path $templateDir "通用文件.md"))
if ($taskTemplate -match '(?m)^狀態維護者:\s*"Antigravity"') {
    $errors.Add("Collaboration task template must not hard-code Antigravity as status writer")
}
if ($taskTemplate -notmatch '待審閱' -or $taskTemplate -notmatch '驗收交接') {
    $errors.Add("Collaboration task template must support review handoff")
}
if ($mapTemplate -notmatch 'FROM "<專案路徑>/60 協作任務"' -or
    $mapTemplate -match '### 進行中任務') {
    $errors.Add("Project Map must derive task status instead of duplicating a manual board")
}
if ($mapTemplate -notmatch '(?s)^---\r?\n.*?\r?\n---\r?\n> \[!FOCUS\]') {
    $errors.Add("Project Map focus pointer must immediately follow frontmatter")
}
if ($generalTemplate -notmatch '(?m)^對應版本:' -or $generalTemplate -notmatch '(?m)^關聯PR:') {
    $errors.Add("Technical document template must support code-version evidence")
}

# 6. Check SKILL.md and examples.md rules alignment
$examplesPath = Join-Path $skillRoot "references\examples.md"
if (Test-Path $examplesPath) {
    $examplesContent = [System.IO.File]::ReadAllText($examplesPath, [System.Text.Encoding]::UTF8)
    if ($examplesContent -match '### 進行中任務') {
        $errors.Add("references/examples.md must not contain stale manual roadmap board (### 進行中任務)")
    }
    if ($examplesContent -match '\[\[docs/PROJECT') {
        $errors.Add("references/examples.md must not use Vault wiki-links for repo files outside the vault")
    }
    if ($examplesContent -match '(?m)^狀態:\s*已審閱' -or $examplesContent -match '(?m)^狀態:\s*已定案') {
        $errors.Add("references/examples.md must not contain non-spec status (已審閱 / 已定案)")
    }
}
if ($content -match '檢視「專案進度與待辦看板') {
    $errors.Add("SKILL.md must not reference stale manual roadmap board instructions")
}
if ($content -match '(?m)^- `狀態`：`草稿`、`使用中`、`進行中`、`已定案`') {
    $errors.Add("SKILL.md must partition document and task status per frontmatter-spec.md")
}

# 7. Check templates default status against frontmatter-spec
$allowedDocStatuses = @("草稿", "提案中", "已驗證", "使用中", "已取代", "已廢棄")
$allowedTaskStatuses = @("待辦", "規劃中", "進行中", "待審閱", "受阻", "完成")
foreach ($tmpl in $existingTemplates) {
    $tmplContent = [System.IO.File]::ReadAllText($tmpl.FullName, [System.Text.Encoding]::UTF8)
    if ($tmplContent -match '(?m)^狀態:\s*([^\r\n]+)') {
        $statusVal = $matches[1].Trim().Trim('"').Trim("'")
        $isTask = ($tmpl.Name -eq "協作任務.md")
        $valid = if ($isTask) { $allowedTaskStatuses -contains $statusVal } else { $allowedDocStatuses -contains $statusVal }
        if (-not $valid) {
            $errors.Add("Template $($tmpl.Name) has invalid status '$statusVal' per frontmatter-spec.md")
        }
        if (-not $isTask -and $statusVal -eq "已驗證") {
            $errors.Add("Template $($tmpl.Name) must not default to '已驗證' without evidence")
        }
    }
}

# 8. Output results
if ($errors.Count -eq 0) {
    Write-Host "[SUCCESS] All verification checks passed!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "[FAILED] Found $($errors.Count) error(s):" -ForegroundColor Red
    foreach ($err in $errors) {
        Write-Host "  - $err" -ForegroundColor Yellow
    }
    exit 1
}
