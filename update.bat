@echo off
setlocal enabledelayedexpansion

if "%~1"=="/afterupdate" goto :RUN_PAYLOAD

set "TMPBAT=%TEMP%\update_new_%RANDOM%.bat"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { (New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/bibicadotnet/catsxp-portable/main/update.bat', '%TMPBAT%') } catch { }"

if exist "%TMPBAT%" (
    copy /y "%TMPBAT%" "%~f0" >nul
    del "%TMPBAT%" >nul 2>&1
    call "%~f0" /afterupdate
    set "RC=!errorlevel!"
    exit /b !RC!
)

goto :RUN_PAYLOAD

:RUN_PAYLOAD

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$lines = Get-Content -LiteralPath '%~f0'; $idx = ($lines | Select-String -Pattern '^::PS_PAYLOAD::\s*$').LineNumber | Select-Object -Last 1; $c = ($lines[$idx..($lines.Count-1)]) -join [Environment]::NewLine; $tmp = Join-Path $env:TEMP ('update_payload_' + [guid]::NewGuid().ToString('N') + '.ps1'); Set-Content -LiteralPath $tmp -Value $c -Encoding UTF8; try { & $tmp '%~dp0' } finally { Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue }"

if errorlevel 1 (
    echo.
    echo update.bat exited with an error. See the output above.
    pause
)

exit /b

::PS_PAYLOAD::
param([string]$currentDir)
$ErrorActionPreference = "Stop"
$exePath = Join-Path $currentDir "catsxp.exe"
$apiUrl = "https://api.github.com/repos/bibicadotnet/catsxp-portable/releases/latest"
$tempDir = Join-Path $currentDir "CatsxpUpdateTemp"

try {
  $webClient = New-Object System.Net.WebClient

  Write-Host ""
  Write-Host "Catsxp Portable Updater v1.0"
  Write-Host "============================"
  Write-Host ""

  # 1. Check Catsxp version (no downloads yet, just the version check)
  $currentVersion = if (Test-Path $exePath) { (Get-Item $exePath).VersionInfo.ProductVersion } else { "Not installed" }
  $release = Invoke-RestMethod -Uri $apiUrl
  $asset = $release.assets | Where-Object { $_.name -like "v*_x64.zip" } | Select-Object -First 1
  if (-not $asset) { throw "Could not find Catsxp portable zip file in the latest release." }
  
  $latestVersion = $release.tag_name -replace '^v', ''
  $downloadUrl = $asset.browser_download_url

  Write-Host "Current version: $currentVersion" -ForegroundColor Yellow
  Write-Host "Latest version: $latestVersion" -ForegroundColor Yellow
  Write-Host ""
  
  $confirm = Read-Host "Do you want to update Catsxp Portable and Chrome++ Next Mini? (y/N)"
  if ($confirm -ne 'y' -and $confirm -ne 'Y') { exit }
  Write-Host ""
  
  if (Test-Path $exePath) {
    Stop-Process -Name catsxp -Force -ErrorAction SilentlyContinue
    Start-Sleep 2
  }

  # 2. Download utility scripts and config files (only after confirmation)
  try {
    $webClient.DownloadFile("https://raw.githubusercontent.com/bibicadotnet/catsxp-portable/main/register-default-browser.bat", (Join-Path $currentDir "register-default-browser.bat"))
    $webClient.DownloadFile("https://raw.githubusercontent.com/bibicadotnet/catsxp-portable/main/chrome++.ini", (Join-Path $currentDir "chrome++.ini"))
    $webClient.DownloadFile("https://raw.githubusercontent.com/bibicadotnet/catsxp-portable/main/bypass_windows_defender.bat", (Join-Path $currentDir "bypass_windows_defender.bat"))
  } catch {
    Write-Warning "Failed to download helper files (can be ignored if files do not exist): $_"
  }

  if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
  $downloadDir = Join-Path $tempDir "download"
  $extractDir = Join-Path $tempDir "extracted"
  New-Item -ItemType Directory -Path $downloadDir -Force | Out-Null
  New-Item -ItemType Directory -Path $extractDir -Force | Out-Null
  $zipFile = Join-Path $downloadDir "update.zip"

  # 3. Download Catsxp Portable
  Write-Host "Downloading Catsxp Portable from: $downloadUrl"
  $webClient.DownloadFile($downloadUrl, $zipFile)
  Expand-Archive -Path $zipFile -DestinationPath $extractDir -Force

  $topDirs = Get-ChildItem $extractDir -Directory
  $topFiles = Get-ChildItem $extractDir -File
  if ($topDirs.Count -eq 1 -and $topFiles.Count -eq 0) { $extractedRoot = $topDirs[0].FullName } else { $extractedRoot = $extractDir }

  if (Test-Path (Join-Path $currentDir "catsxp.exe")) { Remove-Item (Join-Path $currentDir "catsxp.exe") -Force }
  
  # Remove old version folders (folders named with only numbers and dots)
  Get-ChildItem $currentDir -Directory -ErrorAction SilentlyContinue | Where-Object { ($_.Name -replace '[0-9.]','') -eq '' } | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }

  Get-ChildItem $extractedRoot -Recurse | ForEach-Object {
    $relativePath = $_.FullName.Substring($extractedRoot.Length + 1)
    $destPath = Join-Path $currentDir $relativePath
    if ($_.PSIsContainer) {
      New-Item -ItemType Directory -Path $destPath -Force | Out-Null
    } else {
      $destFolder = Split-Path $destPath -Parent
      if (-not (Test-Path $destFolder)) { New-Item -ItemType Directory -Path $destFolder -Force | Out-Null }
      Copy-Item $_.FullName -Destination $destPath -Force
    }
  }

  # 4. Download and Install Chrome++ Next Mini (version.dll only)
  $chromeNextMiniApiUrl = "https://api.github.com/repos/bibicadotnet/chrome-next-mini/releases/latest"
  try {
    $chromeNextRelease = Invoke-RestMethod -Uri $chromeNextMiniApiUrl
    $chromeNextAsset = $chromeNextRelease.assets | Where-Object { $_.name -like "edge_portable-v*.zip" } | Select-Object -First 1
    if (-not $chromeNextAsset) { throw "Could not find edge_portable*.zip in the latest release of chrome-next-mini." }
    $chromeNextDownloadUrl = $chromeNextAsset.browser_download_url
    $chromeNextZip = Join-Path $downloadDir "chrome-next-mini.zip"

    Write-Host "Downloading Chrome++ Next Mini from: $chromeNextDownloadUrl"
    $webClient.DownloadFile($chromeNextDownloadUrl, $chromeNextZip)
	Write-Host ""
	
    $chromeNextExtractDir = Join-Path $tempDir "chrome-next-mini-extracted"
    New-Item -ItemType Directory -Path $chromeNextExtractDir -Force | Out-Null
    Expand-Archive -Path $chromeNextZip -DestinationPath $chromeNextExtractDir -Force

    $dllFile = Get-ChildItem $chromeNextExtractDir -Filter "version.dll" -Recurse | Select-Object -First 1

    if ($dllFile) {
        Copy-Item $dllFile.FullName -Destination (Join-Path $currentDir "version.dll") -Force
    } else {
        throw "Could not find version.dll in the extracted zip file."
    }
  } catch {
    Write-Warning "Failed to install Chrome++ Next Mini: $_"
  }

  # Clean up temp update folder
  Remove-Item $tempDir -Recurse -Force
  
  $newVersion = if (Test-Path $exePath) { (Get-Item $exePath).VersionInfo.ProductVersion } else { "Not installed" }
  if ($newVersion -like "$latestVersion*") {
    Write-Host "Update completed! Version: $newVersion" -ForegroundColor Green
  } else {
    Write-Host "Error or update failed. Expected: $latestVersion, Actual: $newVersion" -ForegroundColor Yellow
  }

} catch {
  Write-Host "Error: $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit"
