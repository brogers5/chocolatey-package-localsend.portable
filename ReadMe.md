# <img src="https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-localsend.portable@d0493af839be5c7d10d4df0a9fd807287f08e569/localsend.portable.png" width="48" height="48"/> Chocolatey Package: [LocalSend (Portable)](https://community.chocolatey.org/packages/localsend.portable)

[![Chocolatey package version](https://img.shields.io/chocolatey/v/localsend.portable.svg)](https://community.chocolatey.org/packages/localsend.portable)
[![Chocolatey package download count](https://img.shields.io/chocolatey/dt/localsend.portable.svg)](https://community.chocolatey.org/packages/localsend.portable)

---

This package is part of a family of packages published for LocalSend. This repository is for the portable package.

* For the meta package, see [chocolatey-package-localsend](https://github.com/brogers5/chocolatey-package-localsend).
* For the installer package, see [chocolatey-package-localsend.install](https://github.com/brogers5/chocolatey-package-localsend.install).

See the [Chocolatey FAQs](https://docs.chocolatey.org/en-us/faqs) for more information on [meta packages](https://docs.chocolatey.org/en-us/faqs#what-is-the-difference-between-packages-no-suffix-as-compared-to.install.portable) and [installer/portable packages](https://docs.chocolatey.org/en-us/faqs#what-distinction-does-chocolatey-make-between-an-installable-and-a-portable-application).

---

## Install

[Install Chocolatey](https://chocolatey.org/install), and run the following command to install the latest approved stable version from the Chocolatey Community Repository:

```shell
choco install localsend.portable --source="'https://community.chocolatey.org/api/v2'"
```

Alternatively, the packages as published on the Chocolatey Community Repository will also be mirrored on this repository's [Releases page](https://github.com/brogers5/chocolatey-package-localsend.portable/releases). The `nupkg` can be installed from the current directory (with dependencies sourced from the Community Repository) as follows:

```shell
choco install localsend.portable --source="'.;https://community.chocolatey.org/api/v2/'"
```

## Build

[Install Chocolatey](https://chocolatey.org/install), the [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au), and the [PowerShellForGitHub PowerShell Module](https://github.com/microsoft/PowerShellForGitHub), then clone this repository.

Once cloned, simply run `build.ps1`. The ZIP archive is intentionally untracked to avoid bloating the repository, so the script will download the LocalSend portable ZIP archive from the official distribution point, then packs everything together.

A successful build will create `localsend.portable.x.y.z.nupkg`, where `x.y.z` should be the Nuspec's `version` value at build time.

Note that Chocolatey package builds are non-deterministic. Consequently, an independently built package will fail a checksum validation against officially published packages.

## Update

This package should be automatically updated by the [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au), with update queries implemented by the [PowerShellForGitHub PowerShell Module](https://github.com/microsoft/PowerShellForGitHub). If it is outdated by more than a few days, please [open an issue](https://github.com/brogers5/chocolatey-package-localsend.portable/issues).

AU expects the parent directory that contains this repository to share a name with the Nuspec (`localsend.portable`). Your local repository should therefore be cloned accordingly:

```shell
git clone git@github.com:brogers5/chocolatey-package-localsend.portable.git localsend.portable
```

Alternatively, a junction point can be created that points to the local repository (preferably within a repository adopting the [AU packages template](https://github.com/majkinetor/au-packages-template)):

```shell
mklink /J localsend.portable ..\chocolatey-package-localsend.portable
```

Once created, simply run `update.ps1` from within the created directory/junction point. Assuming all goes well, all relevant files should change to reflect the latest version available. This will also build a new package version using the modified files.

To forcibly create an updated package (regardless of whether a new software version is available), pass the `-Force` switch:

```powershell
.\update.ps1 -Force
```

Before submitting a pull request, please [test the package](https://docs.chocolatey.org/en-us/community-repository/moderation/package-verifier#steps-for-each-package) using the [Chocolatey Testing Environment](https://github.com/chocolatey-community/chocolatey-test-environment) first.
