# DEFAUIT uninstaller
# Removes the per-user install created by install.ps1, its shortcuts and the timer-resolution task.

$ErrorActionPreference = 'SilentlyContinue'

$InstallDir = Join-Path $env:LOCALAPPDATA 'DEFAUIT'
$Desktop    = [Environment]::GetFolderPath('Desktop')
$Programs   = [Environment]::GetFolderPath('Programs')

Write-Host 'This will close DEFAUIT, remove its folder, shortcuts and the DEFAUIT_TimerResolution task.'
$Answer = Read-Host 'Continue? (y/N)'
if ($Answer -notmatch '^[Yy]') { exit }

Get-Process -Name 'DEFAUIT' | Stop-Process -Force
Start-Sleep -Milliseconds 500

if ($Desktop)  { Remove-Item -LiteralPath (Join-Path $Desktop 'DEFAUIT.lnk') -Force }
if ($Programs) { Remove-Item -LiteralPath (Join-Path $Programs 'DEFAUIT.lnk') -Force }

if (Get-ScheduledTask -TaskName 'DEFAUIT_TimerResolution' -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName 'DEFAUIT_TimerResolution' -Confirm:$false
}
Remove-Item -LiteralPath (Join-Path $env:ProgramData 'DEFAUIT') -Recurse -Force

if ($InstallDir -and (Test-Path -LiteralPath $InstallDir) -and ($InstallDir -like (Join-Path $env:LOCALAPPDATA '*'))) {
    Remove-Item -LiteralPath $InstallDir -Recurse -Force
}

Write-Host 'DEFAUIT removed.'
