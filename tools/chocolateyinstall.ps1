﻿$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Confirm-WinMinimumBuild -ReqBuild 7601

$majorOsVersion = [Environment]::OSVersion.Version.Major
$minorOsVersion = [Environment]::OSVersion.Version.Minor
if (($majorOsVersion -eq 6) -and ($minorOsVersion -ge 2) -and !(Get-IsWinServer)) {
  #Only proceed on Windows 8.1 due to issues with GUI rendering in Windows 8
  #https://github.com/flutter/flutter/issues/89583
  Confirm-Win81
}

$archiveFileName = 'LocalSend-1.10.0-windows-x86-64.zip'
$archiveFilePath = Join-Path -Path $toolsDir -ChildPath $archiveFileName

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileFullPath64 = $archiveFilePath
}

Get-ChocolateyUnzip @packageArgs

#Clean up ZIP archive post-install to prevent unnecessary disk bloat
Remove-Item -Path $archiveFilePath -Force -ErrorAction SilentlyContinue

$softwareName = 'LocalSend'
$binaryFileName = 'localsend_app.exe'
$linkName = "$softwareName.lnk"
$targetPath = Join-Path -Path $toolsDir -ChildPath $binaryFileName

$pp = Get-PackageParameters
if ($pp.NoShim) {
  #Create shim ignore file
  $ignoreFilePath = Join-Path -Path $toolsDir -ChildPath "$binaryFileName.ignore"
  Set-Content -Path $ignoreFilePath -Value $null -ErrorAction SilentlyContinue
}
else {
  #Create GUI shim
  $guiShimPath = Join-Path -Path $toolsDir -ChildPath "$binaryFileName.gui"
  Set-Content -Path $guiShimPath -Value $null -ErrorAction SilentlyContinue
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
