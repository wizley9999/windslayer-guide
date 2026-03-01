$ErrorActionPreference = "Stop"

function Fail($msg) {
    Write-Host ""
    Write-Host "ERROR: $msg" -ForegroundColor Red

    exit 1
}

try {
    function Get-ProtocolCommand {
        param (
            [Microsoft.Win32.RegistryView]$View
        )

        try {
            $baseKey = [Microsoft.Win32.RegistryKey]::OpenBaseKey(
                [Microsoft.Win32.RegistryHive]::ClassesRoot,
                $View
            )

            $subKey = $baseKey.OpenSubKey("windslayer\shell\open\command")

            if ($subKey -ne $null) {
                return $subKey.GetValue("")
            }
        }
        catch { }

        return $null
    }

    Write-Host "Searching for WindSlayer..."

    $command = Get-ProtocolCommand -View Registry64

    if (-not $command) {
        $command = Get-ProtocolCommand -View Registry32
    }

    if (-not $command) {
        Fail "ws protocol not found in registry."
    }

    Write-Host "Protocol found."

    if ($command -match '"([^"]+)"') {
        $exePath = $matches[1]
    }
    else {
        $exePath = $command.Split(" ")[0]
    }

    if (-not (Test-Path $exePath)) {
        Fail "Executable not found: $exePath"
    }

    Write-Host "Executable: $exePath"

    $baseDir = Split-Path $exePath
    $hsDir = Join-Path $baseDir "hs"

    if (-not (Test-Path $hsDir)) {
        Fail "hs folder not found: $hsDir"
    }

    Write-Host "hs folder: $hsDir"

    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

    $backupDir = Join-Path $scriptDir "backup"

    if (-not (Test-Path $backupDir)) {
        New-Item -ItemType Directory -Path $backupDir | Out-Null
    }

    $files = @(
        "UILngKo.lng",
        "QSTLngKo.lng",
        "NPCLngKo.lng",
        "MapLngKo.lng",
        "ITMLngKo.lng",
        "windslayer.hpt",
        "windslayer.bct"
    )

    $timestamp = Get-Date -Format "yyyyMMddHHmmss"

    foreach ($file in $files) {
        $source = Join-Path $scriptDir $file
        $dest = Join-Path $hsDir $file

        if (Test-Path $source) {
            if (Test-Path $dest) {
                $name = [System.IO.Path]::GetFileNameWithoutExtension($file)
                $ext  = [System.IO.Path]::GetExtension($file)

                $backupName = "$name-bak-$timestamp$ext"
                $backupPath = Join-Path $backupDir $backupName

                Copy-Item $dest $backupPath -Force
                Write-Host "Backed up: $file -> $backupName"
            }

            Copy-Item $source $dest -Force
            Write-Host "Copied: $file"
        }
    }

    Write-Host ""
    Write-Host "Deployment completed successfully." -ForegroundColor Green

    exit 0
}
catch {
    Fail $_.Exception.Message
}
