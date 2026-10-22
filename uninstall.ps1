# Claude Here uninstaller
# Removes "Open in Claude" from the right-click menu and deletes the launcher.
#
# Run it with:  irm https://raw.githubusercontent.com/charlestbell/Claude-Here/main/uninstall.ps1 | iex
# or double-click Uninstall.cmd from a downloaded copy of this repo.

& {
    $installDir = Join-Path $env:LOCALAPPDATA 'ClaudeHere'

    foreach ($k in 'Directory\shell', 'Directory\Background\shell', 'Drive\shell') {
        Remove-Item "HKCU:\Software\Classes\$k\ClaudeHere" -Recurse -Force -ErrorAction SilentlyContinue
    }
    Remove-Item $installDir -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host ''
    Write-Host "Claude Here is uninstalled. 'Open in Claude' is gone from the right-click menu." -ForegroundColor Green
    Write-Host ''
}
