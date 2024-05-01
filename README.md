# Debloat Enhanced

:sparkles: Script to debloat apps ***No ROOT or Unlocked Bootloader Required!*** :sparkles:

## Overview

Debloat Enhanced is a powerful script designed to remove unwanted apps from your Android device without requiring root access or an unlocked bootloader. It helps improve device performance and battery life by removing unnecessary system apps.

## Prerequisites

Before using Debloat Enhanced, ensure you have the following:

* Download the latest source code.
* Enable USB debugging on your device.
* Customize the .bat or .sh file according to your preferences.

## Usage

Follow these steps to debloat your device:

1. Download the latest source code from the repository.
2. Enable USB debugging on your Android device.
3. Customize the .bat or .sh file to specify which apps you want to remove.
4. Run the script on your computer.

## Important Notes

* **Battery Drainers**: Apps like Chrome and Quick Device Cnnect are known to drain battery quickly.
* **Ram Killers**: Avoid removing essential system services like Athena, as they may cause issues such as the disappearance of the Clear All button.
* **OS Brickers**: Be cautious when removing apps related to weather services, one-handed mode, or startup wizard, as they may affect the stability of your operating system.

## Useful Links

* [Google USB Driver](https://developer.android.com/studio/run/win-usb)
  * [Official OEM Drivers](https://developer.android.com/studio/run/oem-usb#Drivers)
* [Download ADB](https://developer.android.com/studio/releases/platform-tools)
* [Package Manager](https://play.google.com/store/apps/details?id=com.csdroid.pkg)
* [LABD Android](https://userupload.net/wutry343x43x)

## Reinstalling Applications

If you need to reinstall any removed apps, use the following commands:

```cmd
adb shell pm install-existing <package name>

OR

adb shell cmd package install-existing <package name>

```

### Important Note: If you want to restore the removed apps, perform a Factory Reset. ###
