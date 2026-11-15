# DEFAUIT PROJECT v2.1 - run without installing
# One line:
#   powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; irm https://raw.githubusercontent.com/darapedbxystyle-hub/DEFAUIT-PROJECT/main/run.ps1 | iex"
#
# This script does NOT install the app: no shortcuts, no Program Files/LocalAppData install.
# It downloads DEFAUIT.exe to %TEMP%\DEFAUIT-Run, verifies SHA256, then starts it as Administrator.

[CmdletBinding()]
param(
    [switch]$NoLaunch
)

$ErrorActionPreference = 'Stop'
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch { }

$Repo    = 'darapedbxystyle-hub/DEFAUIT-PROJECT'
$Version = 'v2.1'
$ExeName = 'DEFAUIT.exe'
$Sha256  = '7B6EB91E136F9043CBF396B8CA83945674BFBC5C2F0F3DBE0177FEBF6F273828'
$Url     = "https://github.com/$Repo/releases/download/$Version/$ExeName"
$RunDir  = Join-Path $env:TEMP 'DEFAUIT-Run'
$ExePath = Join-Path $RunDir $ExeName

function Info([string]$Message) {
    if ($NoLaunch) { Write-Host "[DEFAUIT] $Message" -ForegroundColor Cyan }
}
function Fail([string]$Message) { throw "DEFAUIT: $Message" }

function Get-Sha256([string]$Path) {
    (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToUpperInvariant()
}

if (-not ('DEFAUIT.Runner' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
namespace DEFAUIT {
    public static class Runner {
        [DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
        [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
        [DllImport("user32.dll")] public static extern void SwitchToThisWindow(IntPtr hWnd, bool fAltTab);
    }
}
'@
}

function Get-RunningDEFAUIT {
    Get-Process -Name 'DEFAUIT' -ErrorAction SilentlyContinue |
        Where-Object { $_.MainWindowHandle -ne [IntPtr]::Zero } |
        Select-Object -First 1
}

function Show-DEFAUITWindow([System.Diagnostics.Process]$Process, [int]$TimeoutSeconds) {
    $Deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $Deadline) {
        $Process.Refresh()
        if ($Process.HasExited) { return $false }
        if ($Process.MainWindowHandle -ne [IntPtr]::Zero) {
            $Handle = $Process.MainWindowHandle
            [DEFAUIT.Runner]::ShowWindowAsync($Handle, 9) | Out-Null
            try {
                $Shell = New-Object -ComObject WScript.Shell
                [void]$Shell.AppActivate($Process.Id)
            }
            catch { }
            if (-not [DEFAUIT.Runner]::SetForegroundWindow($Handle)) {
                [DEFAUIT.Runner]::SwitchToThisWindow($Handle, $true)
            }
            return $true
        }
        Start-Sleep -Milliseconds 400
    }
    return $false
}

function Start-RefocusHelper([int]$ProcessId) {
    $Code = "Start-Sleep -Seconds 2; `$p = Get-Process -Id $ProcessId -ErrorAction SilentlyContinue; if (`$p) { (New-Object -ComObject WScript.Shell).AppActivate(`$p.Id) | Out-Null }"
    $Encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($Code))
    $PowerShell = Join-Path $env:WINDIR 'System32\WindowsPowerShell\v1.0\powershell.exe'
    Start-Process -FilePath $PowerShell -ArgumentList '-NoProfile', '-WindowStyle', 'Hidden', '-EncodedCommand', $Encoded -WindowStyle Hidden | Out-Null
}

if ($PSVersionTable.PSVersion.Major -lt 5) {
    Fail 'PowerShell 5.1 or newer is required.'
}
if (-not [Environment]::Is64BitOperatingSystem) {
    Fail 'Only 64-bit Windows is supported.'
}

$NetRelease = 0
try {
    $NetRelease = [int](Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full' -ErrorAction Stop).Release
}
catch { }
if ($NetRelease -lt 528040) {
    Fail '.NET Framework 4.8 is required. Download it from https://go.microsoft.com/fwlink/?LinkId=2088631 and run this command again.'
}
if (-not (Test-Path -LiteralPath (Join-Path $env:WINDIR 'System32\VCRUNTIME140.dll'))) {
    Fail 'Visual C++ 2015-2022 x64 runtime is required. Download it from https://aka.ms/vs/17/release/vc_redist.x64.exe and run this command again.'
}

New-Item -ItemType Directory -Force -Path $RunDir | Out-Null

if ((Test-Path -LiteralPath $ExePath) -and ((Get-Sha256 $ExePath) -eq $Sha256)) {
    Info 'Using cached DEFAUIT.exe'
}
else {
    Info "Downloading $ExeName $Version ..."
    $TempExe = "$ExePath.download"
    for ($Attempt = 1; $Attempt -le 3; $Attempt++) {
        try {
            Invoke-WebRequest -Uri $Url -OutFile $TempExe -UseBasicParsing -TimeoutSec 300
            break
        }
        catch {
            if ($Attempt -eq 3) { Fail "Download failed: $($_.Exception.Message)" }
            Start-Sleep -Seconds 2
        }
    }
    if ((Get-Sha256 $TempExe) -ne $Sha256) {
        Remove-Item -LiteralPath $TempExe -Force -ErrorAction SilentlyContinue
        Fail 'Downloaded file checksum mismatch. Try again.'
    }
    Move-Item -LiteralPath $TempExe -Destination $ExePath -Force
    Info 'Download complete (SHA256 verified)'
}

Unblock-File -LiteralPath $ExePath -ErrorAction SilentlyContinue

if ($NoLaunch) {
    Info "Ready: $ExePath"
    return
}

$Existing = Get-RunningDEFAUIT
if ($Existing) {
    Info 'DEFAUIT is already running. Bringing it to the front...'
    if (Show-DEFAUITWindow $Existing 5) {
        Start-RefocusHelper -ProcessId $Existing.Id
        return
    }
}

Info 'Starting DEFAUIT as Administrator. Accept the UAC prompt...'
$Process = $null
try {
    $Process = Start-Process -FilePath $ExePath -WorkingDirectory $RunDir -Verb RunAs -PassThru
}
catch {
    Write-Host '[DEFAUIT] Administrator launch was cancelled. Starting without elevation; system tweaks may not apply.' -ForegroundColor Yellow
    try {
        $Process = Start-Process -FilePath $ExePath -WorkingDirectory $RunDir -PassThru
    }
    catch {
        Fail "Could not start DEFAUIT: $($_.Exception.Message)"
    }
}

if (-not $Process) {
    $Deadline = (Get-Date).AddSeconds(20)
    while ((Get-Date) -lt $Deadline -and -not $Process) {
        Start-Sleep -Milliseconds 400
        $Process = Get-RunningDEFAUIT
    }
}

if ($Process -and (Show-DEFAUITWindow $Process 30)) {
    Info 'DEFAUIT is open.'
    Start-RefocusHelper -ProcessId $Process.Id
    return
}

if ($Process) {
    $Process.Refresh()
    if ($Process.HasExited) {
        $Existing = Get-RunningDEFAUIT
        if ($Existing -and (Show-DEFAUITWindow $Existing 5)) {
            Info 'DEFAUIT was already running. Brought the existing window to the front.'
            return
        }
        Fail "DEFAUIT exited immediately (exit code $($Process.ExitCode)). Try again, or check antivirus / Windows version."
    }
}

Info 'DEFAUIT is running. If the window is not visible, check the taskbar.'
