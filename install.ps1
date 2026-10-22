# Claude Here installer
# Adds "Open in Claude" to the Windows right-click menu for folders, drives and folder backgrounds.
# Clicking it opens a new Claude Code session in the Claude desktop app for that folder.
#
# Run it with:  irm https://raw.githubusercontent.com/charlestbell/Claude-Here/main/install.ps1 | iex
# or double-click Install.cmd from a downloaded copy of this repo.

& {
    $ErrorActionPreference = 'Stop'

    $installDir = Join-Path $env:LOCALAPPDATA 'ClaudeHere'
    $launcher   = Join-Path $installDir 'open-in-claude.ps1'
    $menuKeys   = 'Directory\shell', 'Directory\Background\shell', 'Drive\shell'
    $label      = 'Open in Claude'

    # The launcher turns the clicked folder into a claude://code/new link the desktop app understands
    $launcherCode = @'
# Claude Here launcher: opens a new Claude Code session in the Claude desktop app for the given folder.
# https://github.com/charlestbell/Claude-Here
param([string]$Path)

# A drive root like "C:\" arrives as C:" because the trailing backslash escapes the quote
$Path = $Path.Trim('"')
if ($Path -match '^[A-Za-z]:$') { $Path += '\' }

Start-Process ('claude://code/new?folder=' + [uri]::EscapeDataString($Path))
'@

    Write-Host ''
    Write-Host 'Claude Here installer' -ForegroundColor Cyan
    Write-Host ''

    # The claude:// link handler is registered by the Claude desktop app
    $handler = Get-ItemProperty 'Registry::HKEY_CLASSES_ROOT\claude\shell\open\command' -ErrorAction SilentlyContinue
    if (-not $handler) {
        Write-Host 'The Claude desktop app does not seem to be installed.' -ForegroundColor Yellow
        Write-Host 'Install it from https://claude.ai/download, then run this installer again.'
        Write-Host ''
        return
    }

    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    Set-Content -Path $launcher -Value $launcherCode -Encoding UTF8

    $command = "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$launcher`" `"%V`""

    # Save the Claude app's own icon next to the launcher. A copy keeps working after Claude
    # updates move the app, and Explorer can always read it.
    $icon = $null
    if ($handler.'(default)' -match '^"([^"]+)"' -and (Test-Path $Matches[1])) {
        $claudeExe = $Matches[1]
        $icon = $claudeExe
        try {
            Add-Type -AssemblyName System.Drawing
            $icoPath = Join-Path $installDir 'claude.ico'
            # Icon.Save() drops to 16 colors, so write a one-image .ico holding a full-color PNG
            $bitmap = [Drawing.Icon]::ExtractAssociatedIcon($claudeExe).ToBitmap()
            $png = New-Object IO.MemoryStream
            $bitmap.Save($png, [Drawing.Imaging.ImageFormat]::Png)
            $pngBytes = $png.ToArray()
            $ico = New-Object IO.MemoryStream
            $w = New-Object IO.BinaryWriter($ico)
            $w.Write([uint16]0); $w.Write([uint16]1); $w.Write([uint16]1)          # header: icon, 1 image
            $w.Write([byte]$bitmap.Width); $w.Write([byte]$bitmap.Height)          # directory entry
            $w.Write([byte]0); $w.Write([byte]0); $w.Write([uint16]1); $w.Write([uint16]32)
            $w.Write([uint32]$pngBytes.Length); $w.Write([uint32]22)
            $w.Write($pngBytes)
            [IO.File]::WriteAllBytes($icoPath, $ico.ToArray())
            $icon = $icoPath
        } catch { }
    }

    foreach ($k in $menuKeys) {
        $key = "HKCU:\Software\Classes\$k\ClaudeHere"
        New-Item -Path "$key\command" -Force | Out-Null
        Set-ItemProperty -Path $key -Name '(default)' -Value $label
        if ($icon) { Set-ItemProperty -Path $key -Name 'Icon' -Value $icon }
        Set-ItemProperty -Path "$key\command" -Name '(default)' -Value $command
    }

    Write-Host "Done! Right-click any folder and choose '$label'." -ForegroundColor Green
    if ([Environment]::OSVersion.Version.Build -ge 22000) {
        Write-Host "On Windows 11 it is under 'Show more options' (or hold Shift while you right-click)."
    }
    Write-Host ''
}
