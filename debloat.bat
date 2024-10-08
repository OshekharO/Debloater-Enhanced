@echo off

:: Version 1.3
:: Author: [Saksham Shekher]

echo.
echo "================================================================="
echo "                 Debloater Enhanced (Version 1.3)                "
echo "================================================================="
echo "Author: [Saksham Shekher]                                        "
echo "Warning: Debloat at your own risk!                               "
echo.

rem Get the device details
for /f "tokens=*" %%a in ('adb shell getprop ro.product.model') do set DEVICE_MODEL=%%a
for /f "tokens=*" %%a in ('adb shell getprop ro.product.brand') do set DEVICE_BRAND=%%a
for /f "tokens=*" %%a in ('adb shell getprop ro.build.version.release') do set ANDROID=%%a

echo
echo Model:       %DEVICE_MODEL%
echo Brand:       %DEVICE_BRAND%
echo Android:     %ANDROID%
echo.

:menu
echo 1  = List installed applications
echo 2  = Debloat Realme Apps
echo 3  = Debloat Google Apps
echo 4  = Debloat Xiaomi Apps
echo 5  = Custom uninstall
echo 0  = Exit
echo.

set /p option=Enter an option: 

if %option%==1 (
    echo.
    echo Listing installed applications...
    adb shell pm list packages -f

    echo.
    echo =================================================================
    echo                 Installed Applications Listed.                  
    echo =================================================================
    echo.

    goto postprocess
)

if %option%==2 (
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

    echo Uninstalling Statistics...
    adb shell pm uninstall --user 0 com.nearme.statistics.rom

    echo Disabling Theme Store...
    adb shell pm disable-user --user 0 com.heytap.themestore

    echo Disabling FM Radio...
    adb shell pm disable-user --user 0 com.android.fmradio

    echo Disabling Phone Manager...
    adb shell pm disable-user --user 0 com.coloros.phonemanager

    echo Disabling Glance...
    adb shell pm disable-user  --user 0 com.glance.internet

    echo.
    echo =================================================================
    echo                  Realme Apps Debloated.                         
    echo =================================================================
    echo.

    goto postprocess
)

if %option%==3 (
    echo.
    echo Uninstalling Google Duo...
    adb shell pm uninstall --user 0 com.google.android.apps.tachyon

    echo Uninstalling Google Pay...
    adb shell pm uninstall --user 0 com.google.android.apps.nbu.paisa.user

    echo Uninstalling Google One...
    adb shell pm uninstall --user 0 com.google.android.apps.subscriptions.red

    echo Uninstalling Accessibility Suite...
    adb shell pm uninstall --user 0 com.google.android.marvin.talkback

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
    echo                  Google Apps Debloated.                         
    echo =================================================================
    echo.

    goto postprocess
)

if %option%==4 (
    echo.
    echo Uninstalling Mi Browser...
    adb shell pm uninstall --user 0 com.android.browser

    echo Uninstalling Mi Store...
    adb shell pm uninstall --user 0 com.xiaomi.shop

    echo Uninstalling Facebook Services...
    adb shell pm uninstall --user 0 com.facebook.services

    echo Uninstalling Facebook Appmanager...
    adb shell pm uninstall --user 0 com.facebook.appmanager

    echo Uninstalling Facebook System...
    adb shell pm uninstall --user 0 com.facebook.system

    echo Uninstalling Facebook Katana...
    adb shell pm uninstall --user 0 com.facebook.katana

    echo Uninstalling Amazon...
    adb shell pm uninstall --user 0 in.amazon.mShop.android.shopping
    adb shell pm uninstall --user 0 com.amazon.appmanager

    echo Uninstalling Linkedin...
    adb shell pm uninstall --user 0 com.linkedin.android

    echo Uninstalling WPS...
    adb shell pm uninstall --user 0 cn.wps.xiaomi.abroad.lite

    echo Uninstalling Netflix...
    adb shell pm uninstall --user 0 com.netflix.mediaclient

    echo Uninstalling Analytics...
    adb shell pm uninstall --user 0 com.miui.analytics

    echo Uninstalling MI Feedback...
    adb shell pm uninstall --user 0 com.miui.bugreport

    echo Uninstalling Video Player...
    adb shell pm uninstall --user 0 com.miui.videoplayer

    echo Uninstalling Music Player...
    adb shell pm uninstall --user 0 com.miui.player

    echo Uninstalling Notes...
    adb shell pm uninstall --user 0 com.miui.notes

    echo Uninstalling Yellow Pages...
    adb shell pm uninstall --user 0 com.miui.yellowpage

    echo Uninstalling Main Advertising System...
    adb shell pm uninstall --user 0 com.miui.msa.global
    adb shell pm uninstall --user 0 com.miui.systemAdSolution

    echo Uninstalling MI Games...
    adb shell pm uninstall --user 0 com.xiaomi.glgm

    echo Uninstalling Daemon...
    adb shell pm uninstall --user 0 com.miui.daemon

    echo Uninstalling Xiaomi Recording Assistant...
    adb shell pm uninstall --user 0 com.miui.audiomonitor

    echo Uninstalling CarWith...
    adb shell pm uninstall --user 0 com.miui.carlink

    echo Uninstalling Translation...
    adb shell pm uninstall --user 0 com.miui.translation.kingsoft
    adb shell pm uninstall --user 0 com.miui.translation.xmcloud
    adb shell pm uninstall --user 0 com.miui.translationservice

    echo Uninstalling MI Cloud...
    adb shell pm uninstall --user 0 com.miui.cloudbackup
    adb shell pm uninstall --user 0 com.miui.cloudservice
    adb shell pm uninstall --user 0 com.miui.cloudservice.sysbase
    adb shell pm uninstall --user 0 com.miui.micloudsync

    echo Uninstalling MI Pay...
    adb shell pm uninstall --user 0 com.mipay.wallet.in
    adb shell pm uninstall --user 0 com.xiaomi.payment
    adb shell pm uninstall --user 0 com.miui.nextpay
    adb shell pm uninstall --user 0 com.unionpay.tsmservice.mi
    adb shell pm uninstall --user 0 org.mipay.android.manager
    adb shell pm uninstall --user 0 com.tencent.soter.soterserver

    echo.
    echo =================================================================
    echo                    Miui Apps Debloated.                          
    echo =================================================================
    echo.

    goto postprocess
)

if %option%==5 (
    echo.
    set /p package=Enter package name to uninstall: 
    echo Uninstalling %package%...
    adb shell pm uninstall --user 0 %package%

    echo.
    echo =================================================================
    echo                 Custom Uninstall Completed.                  
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
