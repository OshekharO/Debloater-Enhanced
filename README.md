<h1 align="center">
  <img alt="logo" src="https://i.ibb.co/MGDdGGV/debloat-enhanced-high-resolution-logo-black-on-transparent-background.png" width="300px"/><br/>
</h1>

# Debloat Enhanced

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

Battery drainer: Chrome & Quick Device Connect.

Ram killer: Athena. (Disappear Clear All Button)

OS Bricker: weather services, one handed mode, startup wizard.

## Links

* [Google USB Driver](https://developer.android.com/studio/run/win-usb)
  * [Official all OEMs drivers](https://developer.android.com/studio/run/oem-usb#Drivers)
* [Download ADB](https://developer.android.com/studio/releases/platform-tools)
* [Package Manager](https://play.google.com/store/apps/details?id=com.csdroid.pkg)
* [LABD Android](https://userupload.net/wutry343x43x)

## Reinstall Application's

```cmd
adb shell pm install-existing <package name>

OR

adb shell cmd package install-existing <package name>
```

### If you  want those apps back , Do a Factory reset ###
