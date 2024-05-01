# Debloat Enhanced

:sparkles: Script to debloat apps ***No ROOT or Unlocked Bootloader Required!*** :sparkles:

## Overview

Debloat Enhanced is a powerful script designed to remove unwanted apps from your Android device without requiring root access or an unlocked bootloader. It helps improve device performance and battery life by removing unnecessary system apps.

## Prerequisites

Before using Debloat Enhanced, ensure you have the following:

* Download the latest source code.
* Enable USB debugging on your device.
* Customize the .bat or .sh file according to your preferences.

## Features

* **Support for Rooted and Non-Rooted Devices**: Debloat Enhanced works seamlessly on both rooted and non-rooted Android devices, providing flexibility for all users.
  
* **Customizable Debloating**: Tailor the debloating process to your preferences by customizing the list of apps and services you want to remove. This allows you to optimize your device according to your specific needs.

* **Improved Privacy**: Remove pre-installed bloatware and unnecessary system apps to enhance your privacy and minimize data collection by third-party applications.

* **Enhanced Security**: Reduce the attack surface of your device by eliminating unnecessary system services and potential security vulnerabilities.

* **Extended Battery Life**: Disable battery-draining apps and services to prolong battery life and improve overall device efficiency.

## How to Use

1. **Download the Latest Version**: Get the latest version of Debloat Enhanced from the repository.

2. **Enable USB Debugging**: Enable USB debugging on your Android device by going to Settings > Developer options. If Developer options are not visible, go to Settings > About phone and tap on "Build number" seven times to enable Developer options.

3. **Connect Your Device**: Connect your Android device to your computer using a USB cable.

4. **Run the Script**: Open the debloat.bat or debloat.sh file and follow the on-screen instructions to begin the debloating process. For non-rooted devices, ADB permissions may need to be granted during the process.

5. **Review Changes**: Before proceeding, review the list of apps and services that will be removed. Make any necessary adjustments to ensure you do not accidentally remove essential system components.

6. **Enjoy Your Optimized Device**: Once the debloating process is complete, enjoy the improved performance, privacy, security, and battery life of your Android device.

## Important Notes

* **Battery Drainers**: Apps like Chrome and Quick Device Cnnect are known to drain battery quickly.

* **Ram Killers**: Avoid removing essential system services like Athena, as they may cause issues such as the disappearance of the Clear All button.

* **OS Brickers**: Be cautious when removing apps related to weather services, one-handed mode, or startup wizard, as they may affect the stability of your operating system.

* **Backup Your Data**: Before debloating your device, it's recommended to backup your important data to avoid any potential data loss.

* **Proceed with Caution**: While Debloat Enhanced provides a powerful optimization tool, it's important to proceed with caution and only remove apps and services that you are certain are safe to disable. Removing critical system components may lead to device instability or functionality issues.

* **Restore Factory Settings**: If you encounter any issues or wish to revert the changes made by Debloat Enhanced, you can restore your device to factory settings to reset it to its original state.

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
