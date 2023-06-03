﻿Import-Module PowerShellForGitHub

$owner = 'localsend'
$repository = 'localsend'

function Get-LatestStableVersion {
    $latestRelease = (Get-GitHubRelease -OwnerName $owner -RepositoryName $repository -Latest)[0]

    return $latestRelease.tag_name.Substring(1)
}

function Get-SoftwareUri($Version) {
    if ($null -eq $Version) {
        # Default to latest stable version
        $release = (Get-GitHubRelease -OwnerName $owner -RepositoryName $repository -Latest)[0]
    }
    else {
        $release = Get-GitHubRelease -OwnerName $owner -RepositoryName $repository -Tag "v$($Version.ToString())"
    }

    $releaseAssets = Get-GitHubReleaseAsset -OwnerName $owner -RepositoryName $repository -Release $release.ID

    $windowsArchiveAsset = $null
    foreach ($asset in $releaseAssets) {
        if ($asset.name -match 'LocalSend-([\d\.]+)-windows(-x86-64)?\.zip$') {
            $windowsArchiveAsset = $asset
            break;
        }
        else {
            continue;
        }
    }

    if ($null -eq $windowsArchiveAsset) {
        throw 'Cannot find published Windows archive asset!'
    }

    return $windowsArchiveAsset.browser_download_url
}
