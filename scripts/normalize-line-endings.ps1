# Normalize all Markdown files to UTF-8 without BOM and LF endings
$targetDirs = @('.', 'references', 'references/examples', 'resources/templates')
$files = Get-ChildItem -Path . -Recurse -Include *.md | Where-Object { $_.FullName -notmatch '\\\.git\\' }

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    # Replace CRLF with LF
    $contentLf = $content -replace "\r\n", "`n"
    [System.IO.File]::WriteAllText($file.FullName, $contentLf, $utf8NoBom)
    Write-Output "Normalized: $($file.Name)"
}
Write-Output "All markdown files normalized to LF."
