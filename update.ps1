[CmdletBinding()]
param([switch] $Force)
Import-Module au

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition)
. $currentPath\helpers.ps1

$toolsDir = Join-Path -Path $currentPath -ChildPath 'tools'
$softwareRepo = 'localsend/localsend'

function global:au_GetLatest {
    $version = Get-LatestStableVersion

    return @{
        SoftwareVersion = $version
        Url64           = Get-SoftwareUri
        Version         = $version #This may change if building a package fix version
    }
}

function global:au_BeforeUpdate ($Package) {
    Get-RemoteFiles -Purge -NoSuffix -Algorithm sha256

    $templateFilePath = Join-Path -Path $toolsDir -ChildPath 'VERIFICATION.txt.template'
    $verificationFilePath = Join-Path -Path $toolsDir -ChildPath 'VERIFICATION.txt'
    Copy-Item -Path $templateFilePath -Destination $verificationFilePath -Force

    Set-DescriptionFromReadme -Package $Package -ReadmePath '.\DESCRIPTION.md'
}

function global:au_AfterUpdate {
    $licenseUri = "https://raw.githubusercontent.com/$($softwareRepo)/v$($Latest.SoftwareVersion)/LICENSE"
    $licenseContents = Invoke-WebRequest -Uri $licenseUri -UseBasicParsing

    $licensePath = Join-Path -Path $toolsDir -ChildPath 'LICENSE.txt'
    Set-Content -Path $licensePath -Value "From: $licenseUri`r`n`r`n$licenseContents"
}

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            '(<packageSourceUrl>)[^<]*(</packageSourceUrl>)' = "`$1https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)`$2"
            '(<licenseUrl>)[^<]*(</licenseUrl>)'             = "`$1https://github.com/$($softwareRepo)/blob/v$($Latest.SoftwareVersion)/LICENSE`$2"
            '(<projectSourceUrl>)[^<]*(</projectSourceUrl>)' = "`$1https://github.com/$($softwareRepo)/tree/v$($Latest.SoftwareVersion)`$2"
            '(<releaseNotes>)[^<]*(</releaseNotes>)'         = "`$1https://github.com/$($softwareRepo)/releases/tag/v$($Latest.SoftwareVersion)`$2"
            '(<copyright>)[^<]*(</copyright>)'               = "`$1Copyright (c) 2022-$(Get-Date -Format yyyy) Tien Do Nam`$2"
        }
        'tools\VERIFICATION.txt'        = @{
            '%checksumValue%'   = "$($Latest.Checksum64)"
            '%checksumType%'    = "$($Latest.ChecksumType64.ToUpper())"
            '%tagReleaseUrl%'   = "https://github.com/$($softwareRepo)/releases/tag/v$($Latest.SoftwareVersion)"
            '%archiveUrl%'      = "$($Latest.Url64)"
            '%archiveFileName%' = "$($Latest.FileName64)"
        }
        'tools\chocolateyinstall.ps1'   = @{
            '(^[$]archiveFileName\s*=\s*)(''.*'')' = "`$1'$($Latest.FileName64)'"
        }
    }
}

Update-Package -ChecksumFor None -Force:$Force -NoReadme
