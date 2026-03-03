$ErrorActionPreference = "Stop"

function Fail($msg) {
    Write-Host ""
    Write-Host "ERROR: $msg" -ForegroundColor Red

    exit 1
}

try {
    Write-Host "Scanning backup folders..."

    $scriptDir  = Split-Path -Parent $MyInvocation.MyCommand.Path
    $backupRoot = Join-Path $scriptDir "backup"

    if (-not (Test-Path $backupRoot)) {
        Fail "Backup folder not found."
    }

    $folders = Get-ChildItem $backupRoot -Directory |
               Sort-Object Name -Descending

    if ($folders.Count -eq 0) {
        Fail "No backup folders found."
    }

    Write-Host ""
    Write-Host "Available backups:"
    Write-Host "-------------------"

    for ($i = 0; $i -lt $folders.Count; $i++) {
        $rawName = $folders[$i].Name

        if ($rawName -match '^\d{14}$') {
            $dt = [datetime]::ParseExact(
                $rawName,
                "yyyyMMddHHmmss",
                $null
            )

            $display = $dt.ToString("yyyy-MM-dd HH:mm:ss")
            Write-Host "[$i] $display  ($rawName)"
        }
        else {
            Write-Host "[$i] $rawName"
        }
    }

    Write-Host ""
    $selection = Read-Host "Select backup number to restore"

    if ($selection -notmatch '^\d+$' -or
        [int]$selection -lt 0 -or
        [int]$selection -ge $folders.Count) {
        Fail "Invalid selection."
    }

    $selectedFolder = $folders[$selection]
    $selectedPath   = $selectedFolder.FullName

    Write-Host ""
    Write-Host "Selected: $($selectedFolder.Name)"
    Write-Host "Restoring files..."

    function Get-ProtocolCommand {
        param ([Microsoft.Win32.RegistryView]$View)

        try {
            $baseKey = [Microsoft.Win32.RegistryKey]::OpenBaseKey(
                [Microsoft.Win32.RegistryHive]::ClassesRoot,
                $View
            )
            $subKey = $baseKey.OpenSubKey("windslayer\shell\open\command")
            if ($subKey) { return $subKey.GetValue("") }
        } catch {}

        return $null
    }

    $command = Get-ProtocolCommand -View Registry64
    if (-not $command) { $command = Get-ProtocolCommand -View Registry32 }
    if (-not $command) { Fail "WindSlayer not found." }

    if ($command -match '"([^"]+)"') {
        $exePath = $matches[1]
    } else {
        $exePath = $command.Split(" ")[0]
    }

    $baseDir = Split-Path $exePath
    $hsDir   = Join-Path $baseDir "hs"

    foreach ($file in Get-ChildItem $selectedPath -File) {
        $dest = Join-Path $hsDir $file.Name
        Copy-Item $file.FullName $dest -Force
        Write-Host "Restored: $($file.Name)"
    }

    Write-Host ""
    Write-Host "Restore completed successfully." -ForegroundColor Green
}
catch {
    Fail $_.Exception.Message
}
