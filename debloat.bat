@echo off

:: Version 1.1
:: Author: [Saksham Shekher]

echo.
echo "================================================================="
echo "                 Debloating Realme device (Version 1.1)          "
echo "================================================================="
echo "Author: [Saksham Shekher]                                        "
echo "Warning: Debloat at your own risk!                               "
echo.

set device=

rem Detect if phone is connected
for /f "tokens=1" %%a in ('adb devices -l ^| find "model:"') do set device=%%a

if "%device%" == "" (
    echo "No device connected. Please connect a Realme device and try again."
    pause
    exit /b
)

echo "Device detected: %device%"

rem Get the device details
for /f "tokens=*" %%a in ('adb shell getprop ro.product.model') do set DEVICE_MODEL=%%a
for /f "tokens=*" %%a in ('adb shell getprop ro.product.brand') do set DEVICE_BRAND=%%a
for /f "tokens=*" %%a in ('adb shell getprop ro.build.version.release') do set ANDROID=%%a

echo Device:      %DEVICE_NAME%                                        
echo Model:       %DEVICE_MODEL%                                                  
echo Brand:       %DEVICE_BRAND%
echo Android:     %ANDROID%
echo.

:menu
echo 1  = Debloat Realme Apps
echo 2  = Debloat Google Apps
echo 3  = Re-bloat Realme
echo 4  = List installed applications
echo 0  = Exit                                            ║                                                         
echo.

set /p option=Enter an option: 

if %option%==1 (
    echo.
    echo Uninstalling Hot Apps...
    adb shell pm uninstall --user 0 com.opos.cs

    echo Uninstalling Realme Community...
    adb shell pm uninstall --user 0 com.realmecomm.app

    echo Uninstalling Realme Music...
    adb shell pm uninstall --user 0 com.heytap.music

    echo Uninstalling Lockscreen Magazine...
    adb shell pm uninstall --user 0 com.heytap.pictorial

    echo Uninstalling Homescreen Search...
    adb shell pm uninstall --user 0 com.oppo.quicksearchbox

    echo Uninstalling Video Player...
    adb shell pm uninstall --user 0 com.coloros.video

    echo Uninstalling Realme Browser...
    adb shell pm uninstall --user 0 com.heytap.browser

    echo Uninstalling Tencent Telemetry...
    adb shell pm uninstall --user 0 com.tencent.soter.soterserver

    echo Uninstalling App Cloner...
    adb shell pm uninstall --user 0 com.oplus.multiapp

    echo Uninstalling Emergency SOS...
    adb shell pm uninstall --user 0 com.oppo.sos

    echo Uninstalling Compass...
    adb shell pm uninstall --user 0 com.coloros.compass2

    echo Uninstalling Realme Share...
    adb shell pm uninstall --user 0 com.coloros.oshare

    echo Uninstalling HeyFun...
    adb shell pm uninstall --user 0 com.heytap.quickgame

    echo Uninstalling Quick Device Connect...
    adb shell pm uninstall --user 0 com.heytap.accessory

    echo Uninstalling Sleep Capsule...
    adb shell pm uninstall --user 0 com.realme.wellbeing

    echo Uninstalling User Guide...
    adb shell pm uninstall --user 0 com.oppo.opperationManual

    echo Uninstalling OPPO Clone Phone...
    adb shell pm uninstall --user 0 com.coloros.oppomultiapp
    adb shell pm uninstall --user 0 com.coloros.backuprestore

    echo Uninstalling Game Space UI...
    adb shell pm uninstall --user 0 com.coloros.gamespaceui
    adb shell pm uninstall --user 0 com.coloros.gamespace

    echo Uninstalling Doc Vault...
    adb shell pm uninstall --user 0 com.os.docvault

    echo Uninstalling Finshell...
    adb shell pm uninstall --user 0 com.finshell.fin

    echo Uninstalling My Realme...
    adb shell pm uninstall --user 0 com.heytap.usercenter

    echo Uninstalling Oroaming...
    adb shell pm uninstall --user 0 com.redteamobile.roaming

    echo Uninstalling Secure Payment...
    adb shell pm uninstall --user 0 com.oplus.pay

    echo Uninstalling Secure Payment...
    adb shell pm uninstall --user 0 com.nearme.atlas

    echo Uninstalling Realme Cloud...
    adb shell pm uninstall --user 0 com.heytap.cloud

    echo Uninstalling Intelligent Analytics System...
    adb shell pm uninstall --user 0 com.heytap.habit.analysis

    echo Uninstalling E-warranty card...
    adb shell pm uninstall --user 0 com.coloros.activation

    echo Uninstalling Smart Driving...
    adb shell pm uninstall --user 0 com.coloros.smartdrive

    echo Uninstalling App Enhancement Services...
    adb shell pm uninstall --user 0 com.oplus.cosa

    echo Uninstalling Oplus LFEHer...
    adb shell pm uninstall --user 0 com.oplus.lfeh

    echo Uninstalling StdID...
    adb shell pm uninstall --user 0 com.oplus.stdid

    echo Uninstalling Hey Synergy...
    adb shell pm uninstall --user 0 com.oplus.synergy

    echo Uninstalling Security Analysis...
    adb shell pm uninstall --user 0 com.realme.securitycheck

    echo Uninstalling Payment Protection...
    adb shell pm uninstall --user 0 com.coloros.securepay

    echo Uninstalling Realme Paysa...
    adb shell pm uninstall --user 0 com.realmepay.payments

    echo Uninstalling Realme Feedback...
    adb shell pm uninstall --user 0 com.oplus.logkit

    echo Uninstalling CrashBox...
    adb shell pm uninstall --user 0 com.oplus.crashbox

    echo Uninstalling After-Sales Service...
    adb shell pm uninstall --user 0 com.oppoex.afterservice

    echo Uninstalling Combine Captions...
    adb shell pm uninstall --user 0 com.realme.movieshot

    echo Uninstalling Games...
    adb shell pm uninstall --user 0 com.oplus.games

    echo Uninstalling Smart Scan...
    adb shell pm uninstall --user 0 com.coloros.ocrscanner

    echo Uninstalling PC Connect...
    adb shell pm uninstall --user 0 com.oplus.linker

    echo Uninstalling Private Safe...
    adb shell pm uninstall --user 0 com.oplus.encryption

    echo Uninstalling Facebook Services...
    adb shell pm uninstall --user 0 com.facebook.services

    echo Uninstalling Facebook Appmanager...
    adb shell pm uninstall --user 0 com.facebook.appmanager

    echo Uninstalling Facebook System...
    adb shell pm uninstall --user 0 com.facebook.system

    echo Uninstalling Facebook Katana...
    adb shell pm uninstall --user 0 com.facebook.katana

    echo Disabling Theme Store...
    adb shell pm disable-user --user 0 com.heytap.themestore

    echo Disabling FM Radio...
    adb shell pm disable-user --user 0 com.android.fmradio

    echo Disabling Statistics...
    adb shell pm disable-user --user 0 com.nearme.statistics.rom

    echo Disabling Glance...
    adb shell pm disable-user  --user 0 com.glance.internet

    echo.
    echo =================================================================
    echo                  Realme apps debloated.                         
    echo =================================================================
    echo.

    goto postprocess
)

