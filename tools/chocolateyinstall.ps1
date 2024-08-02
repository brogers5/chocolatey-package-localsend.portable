$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

Confirm-WinMinimumBuild -ReqBuild 7601

$archiveFileName = 'LocalSend-1.15.3-windows-x86-64.zip'
$archiveFilePath = Join-Path -Path $toolsDir -ChildPath $archiveFileName

$unzipLocation = Join-Path -Path (Get-ToolsLocation) -ChildPath $env:ChocolateyPackageName

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $unzipLocation
  fileFullPath64 = $archiveFilePath
}

Get-ChocolateyUnzip @packageArgs

#Clean up ZIP archive post-install to prevent unnecessary disk bloat
Remove-Item -Path $archiveFilePath -Force -ErrorAction SilentlyContinue

$softwareName = 'LocalSend'
$binaryFileName = 'localsend_app.exe'
$linkName = "$softwareName.lnk"
$targetPath = Join-Path -Path $unzipLocation -ChildPath $binaryFileName

$pp = Get-PackageParameters
if (!$pp.NoShim) {
  Install-BinFile -Name 'localsend_app' -Path $targetPath -UseStart
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
