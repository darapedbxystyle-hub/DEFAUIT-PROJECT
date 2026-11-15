# DEFAUIT PROJECT v2.1 - installer / portable launcher
# Usage (one line):
#   powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; irm https://raw.githubusercontent.com/darapedbxystyle-hub/DEFAUIT-PROJECT/main/install.ps1 | iex"
# Portable usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Portable

[CmdletBinding()]
param(
    [switch]$Portable,
    [switch]$NoLaunch,
    [switch]$NoShortcut
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch { }

if ($PSVersionTable.PSVersion.Major -lt 5) {
    throw 'DEFAUIT: PowerShell 5.1 or newer is required.'
}

$Repo        = 'darapedbxystyle-hub/DEFAUIT-PROJECT'
$Version     = 'v2.1'
$ExeName     = 'DEFAUIT.exe'
$Sha256      = '7B6EB91E136F9043CBF396B8CA83945674BFBC5C2F0F3DBE0177FEBF6F273828'
$DownloadUrl = "https://github.com/$Repo/releases/download/$Version/$ExeName"
$ScriptDir   = $PSScriptRoot

function Info([string]$Message) { Write-Host "[DEFAUIT] $Message" -ForegroundColor Cyan }
function Ok([string]$Message)   { Write-Host "[  OK  ] $Message" -ForegroundColor Green }
function Warn([string]$Message) { Write-Host "[ WARN ] $Message" -ForegroundColor Yellow }
function Fail([string]$Message) { throw "DEFAUIT: $Message" }

function Get-Sha256([string]$Path) {
    (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToUpperInvariant()
}

function Invoke-Download([string]$Url, [string]$OutFile) {
    for ($Attempt = 1; $Attempt -le 3; $Attempt++) {
        try {
            Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing -TimeoutSec 300
            return
        }
        catch {
            if ($Attempt -eq 3) { throw }
            Start-Sleep -Seconds 2
        }
    }
}

function Get-DotNet48Release {
    $Paths = @(
        'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\NET Framework Setup\NDP\v4\Full'
    )
    foreach ($Path in $Paths) {
        try {
            $Value = (Get-ItemProperty -LiteralPath $Path -ErrorAction Stop).Release
            if ($null -ne $Value) { return [int]$Value }
        }
        catch { }
    }
    return 0
}

function Ensure-DotNet48 {
    $Release = Get-DotNet48Release
    if ($Release -ge 528040) {
        Ok ".NET Framework 4.8 available (Release $Release)"
        return
    }

    Info "Installing .NET Framework 4.8 (this can take a few minutes)..."
    $Installer = Join-Path $env:TEMP 'ndp48-x86-x64-allos-enu.exe'
    Invoke-Download 'https://go.microsoft.com/fwlink/?LinkId=2088631' $Installer
    $Process = Start-Process -FilePath $Installer -ArgumentList '/q', '/norestart' -Wait -PassThru
    Remove-Item -LiteralPath $Installer -Force -ErrorAction SilentlyContinue

    if ((Get-DotNet48Release) -lt 528040) {
        Fail ".NET Framework 4.8 installation failed (exit $($Process.ExitCode)). Restart Windows and run this installer again."
    }
    Ok ".NET Framework 4.8 installed"
}

function Ensure-VCRuntime {
    $Dll = Join-Path $env:WINDIR 'System32\VCRUNTIME140.dll'
    if (Test-Path -LiteralPath $Dll) {
        Ok 'Visual C++ Runtime available'
        return
    }

    Info 'Installing Visual C++ 2015-2022 Runtime (x64)...'
    $Installer = Join-Path $env:TEMP 'vc_redist.x64.exe'
    Invoke-Download 'https://aka.ms/vs/17/release/vc_redist.x64.exe' $Installer
    $Process = Start-Process -FilePath $Installer -ArgumentList '/install', '/quiet', '/norestart' -Wait -PassThru
    Remove-Item -LiteralPath $Installer -Force -ErrorAction SilentlyContinue

    if (-not (Test-Path -LiteralPath $Dll) -and ($Process.ExitCode -notin 0, 3010, 1638)) {
        Fail "Visual C++ Runtime installation failed (exit $($Process.ExitCode))."
    }
    Ok 'Visual C++ Runtime installed'
}

function Resolve-SourceExe {
    if ($ScriptDir) {
        $Local = Join-Path $ScriptDir $ExeName
        if (Test-Path -LiteralPath $Local) {
            if ((Get-Sha256 $Local) -ne $Sha256) {
                Fail "Checksum mismatch for $ExeName in this folder. Download a fresh copy from Releases."
            }
            Ok "Using local $ExeName (SHA256 verified)"
            return $Local
        }
    }

    $TempExe = Join-Path $env:TEMP ("DEFAUIT-" + $Version + ".exe")
    Info "Downloading $ExeName $Version ..."
    Invoke-Download $DownloadUrl $TempExe
    if ((Get-Sha256 $TempExe) -ne $Sha256) {
        Remove-Item -LiteralPath $TempExe -Force -ErrorAction SilentlyContinue
        Fail 'Downloaded file checksum mismatch. Try again or download from Releases.'
    }
    Ok 'Download complete (SHA256 verified)'
    return $TempExe
}

function New-DefaultShortcut([string]$ShortcutPath, [string]$Launcher, [string]$Icon) {
    $Shell = New-Object -ComObject WScript.Shell
    $Shortcut = $Shell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $Launcher
    $Shortcut.WorkingDirectory = $InstallDir
    $Shortcut.IconLocation = "$Icon,0"
    $Shortcut.Description = 'DEFAUIT PROJECT v2.1'
    $Shortcut.WindowStyle = 7
    $Shortcut.Save()
}

if (-not [Environment]::Is64BitOperatingSystem) {
    Fail 'Only 64-bit Windows is supported.'
}

$OSVersion = [Environment]::OSVersion.Version
if ($OSVersion.Major -lt 10) {
    Warn 'Windows 10 or 11 (64-bit) is recommended. Older versions are not officially supported.'
}

Ensure-DotNet48
Ensure-VCRuntime

$Source = Resolve-SourceExe

if ($Portable -and $ScriptDir) {
    $InstallDir = $ScriptDir
}
elseif ($env:DEFAUIT_INSTALL_DIR) {
    $InstallDir = $env:DEFAUIT_INSTALL_DIR
}
else {
    $InstallDir = Join-Path $env:LOCALAPPDATA 'DEFAUIT'
}

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
$Target = Join-Path $InstallDir $ExeName

if ((Resolve-Path -LiteralPath $Source).Path -ne $Target) {
    try {
        Copy-Item -LiteralPath $Source -Destination $Target -Force
    }
    catch {
        Fail "Could not write $Target. Close DEFAUIT if it is running and try again."
    }
}
Unblock-File -LiteralPath $Target -ErrorAction SilentlyContinue
Ok "Installed to $Target"

if ($Source -like (Join-Path $env:TEMP '*')) {
    Remove-Item -LiteralPath $Source -Force -ErrorAction SilentlyContinue
}

$Launcher = Join-Path $InstallDir 'Launch DEFAUIT.cmd'
$LauncherText = @'
@echo off
start "" powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~dp0DEFAUIT.exe' -WorkingDirectory '%~dp0' -Verb RunAs"
'@
Set-Content -LiteralPath $Launcher -Value $LauncherText -Encoding ASCII

if (-not $NoShortcut) {
    $Desktop  = [Environment]::GetFolderPath('Desktop')
    $Programs = [Environment]::GetFolderPath('Programs')
    try {
        if ($Desktop)  { New-DefaultShortcut (Join-Path $Desktop 'DEFAUIT.lnk') $Launcher $Target }
        if ($Programs) { New-DefaultShortcut (Join-Path $Programs 'DEFAUIT.lnk') $Launcher $Target }
        Ok 'Desktop and Start Menu shortcuts created'
    }
    catch {
        Warn "Shortcut creation failed: $($_.Exception.Message)"
    }
}

if (-not $NoLaunch) {
    Info 'Starting DEFAUIT as Administrator. Accept the UAC prompt to continue...'
    try {
        Start-Process -FilePath $Target -WorkingDirectory $InstallDir -Verb RunAs
    }
    catch {
        Warn "Launch cancelled or failed: $($_.Exception.Message)"
        Warn "You can start it later from: $Launcher"
    }
}

Ok 'Ready.'
