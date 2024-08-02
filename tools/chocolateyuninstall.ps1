$ErrorActionPreference = 'Stop'

$unzipLocation = Join-Path -Path (Get-ToolsLocation) -ChildPath $env:ChocolateyPackageName
Remove-Item -Path $unzipLocation -Recurse -Force -ErrorAction SilentlyContinue

$programsDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::Programs)
$desktopDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::DesktopDirectory)
$linkName = 'LocalSend.lnk'

$programsShortcutFilePath = Join-Path -Path $programsDirectory -ChildPath $linkName
$desktopShortcutFilePath = Join-Path -Path $desktopDirectory -ChildPath $linkName

if (Test-Path -Path $programsShortcutFilePath) {
    Remove-Item -Path $programsShortcutFilePath -Force
}

if (Test-Path -Path $desktopShortcutFilePath) {
    Remove-Item -Path $desktopShortcutFilePath -Force
}

Uninstall-BinFile -Name 'localsend_app'
