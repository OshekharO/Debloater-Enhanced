# Debloat Realme

:sparkles: script to debloat Apps ***No ROOT or Unlocked Bootloader Required!*** :sparkles:
## Get apps packages list

```cmd
adb shell pm list packages -f > %CD%\packages.txt
```

## How-to

* Download the latest source code;
* Turn on usb debugging;
* Customize the .bat or .sh file;
* Run.

## Note

Comment out/uncomment packages names

## Links

* [Google USB Driver](https://developer.android.com/studio/run/win-usb)
  * [Official all OEMs drivers](https://developer.android.com/studio/run/oem-usb#Drivers)
* [Download ADB](https://developer.android.com/studio/releases/platform-tools)
* [Package Manager](https://play.google.com/store/apps/details?id=sarangal.packagemanager)
* [LABD Android](https://userupload.net/wutry343x43x)

## Reinstall Application's

```cmd
adb shell pm install-existing <package name>

OR

adb shell cmd package install-existing <package name>
```

### If you  want those apps back , Do a Factory reset ###
