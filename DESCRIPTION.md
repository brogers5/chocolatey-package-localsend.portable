## LocalSend

LocalSend is a cross-platform app that enables secure communication between devices using a REST API and HTTPS encryption. Unlike other messaging apps that rely on external servers, LocalSend doesn't require an internet connection or third-party servers, making it a fast and reliable solution for local communication.

LocalSend uses a secure communication protocol that allows devices to communicate with each other using a REST API. All data is sent securely over HTTPS, and the TLS/SSL certificate is generated on the fly on each device, ensuring maximum security.

For more information on the LocalSend Protocol, see the [documentation](https://github.com/localsend/protocol).

![LocalSend Screenshot](https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-localsend.portable@d0493af839be5c7d10d4df0a9fd807287f08e569/Screenshot.png)

## Package Parameters

* `/NoShim` - Opt out of creating a GUI shim, and removes any existing shim.
* `/NoDesktopShortcut` - Opt out of creating a Desktop shortcut.
* `/NoProgramsShortcut` - Opt out of creating a Programs shortcut in your Start Menu.
* `/Start` - Automatically start LocalSend after installation completes.
* `/DontPersistSettings` - Opt out of persisting the settings file (`settings.json`) during package upgrades/uninstalls.

## Package Notes

For future upgrade operations, consider opting into Chocolatey's `useRememberedArgumentsForUpgrades` feature to avoid having to pass the same arguments with each upgrade:

```shell
choco feature enable --name="'useRememberedArgumentsForUpgrades'"
```
