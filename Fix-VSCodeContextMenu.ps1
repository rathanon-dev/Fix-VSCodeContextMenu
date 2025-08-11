# Fix-VSCodeContextMenu.ps1
# Recreate "Open with Code" context menus (File, Directory, Background, Drive) in HKCU like VSCode 1.102.3
# If VS Code not found, print error and exit.

param(
  [string]$CodePath  # optional: explicit full path to Code.exe
)

$ErrorActionPreference = 'Stop'

# 1) Locate Code.exe
if (-not $CodePath) {
    $pathsToTry = @()
    if ($env:LOCALAPPDATA)        { $pathsToTry += (Join-Path $env:LOCALAPPDATA        'Programs\Microsoft VS Code\Code.exe') }
    if ($env:ProgramFiles)        { $pathsToTry += (Join-Path $env:ProgramFiles        'Microsoft VS Code\Code.exe') }
    if (${env:ProgramFiles(x86)}) { $pathsToTry += (Join-Path ${env:ProgramFiles(x86)} 'Microsoft VS Code\Code.exe') }

    $CodePath = $pathsToTry | Where-Object { Test-Path $_ } | Select-Object -First 1
}

if (-not $CodePath -or -not (Test-Path $CodePath)) {
    Write-Host "ERROR: VS Code not installed (Code.exe not found). Install VS Code or run with -CodePath <full path>." -ForegroundColor Red
    exit 1
}

Write-Host "Using Code.exe: $CodePath"

function Ensure-Menu {
  param(
    [Parameter(Mandatory=$true)][string]$BaseKey,   # e.g. HKCU\Software\Classes\*\shell
    [Parameter(Mandatory=$true)][string]$MenuName,  # e.g. VSCode
    [Parameter(Mandatory=$true)][string]$ArgFormat  # "%1" or "%V"
  )

  $menuKey    = "$BaseKey\$MenuName"
  $commandKey = "$menuKey\command"
  $commandVal = "`"$CodePath`" `"$ArgFormat`""

  # Create keys
  & reg.exe add "$menuKey"    /f | Out-Null
  & reg.exe add "$commandKey" /f | Out-Null

  # Friendly name, icon, no working dir
  & reg.exe add "$menuKey" /v "MUIVerb"            /t REG_SZ /d "Open with Code" /f | Out-Null
  & reg.exe add "$menuKey" /v "Icon"               /t REG_SZ /d "`"$CodePath`""  /f | Out-Null
  & reg.exe add "$menuKey" /v "NoWorkingDirectory" /t REG_SZ /d ""               /f | Out-Null

  # Set (Default) of ...\command
  & reg.exe add "$commandKey" /ve /t REG_SZ /d "$commandVal" /f | Out-Null

  Write-Host "OK: $menuKey"
  Write-Host "OK: $commandKey -> (Default) = $commandVal"
}

$menuName = "VSCode"

# 2) Apply for 4 locations
Ensure-Menu "HKCU\Software\Classes\*\shell"                    $menuName "%1"  # file
Ensure-Menu "HKCU\Software\Classes\Directory\shell"            $menuName "%1"  # folder
Ensure-Menu "HKCU\Software\Classes\Directory\Background\shell" $menuName "%V"  # folder background
Ensure-Menu "HKCU\Software\Classes\Drive\shell"                $menuName "%1"  # drive
 
# === Grab current Explorer window position (pick the first top-level) ===
Write-Host "Done. Restarting Explorer to refresh context menus..."
try {
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 800

    # Open Explorer Folder  Location
    $targetPath = $PSScriptRoot
    Start-Process explorer.exe $targetPath

    $newExplorer = $null
    for ($i=0; $i -lt 20 -and -not $newExplorer; $i++) {
        Start-Sleep -Milliseconds 300
        $newExplorer = Get-Process -Name explorer -ErrorAction SilentlyContinue |
                       Where-Object { $_.MainWindowHandle -ne 0 } |
                       Select-Object -First 1
    }
    if ($pos -and $newExplorer) {
        [WinAPI]::MoveWindow([IntPtr]$newExplorer.MainWindowHandle, $pos.X, $pos.Y, $pos.W, $pos.H, $true) | Out-Null
    }
} catch {
    Write-Host "Could not restart Explorer automatically. Please sign out/in or restart Explorer manually."
}