if %option%==2 (
    echo.
    echo Uninstalling Google Duo...
    adb shell pm uninstall --user 0 com.google.android.apps.tachyon

    echo Uninstalling Google Pay...
    adb shell pm uninstall --user 0 com.google.android.apps.nbu.paisa.user

    echo Uninstalling Google One...
    adb shell pm uninstall --user 0 com.google.android.apps.subscriptions.red

    echo Uninstalling Keep Notes...
    adb shell pm uninstall -k --user 0 com.google.android.keep

    echo Uninstalling Google Play Music...
    adb shell pm uninstall --user 0 com.google.android.music

    echo Uninstalling Google Play Movies...
    adb shell pm uninstall --user 0 com.google.android.videos

    echo Uninstalling Google Play Books...
    adb shell pm uninstall --user 0 com.google.android.apps.books

    echo Uninstalling Google Assistant...
    adb shell pm uninstall --user 0 com.android.hotwordenrollment.okgoogle
    adb shell pm uninstall --user 0 com.google.android.apps.googleassistant

    echo Uninstalling YouTube...
    adb shell pm uninstall --user 0 com.google.android.youtube

    echo Uninstalling Digital Wellbeing...
    adb shell pm uninstall --user 0 com.google.android.apps.wellbeing

    echo Uninstalling Google Podcast...
    adb shell pm uninstall --user 0 com.google.android.apps.podcasts

    echo Uninstalling Youtube Music...
    adb shell pm uninstall --user 0 com.google.android.apps.youtube.music

    echo Uninstalling Files By Google...
    adb shell pm uninstall --user 0 com.google.android.apps.nbu.files

    echo Uninstalling AR Core...
    adb shell pm uninstall --user 0 com.google.ar.core

    echo Uninstalling Print Service Component...
    adb shell pm uninstall --user 0 com.google.android.printservice.recommendation

    echo Uninstalling Google Lens...
    adb shell pm uninstall --user 0 com.google.ar.lens

    echo Uninstalling Google Drive...
    adb shell pm uninstall --user 0 com.google.android.apps.docs

    echo Uninstalling Google Photos...
    adb shell pm uninstall --user 0 com.google.android.apps.photos

    echo Uninstalling Market Feedback Agent...
    adb shell pm uninstall --user 0 com.google.android.feedback

    echo Uninstalling Android Auto...
    adb shell pm uninstall --user 0 com.google.android.projection.gearhead

    echo Disabling SIM Toolkit...
    adb shell pm disable-user --user 0 com.android.stk

    echo Disabling NFC Service...
    adb shell pm disable-user --user 0 com.android.nfc

    echo.
    echo =================================================================
    echo                  Google apps debloated.                         
    echo =================================================================
    echo.

    goto postprocess
)

if %option%==3 (
    echo.
    echo Re-bloating Realme apps...
    adb shell cmd package install-existing

    echo.
    echo =================================================================
    echo                    Realme apps rebloated.                          
    echo =================================================================
    echo.

    goto postprocess
)

if %option%==4 (
    echo.
    echo Listing installed applications...
    adb shell pm list packages -f

    echo.
    echo =================================================================
    echo                 Installed applications listed.                  
    echo =================================================================
    echo.

    goto postprocess
)

if %option%==0 (
    echo.
    echo Exiting...
    exit
)

echo Invalid option.
goto menu

:postprocess
set /p exit=Press 0 to return to the menu: 
if %exit%==0 (
    goto menu
)
