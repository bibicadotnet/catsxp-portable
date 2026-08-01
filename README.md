# Catsxp Portable

<p align="center">
  <img src="https://img.bibica.net/DrNuwrhh.png" alt="Image">
</p>

Catsxp Portable is a portable version of Catsxp for Windows. It has been fully converted into a self-contained portable application, allowing you to copy it between devices without losing any data or reconfiguring extensions, browsing history, and other settings.

Although [Catsxp](https://www.catsxp.com/) already provides a portable mode, its update mechanism is not very convenient and lacks several useful features, such as setting it as the default browser and supporting multiple portable installations pinned to the taskbar. This is why Catsxp Portable, powered by [Chrome++ Next Mini](https://github.com/bibicadotnet/chrome-next-mini), was created.

* [Catsxp Portable](https://github.com/bibicadotnet/catsxp-portable/) is repackaged directly from the official Catsxp installer.

<p align="center">
  <img src="https://bibica.net/wp-content/uploads/2026/08/2026-08-01-11-03-02.png" alt="">
</p>

The download URL is obtained from the Omaha API endpoint: `https://www.catsxp.com/api/service/Update`

This is equivalent to clicking **Check for updates** from `catsxp://settings/help`.

The GitHub Actions workflow performs the entire packaging process automatically. Updates typically become available 1–2 hours after the official release. Since the workflow always relies on the Omaha API, it stays synchronized with the official Catsxp releases and requires virtually no maintenance.

> ## Installation
>
> * Download the package: [Catsxp_Portable.zip](https://github.com/bibicadotnet/catsxp-portable/releases/download/setup/Catsxp_Portable.zip)
> * Extract the archive and run `update.bat`.
>
> After the installation is complete, the directory structure will look like this:
>
> ```text
> Catsxp_Portable
> ├── Cache/                               # Cache and temporary files
> ├── Data/                                # User data and settings
> └── Catsxp/
>     ├── 151.6.7.5/                       # Program files for this version
>     ├── bypass_windows_defender.bat      # Add the folder to Microsoft Defender exclusions
>     ├── catsxp.exe                       # Main executable
>     ├── chrome++.ini                     # Chrome++ Next Mini configuration
>     ├── register-default-browser.bat     # Set Catsxp as the default browser
>     ├── update.bat                       # Update to the latest version
>     └── version.dll                      # Chrome++ Next Mini patch library
> ```
>
> Everything is preconfigured. Simply launch `catsxp.exe` and use it like a normal browser.
>
> All user data (settings, profiles, extensions, etc.) is stored inside the `Catsxp_Portable` directory. You can move or copy the entire folder to another device without losing any data.

## Notes

Whenever `update.bat` is executed, it automatically downloads the latest release from GitHub.

Since `catsxp.exe` is not code-signed, Microsoft Defender may occasionally produce a false positive and classify it as malware or a trojan. If you trust this project, simply run `bypass_windows_defender.bat` to add the folder to Microsoft Defender's exclusion list and prevent the browser files from being removed unexpectedly.

Both [Catsxp Portable](https://github.com/bibicadotnet/catsxp-portable/) and [Chrome++ Next Mini](https://github.com/bibicadotnet/chrome-next-mini) are open-source projects. If you encounter browser-related issues, they are usually unrelated to either project, as both are intentionally designed to be as simple as possible to minimize potential problems. I use Catsxp Portable daily and have not encountered any issues.

Catsxp Portable does not include any preconfigured registry tweaks. The original Catsxp is already very clean, and virtually every feature can be enabled or disabled through the browser settings. You only need to configure it once, and those settings will travel with the portable folder. If registry tweaks were included, you would need to apply them again whenever you move the browser to another computer, adding an unnecessary extra step.

## Recommended Configuration

For the best experience, it is recommended to apply the following settings the first time you launch the browser.

### Tab Settings

* Go to **Tab → Behaviors**.
* Set both **Address bar (search)** and **Address bar (URL)** to **Default**.

<p align="center">
  <img src="https://bibica.net/wp-content/uploads/2026/08/2026-08-01-12-52-13.png" alt="">
</p>

### Shields Settings

* Configure the settings as shown below.

<p align="center">
  <img src="https://bibica.net/wp-content/uploads/2026/08/2026-08-01-12-55-107.png" alt="">
</p>

### Content Filters

* Enable **Developer mode**.
* Add the following filter lists:

```text
https://filters.bibica.net/brave-adblock.txt
https://raw.githubusercontent.com/abpvn/abpvn/master/filter/abpvn_ublock.txt
https://filters.bibica.net/blocklists-minimal-ublock.txt
```

<p align="center">
  <img src="https://bibica.net/wp-content/uploads/2026/08/2026-08-01-12-56-52.png" alt="">
</p>

The remaining settings can be adjusted according to your own preferences.
