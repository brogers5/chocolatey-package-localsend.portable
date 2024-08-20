$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

Confirm-WinMinimumBuild -ReqBuild 7601

$archiveFileName = 'LocalSend-1.15.4-windows-x86-64.zip'
$archiveFilePath = Join-Path -Path $toolsDir -ChildPath $archiveFileName

$legacyUnzipLocation = $toolsDir
$unzipLocation = Join-Path -Path (Get-ToolsLocation) -ChildPath $env:ChocolateyPackageName

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $unzipLocation
  fileFullPath64 = $archiveFilePath
}

$legacySettingsFilePath = Join-Path -Path $legacyUnzipLocation -ChildPath 'settings.json'
$settingsFilePath = Join-Path -Path $unzipLocation -ChildPath 'settings.json'

$pp = Get-PackageParameters
$shouldRestoreSettings = $false
$tempSettingsFilePath = Get-Item -Path ([System.IO.Path]::GetTempFilename())
$shouldCleanUpLegacySettingsFile = $false
if ((Test-Path -Path $settingsFilePath) -and !$pp.DontPersistSettings) {
  Copy-Item -Path $settingsFilePath -Destination $tempSettingsFilePath -Force
  $shouldRestoreSettings = $true
} 
elseif ((Test-Path -Path $legacySettingsFilePath)) {
  if (!$pp.DontPersistSettings) {
    Copy-Item -Path $legacySettingsFilePath -Destination $tempSettingsFilePath -Force
    $shouldRestoreSettings = $true
  }

  $shouldCleanUpLegacySettingsFile = $true
}

Get-ChocolateyUnzip @packageArgs

if ($shouldRestoreSettings) {
  Copy-Item -Path $tempSettingsFilePath -Destination $settingsFilePath -Force
}

#Clean up some files post-install to prevent unnecessary disk bloat
Remove-Item -Path $archiveFilePath -Force -ErrorAction SilentlyContinue
Remove-Item -Path $tempSettingsFilePath -Force -ErrorAction SilentlyContinue
if ($shouldCleanUpLegacySettingsFile) {
  Remove-Item -Path $legacySettingsFilePath -Force -ErrorAction SilentlyContinue
}

$softwareName = 'LocalSend'
$binaryFileName = 'localsend_app.exe'
$linkName = "$softwareName.lnk"
$targetPath = Join-Path -Path $unzipLocation -ChildPath $binaryFileName

$shimName = 'localsend_app'
if ($pp.NoShim) {
  Uninstall-BinFile -Name $shimName
}
else {
  Install-BinFile -Name $shimName -Path $targetPath -UseStart
}

if (!$pp.NoDesktopShortcut) {
  $desktopDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::DesktopDirectory)
  $shortcutFilePath = Join-Path -Path $desktopDirectory -ChildPath $linkName
  Install-ChocolateyShortcut -ShortcutFilePath $shortcutFilePath -TargetPath $targetPath -ErrorAction SilentlyContinue
}

if (!$pp.NoProgramsShortcut) {
  $programsDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::Programs)
  $shortcutFilePath = Join-Path -Path $programsDirectory -ChildPath $linkName
  Install-ChocolateyShortcut -ShortcutFilePath $shortcutFilePath -TargetPath $targetPath -ErrorAction SilentlyContinue
}

if ($pp.Start) {
  try {
    Start-Process -FilePath $targetPath -ErrorAction Continue
  }
  catch {
    Write-Warning "$softwareName failed to start, please try to manually start it instead."
  }
}
