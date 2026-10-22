<#
.SYNOPSIS
    Deploy obsidian-docs skill to Antigravity global configuration.
.DESCRIPTION
    Installs into ~/.gemini/config/skills/obsidian-docs for system-wide availability.
.PARAMETER WhatIf
    Previews operations without making changes.
.PARAMETER Overwrite
    Overwrites target files if they exist. Default: $true.
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$Overwrite = $true
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillRoot = Split-Path -Parent $scriptDir

$globalSkillsDir = Join-Path $env:USERPROFILE ".gemini\config\skills"
$targetDir = Join-Path $globalSkillsDir "obsidian-docs"

Write-Host "=== Deploying obsidian-docs to global skills directory ===" -ForegroundColor Cyan
Write-Host "Source: $skillRoot"
Write-Host "Target: $targetDir"

if (-not (Test-Path $globalSkillsDir)) {
    if ($PSCmdlet.ShouldProcess($globalSkillsDir, "Create global skills directory")) {
        New-Item -ItemType Directory -Path $globalSkillsDir -Force | Out-Null
    }
}

$itemsToDeploy = @("SKILL.md", "references", "resources")

foreach ($item in $itemsToDeploy) {
    $srcItem = Join-Path $skillRoot $item
    $dstItem = Join-Path $targetDir $item

    if (-not (Test-Path $srcItem)) {
        Write-Warning "Source path not found, skipping: $srcItem"
        continue
    }

    if ($PSCmdlet.ShouldProcess("$srcItem -> $dstItem", "Sync item")) {
        if (Test-Path -Path $srcItem -PathType Container) {
            Copy-Item -Path $srcItem -Destination $targetDir -Recurse -Force
        } else {
            if (-not (Test-Path $targetDir)) {
                New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
            }
            Copy-Item -Path $srcItem -Destination $dstItem -Force
        }
    }
}

Write-Host "[SUCCESS] obsidian-docs global deployment completed!" -ForegroundColor Green
