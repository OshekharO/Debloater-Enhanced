# Debloater Enhanced — Multi-Brand Edition

:sparkles: ADB-based debloater for **OPPO / Realme / Xiaomi / Redmi / OnePlus** — ***No ROOT or Unlocked Bootloader Required!*** :sparkles:

## Overview

Debloater Enhanced v3.0 is a fully rewritten shell/batch script targeting bloatware found on ColorOS 13+, MIUI 14 / HyperOS, and OxygenOS 13/14 devices. It removes or disables unwanted pre-installed apps via ADB without requiring root access, improving performance, privacy, and battery life.

Packages are organised into focused categories so you can remove only what you do not need. A **dry-run mode** lets you preview every action before any change is made.

## Supported Devices

| Brand    | OS                       | Tested         |
|----------|--------------------------|----------------|
| OPPO     | ColorOS 13 / 14          | ✅             |
| Realme   | realmeUI 4.0 / 5.0       | ✅             |
| OnePlus  | OxygenOS 13 / 14         | ✅             |
| Xiaomi   | MIUI 14 / HyperOS 1/2    | ✅             |
| Redmi    | MIUI 14 / HyperOS 1/2    | ✅             |
| POCO     | MIUI 14 / HyperOS 1/2    | ⚠️ partial    |

> Scripts will warn you if the detected device brand is not in the supported list.

## Prerequisites

* Android Platform Tools (ADB) installed and in your system PATH
  * [Download Platform Tools](https://developer.android.com/studio/releases/platform-tools)
* USB Debugging enabled on your device
  * Settings → About Phone → tap **Build Number** seven times → Developer Options → enable **USB Debugging**
* A USB cable that supports data transfer

## Features

| Feature | Description |
|---------|-------------|
| **12 Debloat Categories** | ColorOS analytics, ColorOS bloat, Gaming, Payments, Social, Google, MIUI Analytics & Ads, MIUI System Apps, OnePlus/OxygenOS |
| **Dry-Run Mode** | Preview all actions without making any changes |
| **Per-Package Detection** | Skips packages not present on the device — no false failures |
| **Disable vs. Remove** | System-critical apps are disabled instead of uninstalled |
| **Reinstall / Restore** | Restore any removed package with a single menu option |
| **Session Logging** | Optionally write every action to a timestamped log file |
| **Session Summary** | See exactly how many packages were removed at the end |
| **Custom Uninstall** | Remove any package by entering its name manually |
| **ANSI Colour Output** | Color-coded status (REMOVED / DISABLED / SKIP / FAILED / DRY-RUN) |
| **Multi-Brand Detection** | Reads `ro.product.brand` and displays OS version for all brands |

## Debloat Categories

| # | Category | Brand | What is removed |
|---|----------|-------|-----------------|
| 2 | Analytics & Telemetry | ColorOS | HeyTap analytics, OPlus statistical/feedback, Tencent Soter, ColorOS diagnostics |
| 3 | ColorOS / OPPO Bloatware | ColorOS | Browser, music, video, cloud, community, share, compass, OCR, notes, health, AI emoji, lockscreen mag |
| 4 | Game Space & Gaming | ColorOS | Game Space UI/service, HeyFun, OPlus Games, NearMe game platform |
| 5 | Payment & Financial | ColorOS | OPlus Pay, ColorOS Secure Pay, Realme PaySa |
| 6 | Facebook & Social | All | Facebook Services, App Manager, System, Katana |
| 7 | Google Bloatware | All | Meet, GPay, Google One, TalkBack, YouTube, Assistant, Photos, Drive, AR Core, Auto, and more |
| 10 | Xiaomi/Redmi Analytics & Ads | MIUI/HyperOS | MIUI Analytics, Joyose, System Ad Service, Hybrid Ad Bridge, Mi Picks, Catchlog, Mi Service telemetry |
| 11 | Xiaomi/Redmi System Apps | MIUI/HyperOS | Minus Screen, Mi Music/Video/Notes/Weather, Mi Share, Mi Drop, Mi Home, WPS Lite, Yellow Pages, Sogou/Baidu/iFlytek IMEs |
| 12 | OnePlus / OxygenOS | OxygenOS | OnePlus Account, App Center, Store, Community, Log Kit, Gallery, File Manager, Wallet, Health, Game Space, Widgets |

## How to Use

1. **Download** the latest source code from this repository.

2. **Enable USB Debugging** on your device (see Prerequisites above).

3. **Connect** your device via USB. Tap **Allow** on the authorisation dialog on your phone.

4. **Run the script**:
   * **Windows**: double-click `debloat.bat` or run it in a Command Prompt.
   * **Linux / macOS**: `chmod +x debloat.sh && ./debloat.sh`

5. **Enable dry-run mode first** (option `[d]`) to see what will be removed without making any changes.

6. **Select a category** and type `yes` to confirm. The script shows `REMOVED`, `DISABLED`, `SKIP`, or `FAILED` for each package in real time.

7. **Restore** any accidentally removed package with option `[r]`.

## Important Warnings

* **Do NOT remove** `com.coloros.athena` (Clear All button), weather service, or startup wizard — these affect OS stability.
* **Payment apps**: Only remove if you are not using those specific payment services.
* **Game Space**: Removing it disables in-game FPS counter, network optimisation, and performance mode features.
* **MIUI Power Keeper** (`com.miui.powerkeeper`): Disabled, not uninstalled — removing it can break battery management.
* **MIUI Cloud / Xiaomi Account**: Only remove if you are not syncing contacts, notes, or backups via Xiaomi cloud.
* **OnePlus OPlus packages** (`com.oplus.*`): These are covered in the ColorOS/Analytics categories (not duplicated in [12]).
* **Backup your data** before debloating as a precaution.
* If anything goes wrong, **factory reset** restores all system apps.

## Reinstalling Removed Packages

```sh
# Reinstall a single package
adb shell cmd package install-existing <package.name>

# Example
adb shell cmd package install-existing com.heytap.music
```

## Useful Links

* [Download ADB / Platform Tools](https://developer.android.com/studio/releases/platform-tools)
* [Google USB Driver (Windows)](https://developer.android.com/studio/run/win-usb)
* [Official OEM USB Drivers](https://developer.android.com/studio/run/oem-usb#Drivers)
* [Package Manager app (Android)](https://play.google.com/store/apps/details?id=com.csdroid.pkg)

