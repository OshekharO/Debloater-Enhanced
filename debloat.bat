@echo off
setlocal enabledelayedexpansion

:: =============================================================================
:: Debloater Enhanced - Multi-Brand Edition
:: Version 2.0  |  Author: Saksham Shekher
:: Targets: OPPO / Realme (ColorOS 13+) | Xiaomi / Redmi (MIUI 14 / HyperOS)
::          OnePlus (OxygenOS 13/14)
:: =============================================================================
:: DISCLAIMER: Use at your own risk. Review each category before proceeding.
:: To restore any removed package:
::   adb shell cmd package install-existing <package.name>
:: =============================================================================

:: ── ANSI color support (Windows 10 v1511+) ───────────────────────────────────
for /f %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set "RED=%ESC%[31m"
set "GREEN=%ESC%[32m"
set "YELLOW=%ESC%[33m"
set "BLUE=%ESC%[1;34m"
set "MAGENTA=%ESC%[35m"
set "CYAN=%ESC%[36m"
set "BOLD=%ESC%[1m"
set "DIM=%ESC%[2m"
set "NC=%ESC%[0m"

:: ── Runtime state ─────────────────────────────────────────────────────────────
set DRY_RUN=0
set LOG_ENABLED=0
set REMOVED_COUNT=0
set DISABLED_COUNT=0
set "RESTORE_FILE="
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value 2^>nul') do set "WMIC_DT=%%a"
if defined WMIC_DT (
    set "LOG_FILE=debloater_!WMIC_DT:~0,8!_!WMIC_DT:~8,6!.log"
    set "RESTORE_FILE=restore_packages_!WMIC_DT:~0,8!_!WMIC_DT:~8,6!.txt"
) else (
    set "LOG_FILE=debloater_session.log"
    set "RESTORE_FILE=restore_packages_session.txt"
)

cls
call :print_banner
call :check_adb
call :check_device
call :print_device_info
call :main_menu
goto :eof

:: =============================================================================
:print_banner
echo.
echo %MAGENTA%%BOLD%  +========================================================+
echo   ^|    Debloater Enhanced - Multi-Brand Edition           ^|
echo   ^|                    Version 2.0                        ^|
echo   +========================================================+%NC%
echo.
echo   %DIM%Author  : Saksham Shekher%NC%
echo   %RED%%BOLD%WARNING : Debloat at your own risk!%NC%
echo   %DIM%Tip     : Enable dry-run [d] first to preview changes.%NC%
echo.
goto :eof

:: =============================================================================
:check_adb
where adb >nul 2>&1
if %errorlevel% neq 0 (
    echo   %RED%[ERR]%NC%   ADB not found in PATH.
    echo          Install Android Platform Tools and add to PATH.
    echo          Download: https://developer.android.com/studio/releases/platform-tools
    pause
    exit /b 1
)
goto :eof

:: =============================================================================
:check_device
for /f "tokens=*" %%a in ('adb devices 2^>nul ^| findstr /r /c:"	device$"') do set "DEVICE_FOUND=%%a"
if not defined DEVICE_FOUND (
    echo   %RED%[ERR]%NC%   No authorised device detected.
    echo.
    echo          Steps to fix:
    echo          1. Enable USB Debugging: Settings - About Phone - tap Build Number x7
    echo          2. Connect via USB and tap Allow on device prompt
    echo          3. Ensure your USB cable supports data transfer
    echo.
    pause
    exit /b 1
)
goto :eof

:: =============================================================================
:print_device_info
for /f "tokens=*" %%a in ('adb shell getprop ro.product.model 2^>nul') do set "DEVICE_MODEL=%%a"
for /f "tokens=*" %%a in ('adb shell getprop ro.product.brand 2^>nul') do set "DEVICE_BRAND=%%a"
for /f "tokens=*" %%a in ('adb shell getprop ro.build.version.release 2^>nul') do set "ANDROID_VER=%%a"
for /f "tokens=*" %%a in ('adb shell getprop ro.build.version.oplusrom.display 2^>nul') do set "COLOROS_VER=%%a"
if not defined COLOROS_VER (
    for /f "tokens=*" %%a in ('adb shell getprop ro.coloros.version.display 2^>nul') do set "COLOROS_VER=%%a"
)
if not defined COLOROS_VER set "COLOROS_VER=N/A"
for /f "tokens=*" %%a in ('adb shell getprop ro.miui.ui.version.name 2^>nul') do set "MIUI_VER=%%a"
if not defined MIUI_VER set "MIUI_VER=N/A"

echo   %BOLD%Connected Device%NC%
echo   +-----------------------------------+
echo   ^|  Model   : !DEVICE_MODEL!
echo   ^|  Brand   : !DEVICE_BRAND!
echo   ^|  Android : !ANDROID_VER!
echo   ^|  ColorOS : !COLOROS_VER!
echo   ^|  MIUI/HOS: !MIUI_VER!
echo   +-----------------------------------+
echo.

set "BRAND_LC=!DEVICE_BRAND!"
for %%b in (oppo realme oneplus xiaomi redmi poco) do (
    if /i "!DEVICE_BRAND!"=="%%b" set "BRAND_LC=known"
)
if /i "!BRAND_LC!"=="known" goto :eof
echo   %YELLOW%[WARN]%NC%  This script targets OPPO/Realme/Xiaomi/Redmi/OnePlus devices.
echo   %YELLOW%[WARN]%NC%  Detected brand: !DEVICE_BRAND!. Package names may not match.
echo.
goto :eof

:: =============================================================================
:: :init_restore_file  — writes the restore-file header the first time it is called
:init_restore_file
if exist "!RESTORE_FILE!" goto :eof
for /f "tokens=*" %%a in ('adb shell getprop ro.product.model 2^>nul') do set "RF_MODEL=%%a"
for /f "tokens=*" %%a in ('adb shell getprop ro.product.brand 2^>nul') do set "RF_BRAND=%%a"
(
    echo # Debloater Enhanced -- Package Restore List
    echo # Generated : %DATE% %TIME%
    echo # Device    : !RF_MODEL! ^(!RF_BRAND!^)
    echo #
    echo # To reinstall a REMOVED package:
    echo #   adb shell cmd package install-existing ^<package_id^>
    echo #
    echo # To re-enable a DISABLED package:
    echo #   adb shell pm enable --user 0 ^<package_id^>
    echo # ──────────────────────────────────────────────────────────
) > "!RESTORE_FILE!"
goto :eof

:: =============================================================================
:: :uninstall_pkg  %1=package  %2=friendly-name
:uninstall_pkg
adb shell pm list packages 2>nul | findstr /c:"package:%~1" >nul 2>&1
if %errorlevel% neq 0 (
    echo   %DIM%  SKIP    %~1 (not installed)%NC%
    goto :eof
)
if !DRY_RUN!==1 (
    echo   %YELLOW%  DRY-RUN%NC% Would remove: %BOLD%%~2%NC% ^(%~1^)
    goto :eof
)
for /f "tokens=*" %%r in ('adb shell pm uninstall --user 0 "%~1" 2^>^&1') do set "PM_RESULT=%%r"
echo !PM_RESULT! | findstr /c:"Success" >nul 2>&1
if !errorlevel!==0 (
    echo   %GREEN%  REMOVED%NC% %BOLD%%~2%NC% ^(%~1^)
    set /a REMOVED_COUNT+=1
    if !LOG_ENABLED!==1 echo REMOVED %~1 - %~2 >> "!LOG_FILE!"
    call :init_restore_file
    >>"!RESTORE_FILE!" echo %~1   # REMOVED
) else (
    echo   %RED%  FAILED%NC%  %BOLD%%~2%NC% ^(%~1^)
    if !LOG_ENABLED!==1 echo FAILED  %~1 - %~2 >> "!LOG_FILE!"
)
goto :eof

:: =============================================================================
:: :disable_pkg  %1=package  %2=friendly-name
:disable_pkg
adb shell pm list packages 2>nul | findstr /c:"package:%~1" >nul 2>&1
if %errorlevel% neq 0 (
    echo   %DIM%  SKIP    %~1 (not installed)%NC%
    goto :eof
)
if !DRY_RUN!==1 (
    echo   %YELLOW%  DRY-RUN%NC% Would disable: %BOLD%%~2%NC% ^(%~1^)
    goto :eof
)
for /f "tokens=*" %%r in ('adb shell pm disable-user --user 0 "%~1" 2^>^&1') do set "PM_RESULT=%%r"
echo !PM_RESULT! | findstr /i "disabled" >nul 2>&1
if !errorlevel!==0 (
    echo   %CYAN%  DISABLED%NC% %BOLD%%~2%NC% ^(%~1^)
    if !LOG_ENABLED!==1 echo DISABLED %~1 - %~2 >> "!LOG_FILE!"
    set /a DISABLED_COUNT+=1
    call :init_restore_file
    >>"!RESTORE_FILE!" echo %~1   # DISABLED
) else (
    echo   %RED%  FAILED%NC%  disable %BOLD%%~2%NC% ^(%~1^)
)
goto :eof

:: =============================================================================
:: :confirm  %1=prompt  -> sets CONFIRMED=1 if user types "yes"
:confirm
set "CONFIRMED=0"
echo.
echo   %YELLOW%%~1%NC%
set /p "ANSWER=  Type yes to proceed, anything else to cancel: "
if /i "!ANSWER!"=="yes" set "CONFIRMED=1"
goto :eof

:: =============================================================================
:debloat_analytics
echo.
echo %BLUE%  == Analytics, Telemetry ^& Spyware ==%NC%
echo   %DIM%Removes silent data-collection, crash reporting and ad-serving components.%NC%
call :confirm "Remove analytics & telemetry packages?"
if !CONFIRMED!==0 (echo   %CYAN%[INFO]%NC%  Skipped. & goto :eof)

call :uninstall_pkg "com.heytap.habit.analysis"     "HeyTap Intelligent Analytics"
call :uninstall_pkg "com.nearme.statistics.rom"      "NearMe ROM Statistics"
call :uninstall_pkg "com.oplus.logkit"               "OPlus Feedback / Log Kit"
call :uninstall_pkg "com.oplus.crashbox"             "OPlus CrashBox"
call :uninstall_pkg "com.oplus.statistical"          "OPlus Statistical Service"
call :uninstall_pkg "com.tencent.soter.soterserver"  "Tencent Soter Server (Telemetry)"
call :uninstall_pkg "com.coloros.activation"         "ColorOS E-Warranty / Activation"
call :uninstall_pkg "com.oplus.stdid"                "OPlus Standard ID Service"
call :uninstall_pkg "com.oplus.lfeh"                 "OPlus LFEHer (Behaviour Tracking)"
call :uninstall_pkg "com.oppoex.afterservice"        "OPPO After-Sales Diagnostics"
call :uninstall_pkg "com.realme.securitycheck"       "Realme Security Analysis"
call :uninstall_pkg "com.opos.cs"                    "OPOS Content Services / Hot Apps"
call :uninstall_pkg "com.coloros.diag"               "ColorOS Diagnostics Daemon"
call :uninstall_pkg "com.nearme.push"                "NearMe Push Service (Ad Notifications)"
call :uninstall_pkg "com.oplus.aiunit"               "OPlus AI Unit (Behavioural Analytics)"
call :uninstall_pkg "com.oplus.omcservice"           "OPlus Operator Management Content (Promos)"
call :uninstall_pkg "com.coloros.athena"             "ColorOS Athena (AI Telemetry Service)"
call :uninstall_pkg "com.coloros.avastofferwall"     "Avast Offer Wall (Ad/Tracking Preload)"
call :uninstall_pkg "com.coloros.bootreg"            "ColorOS Boot Registry (System Stats)"
call :uninstall_pkg "com.coloros.healthcheck"        "ColorOS Health Check Service"
call :uninstall_pkg "com.coloros.resmonitor"         "ColorOS Resource Monitor"
call :uninstall_pkg "com.coloros.sauhelper"          "ColorOS SAU Helper (Usage Analytics)"
call :uninstall_pkg "com.coloros.sceneservice"       "ColorOS Scene Service (Usage Tracking)"
call :uninstall_pkg "com.oppo.ScoreAppMonitor"       "OPPO Score App Monitor"
call :uninstall_pkg "com.oppo.criticallog"           "OPPO Critical Log Service"
call :uninstall_pkg "com.oppo.logkit"                "OPPO Log Kit"
call :uninstall_pkg "com.oppo.qualityprotect"        "OPPO Quality Protect"
call :uninstall_pkg "com.oppo.startlogkit"           "OPPO Startup Log Kit"
call :uninstall_pkg "com.oppo.usageDump"             "OPPO Usage Dump"
call :uninstall_pkg "com.oppo.lfeh"                  "OPPO LFEH Behaviour Tracking"
call :disable_pkg   "com.coloros.safesdkproxy"       "ColorOS Safe SDK Proxy"
call :disable_pkg   "com.oppo.nw"                    "OPPO Network Service Monitor"
call :disable_pkg   "com.oppo.rftoolkit"             "OPPO RF Toolkit (Factory Diagnostics)"
call :disable_pkg   "com.oppo.wifirf"                "OPPO WiFi RF Test Tool"
call :disable_pkg   "com.oppo.bttestmode"            "OPPO Bluetooth Test Mode"
call :disable_pkg   "com.dsi.ant.server"             "DSI ANT+ Server"

echo   %GREEN%[OK]%NC%    Analytics ^& telemetry debloated.
goto :eof

:: =============================================================================
:debloat_coloros
echo.
echo %BLUE%  == ColorOS / OPPO System Bloatware ==%NC%
echo   %DIM%Removes pre-installed OPPO/Realme apps not essential to ColorOS 13.1.%NC%
call :confirm "Remove ColorOS bloatware?"
if !CONFIRMED!==0 (echo   %CYAN%[INFO]%NC%  Skipped. & goto :eof)

call :uninstall_pkg "com.heytap.browser"             "HeyTap Browser"
call :uninstall_pkg "com.oppo.quicksearchbox"        "OPPO Home Screen Search"
call :uninstall_pkg "com.nearme.browser"             "NearMe Browser"
call :uninstall_pkg "com.heytap.music"               "HeyTap Music"
call :uninstall_pkg "com.coloros.video"              "ColorOS Video Player"
call :uninstall_pkg "com.realme.movieshot"           "Realme MovieShot / Combine Captions"
call :uninstall_pkg "com.oppo.music"                 "OPPO Music Player"
call :uninstall_pkg "com.heytap.cloud"               "HeyTap Cloud"
call :uninstall_pkg "com.coloros.backuprestore"      "ColorOS Backup ^& Restore"
call :uninstall_pkg "com.coloros.backuprestore.remoteservice" "ColorOS Backup Remote Service"
call :uninstall_pkg "com.coloros.wifibackuprestore"  "ColorOS WiFi Backup ^& Restore"
call :uninstall_pkg "com.realmecomm.app"             "Realme Community"
call :uninstall_pkg "com.heytap.usercenter"          "My OPPO / HeyTap User Centre"
call :uninstall_pkg "com.oppo.usercenter"            "OPPO User Center"
call :uninstall_pkg "com.heytap.market"              "HeyTap GetApps Market"
call :uninstall_pkg "com.oppo.market"                "OPPO App Market"
call :uninstall_pkg "com.nearme.themestore"          "NearMe Theme Store"
call :uninstall_pkg "com.coloros.compass2"           "ColorOS Compass"
call :uninstall_pkg "com.coloros.oshare"             "O-Share (File Transfer)"
call :uninstall_pkg "com.coloros.ocrscanner"         "ColorOS Smart Scan (OCR)"
call :uninstall_pkg "com.coloros.smartdrive"         "ColorOS Smart Driving"
call :uninstall_pkg "com.coloros.oppomultiapp"       "OPPO Clone Phone"
call :uninstall_pkg "com.oplus.multiapp"             "OPlus App Cloner"
call :uninstall_pkg "com.oppo.opperationManual"      "OPPO User Guide / Manual (legacy)"
call :uninstall_pkg "com.oppo.operationManual"       "OPPO Operation Manual"
call :uninstall_pkg "com.os.docvault"                "Doc Vault"
call :uninstall_pkg "com.redteamobile.roaming"       "O-Roaming (eSIM Roaming)"
call :uninstall_pkg "com.redteamobile.roaming.deamon" "Red Mobile Roaming Daemon"
call :uninstall_pkg "com.nearme.atlas"               "OPPO Atlas"
call :uninstall_pkg "com.oppo.atlas"                 "OPPO Atlas Service"
call :uninstall_pkg "com.heytap.accessory"           "Quick Device Connect"
call :uninstall_pkg "com.realme.wellbeing"           "Realme Wellbeing / Sleep Capsule"
call :uninstall_pkg "com.oplus.linker"               "OPlus PC Connect"
call :uninstall_pkg "com.oplus.synergy"              "Hey Synergy (Cross-Device)"
call :uninstall_pkg "com.finshell.fin"               "Finshell"
call :uninstall_pkg "com.oplus.cosa"                 "App Enhancement Engine (COSA)"
call :uninstall_pkg "com.heytap.pictorial"           "Lockscreen Magazine"
call :uninstall_pkg "com.oppo.sos"                   "OPPO Emergency SOS"
call :uninstall_pkg "com.oplus.encryption"           "Private Safe"
call :uninstall_pkg "com.coloros.note"               "ColorOS Notes"
call :uninstall_pkg "com.coloros.healthkit"          "ColorOS Health"
call :uninstall_pkg "com.oplus.voiceassistant"       "OPlus Voice Assistant"
call :uninstall_pkg "com.oplus.omoji"                "OPlus Omoji (AR Emoji)"
call :uninstall_pkg "com.oplus.babelfish"            "OPlus Babelfish Translation"
call :uninstall_pkg "com.heytap.speechassist"        "HeyTap Speech Assistant"
call :uninstall_pkg "com.nearme.live"                "NearMe Live Streaming"
call :uninstall_pkg "com.coloros.tips"               "ColorOS Tips ^& What's New"
call :uninstall_pkg "com.heytap.easyswitch"          "HeyTap Easy Switch (Cross-Device)"
call :uninstall_pkg "com.oppo.assistivetouch"        "OPPO Assistive Touch / Navigator Ball"
call :uninstall_pkg "com.coloros.assistantscreen"    "ColorOS Assistant Screen"
call :uninstall_pkg "com.coloros.childrenspace"      "ColorOS Children's Space"
call :uninstall_pkg "com.coloros.floatassistant"     "ColorOS Float Assistant"
call :uninstall_pkg "com.coloros.focusmode"          "ColorOS Focus Mode"
call :uninstall_pkg "com.coloros.phonenoareainquire" "ColorOS Phone Number Area Inquiry"
call :uninstall_pkg "com.coloros.pictorial"          "ColorOS Pictorial / Magazine"
call :uninstall_pkg "com.coloros.screenrecorder"     "ColorOS Screen Recorder"
call :uninstall_pkg "com.coloros.soundrecorder"      "ColorOS Sound Recorder"
call :uninstall_pkg "com.coloros.speechassist"       "ColorOS Speech Assist"
call :uninstall_pkg "com.coloros.translate.engine"   "ColorOS Translate Engine"
call :uninstall_pkg "com.coloros.calculator"         "ColorOS Calculator"
call :uninstall_pkg "com.coloros.encryption"         "ColorOS Private Safe (Secure Vault)"
call :uninstall_pkg "com.oppo.mimosiso"              "OPPO Mimosiso"
call :uninstall_pkg "com.oppo.ovoicemanager"         "OPPO Voice Manager"
call :uninstall_pkg "com.oppo.partnerbrowsercustomizations" "OPPO Partner Browser Customizations"

call :disable_pkg   "com.heytap.themestore"          "HeyTap Theme Store"
call :disable_pkg   "com.coloros.phonemanager"       "ColorOS Phone Manager"
call :disable_pkg   "com.caf.fmradio"                "Qualcomm CAF FM Radio"
call :disable_pkg   "com.android.fmradio"            "FM Radio"
call :disable_pkg   "com.glance.internet"            "Glance (Lock Screen Ads)"

echo   %GREEN%[OK]%NC%    ColorOS bloatware debloated.
goto :eof

:: =============================================================================
:debloat_gaming
echo.
echo %BLUE%  == Game Space ^& Gaming Services ==%NC%
echo   %DIM%Removes Game Space UI, HeyFun platform and associated gaming services.%NC%
echo   %YELLOW%[WARN]%NC%  Removing Game Space disables its in-game FPS and network optimisations.
call :confirm "Remove game-related bloatware?"
if !CONFIRMED!==0 (echo   %CYAN%[INFO]%NC%  Skipped. & goto :eof)

call :uninstall_pkg "com.coloros.gamespaceui"        "ColorOS Game Space UI"
call :uninstall_pkg "com.coloros.gamespace"          "ColorOS Game Space Service"
call :uninstall_pkg "com.heytap.quickgame"           "HeyTap HeyFun / Quick Game"
call :uninstall_pkg "com.oplus.games"                "OPlus Games Platform"
call :uninstall_pkg "com.nearme.game.platform"       "NearMe Game Platform"

echo   %GREEN%[OK]%NC%    Gaming bloatware removed.
goto :eof

:: =============================================================================
:debloat_payments
echo.
echo %BLUE%  == Payment ^& Financial Apps ==%NC%
echo   %DIM%Removes pre-installed regional payment and banking apps.%NC%
echo   %YELLOW%[WARN]%NC%  Skip this category if you actively use any of these services.
call :confirm "Remove payment & financial apps?"
if !CONFIRMED!==0 (echo   %CYAN%[INFO]%NC%  Skipped. & goto :eof)

call :uninstall_pkg "com.oplus.pay"                  "OPlus Pay / Secure Payment"
call :uninstall_pkg "com.coloros.securepay"          "ColorOS Secure Pay"
call :uninstall_pkg "com.realmepay.payments"         "Realme PaySa"
call :uninstall_pkg "com.coloros.wallet"             "ColorOS Wallet"

echo   %GREEN%[OK]%NC%    Payment apps removed.
goto :eof

:: =============================================================================
:debloat_social
echo.
echo %BLUE%  == Facebook ^& Social Media Preloads ==%NC%
echo   %DIM%Removes Facebook system-level preloads and silent installer components.%NC%
call :confirm "Remove Facebook & social preloads?"
if !CONFIRMED!==0 (echo   %CYAN%[INFO]%NC%  Skipped. & goto :eof)

call :uninstall_pkg "com.facebook.services"          "Facebook Services"
call :uninstall_pkg "com.facebook.appmanager"        "Facebook App Manager"
call :uninstall_pkg "com.facebook.system"            "Facebook System"
call :uninstall_pkg "com.facebook.katana"            "Facebook (Katana)"

echo   %GREEN%[OK]%NC%    Social media preloads removed.
goto :eof

:: =============================================================================
:debloat_google
echo.
echo %BLUE%  == Google Bloatware ==%NC%
echo   %DIM%Removes non-essential Google apps. Core GMS services are NOT touched.%NC%
echo   %YELLOW%[WARN]%NC%  Removing Assistant may break some Google integrations.
call :confirm "Remove Google bloatware?"
if !CONFIRMED!==0 (echo   %CYAN%[INFO]%NC%  Skipped. & goto :eof)

call :uninstall_pkg "com.google.android.apps.tachyon"              "Google Meet / Duo"
call :uninstall_pkg "com.google.android.apps.nbu.paisa.user"       "Google Pay (GPay India)"
call :uninstall_pkg "com.google.android.apps.subscriptions.red"    "Google One"
call :uninstall_pkg "com.google.android.marvin.talkback"           "TalkBack (Accessibility)"
call :uninstall_pkg "com.google.android.keep"                      "Google Keep Notes"
call :uninstall_pkg "com.google.android.music"                     "Google Play Music (legacy)"
call :uninstall_pkg "com.google.android.videos"                    "Google Play Movies ^& TV"
call :uninstall_pkg "com.google.android.apps.books"                "Google Play Books"
call :uninstall_pkg "com.android.hotwordenrollment.okgoogle"       "OK Google Hotword Enrolment"
call :uninstall_pkg "com.android.hotwordenrollment.xgoogle"        "X Google Hotword Enrolment"
call :uninstall_pkg "com.google.android.apps.googleassistant"      "Google Assistant"
call :uninstall_pkg "com.google.android.youtube"                   "YouTube"
call :uninstall_pkg "com.google.android.apps.wellbeing"            "Google Digital Wellbeing"
call :uninstall_pkg "com.google.android.apps.podcasts"             "Google Podcasts"
call :uninstall_pkg "com.google.android.apps.youtube.music"        "YouTube Music"
call :uninstall_pkg "com.google.android.apps.nbu.files"            "Files by Google"
call :uninstall_pkg "com.google.ar.core"                           "Google AR Core"
call :uninstall_pkg "com.google.android.printservice.recommendation" "Print Service Recommender"
call :uninstall_pkg "com.google.ar.lens"                           "Google Lens (AR)"
call :uninstall_pkg "com.google.android.apps.docs"                 "Google Drive / Docs"
call :uninstall_pkg "com.google.android.feedback"                  "Google Market Feedback Agent"
call :uninstall_pkg "com.google.android.projection.gearhead"       "Android Auto"
call :uninstall_pkg "com.google.android.apps.safetyhub"            "Google Personal Safety"
call :uninstall_pkg "com.google.android.googlequicksearchbox"      "Google Search App (GSB)"
call :uninstall_pkg "com.google.android.apps.restore"              "Google Device Restore"
call :uninstall_pkg "com.google.android.onetimeinitializer"        "Google One-Time Initializer"
call :uninstall_pkg "com.google.android.apps.healthdata"           "Google Health Data"
call :uninstall_pkg "com.google.android.adservices.api"            "Google Ad Services API"
call :disable_pkg   "com.android.stk"                              "SIM Toolkit"
call :disable_pkg   "com.android.nfc"                              "NFC Service"
call :disable_pkg   "com.google.android.setupwizard"               "Google Setup Wizard"
call :disable_pkg   "com.google.android.federatedcompute"          "Google Federated Compute (ML)"
call :disable_pkg   "com.google.android.healthconnect.controller"  "Health Connect"
call :disable_pkg   "com.google.android.gms.location.history"      "Google Location History"
call :disable_pkg   "com.google.android.gms.supervision"           "Google Family Link / Supervision"
call :disable_pkg   "com.google.mainline.adservices"               "Google Mainline Ad Services"
call :disable_pkg   "com.google.mainline.telemetry"                "Google Mainline Telemetry"
call :disable_pkg   "com.google.android.as.oss"                    "Android System Intelligence (OSS)"
call :disable_pkg   "com.google.android.ondevicepersonalization.services" "Google On-Device Personalisation"
call :disable_pkg   "com.google.ambient.streaming"                 "Google Ambient Streaming (Cast)"
call :disable_pkg   "com.google.android.accessibility.switchaccess" "Google Switch Access (Accessibility)"
call :disable_pkg   "com.google.android.overlay.modules.healthfitness.forframework" "Google Health Fitness Overlay"

echo   %GREEN%[OK]%NC%    Google bloatware debloated.
goto :eof

:: =============================================================================
:debloat_miui_analytics
echo.
echo %BLUE%  == Xiaomi / Redmi Analytics, Ads ^& Telemetry ==%NC%
echo   %DIM%Removes MIUI/HyperOS ad services, usage trackers, and telemetry daemons.%NC%
echo   %YELLOW%[INFO]%NC%  Safe on all Xiaomi and Redmi global/India ROM builds.
call :confirm "Remove Xiaomi/Redmi analytics & ad packages?"
if !CONFIRMED!==0 (echo   %CYAN%[INFO]%NC%  Skipped. & goto :eof)

call :uninstall_pkg "com.miui.analytics"              "MIUI Analytics (Telemetry Beacon)"
call :uninstall_pkg "com.xiaomi.joyose"               "Xiaomi Joyose (Ad ^& Usage Targeting)"
call :uninstall_pkg "com.miui.msa.global"             "MIUI System Ad Service"
call :uninstall_pkg "com.miui.hybrid"                 "MIUI Hybrid Ad Bridge"
call :uninstall_pkg "com.miui.systemadserver"         "MIUI System Ad Server"
call :uninstall_pkg "com.miui.contentcatcher"         "MIUI Content Catcher (Ad Feeds)"
call :uninstall_pkg "com.miui.global.mab"             "MIUI Mobile Ad Bridge (Global)"
call :uninstall_pkg "com.miui.mab"                    "MIUI Mobile Ad Bridge"
call :uninstall_pkg "com.miui.bugreport"              "MIUI Bug Report ^& Feedback"
call :uninstall_pkg "com.xiaomi.mipicks"              "Mi Picks (Promotional Content)"
call :uninstall_pkg "com.bsp.catchlog"                "BSP Catchlog (System Telemetry)"
call :uninstall_pkg "com.xiaomi.miservice"            "Xiaomi Mi Service Framework (Telemetry)"
call :uninstall_pkg "com.miui.catcherpatch"           "MIUI Catcher Patch"
call :uninstall_pkg "com.miui.global.analytics"       "MIUI Global Analytics"
call :uninstall_pkg "com.miui.hybrid.xiaomihybrid"    "Xiaomi Hybrid Ad Service"
call :uninstall_pkg "com.xiaomi.aiasst.service"       "Xiaomi AI Assistant Service (Telemetry)"
call :uninstall_pkg "com.xiaomi.aiasst.vision"        "Xiaomi AI Vision Analytics"
call :uninstall_pkg "com.xiaomi.barrage"              "Xiaomi Barrage (Notification Bullets)"
call :disable_pkg   "com.miui.misightservice"         "MIUI MiSight Analytics Service"
call :disable_pkg   "com.miui.daemon"                 "MIUI Background Daemon"

echo   %GREEN%[OK]%NC%    Xiaomi/Redmi analytics ^& ad packages removed.
goto :eof

:: =============================================================================
:debloat_miui_apps
echo.
echo %BLUE%  == Xiaomi / Redmi System App Bloatware ==%NC%
echo   %DIM%Removes pre-installed MIUI/HyperOS apps replaceable with alternatives.%NC%
echo   %YELLOW%[WARN]%NC%  Mi Pay / Xiaomi Payment - skip if actively using Xiaomi Pay.
call :confirm "Remove Xiaomi/Redmi system bloat apps?"
if !CONFIRMED!==0 (echo   %CYAN%[INFO]%NC%  Skipped. & goto :eof)

call :uninstall_pkg "com.mi.android.globalminusscreen" "Global Minus Screen (News Feed)"
call :uninstall_pkg "com.miui.minusscreen"             "Minus Screen (Swipe-Left Feed)"
call :uninstall_pkg "com.miui.personalassistant"       "MIUI Personal Assistant (Mi Daily)"
call :uninstall_pkg "com.miui.contentextension"        "MIUI Content Extension (AI Recs)"
call :uninstall_pkg "com.miui.newhome"                 "MIUI New Home (Wallpaper Suggestions)"
call :uninstall_pkg "com.miui.suggest"                 "MIUI App Suggestions"
call :uninstall_pkg "com.miui.android.fashiongallery"  "MIUI Fashion Gallery (Lock Screen Mag)"
call :uninstall_pkg "com.miui.miwallpaper"             "MIUI AI Wallpaper"
call :uninstall_pkg "com.miui.player"                  "Mi Music Player"
call :uninstall_pkg "com.miui.videoplayer"             "Mi Video Player"
call :uninstall_pkg "com.miui.notes"                   "Mi Notes"
call :uninstall_pkg "com.miui.compass"                 "Mi Compass"
call :uninstall_pkg "com.miui.fm"                      "Mi FM Radio"
call :uninstall_pkg "com.miui.qr"                      "MIUI QR Scanner"
call :uninstall_pkg "com.xiaomi.scanner"               "Xiaomi Smart Scanner"
call :uninstall_pkg "com.miui.supercut"                "MIUI Super Cut (Scrolling Screenshot)"
call :uninstall_pkg "com.miui.touchassistant"          "MIUI Touch Assistant (Floating Ball)"
call :uninstall_pkg "com.miui.voiceassist"             "Mi Voice Assistant"
call :uninstall_pkg "com.miui.mishare.connectivity"    "Mi Share (File Transfer)"
call :uninstall_pkg "com.xiaomi.midrop"                "Mi Drop (P2P File Sharing)"
call :uninstall_pkg "com.milink.service"               "MiLink Cross-Device Service"
call :uninstall_pkg "com.miui.cloudbackup"             "MIUI Cloud Backup"
call :uninstall_pkg "com.miui.cloudservice"            "MIUI Cloud Service"
call :uninstall_pkg "com.xiaomi.smarthome"             "Mi Home (Smart Home Hub)"
call :uninstall_pkg "cn.wps.xiaomi.abroad.lite"        "WPS Office Lite"
call :uninstall_pkg "com.miui.yellowpage"              "Xiaomi Yellow Pages (Caller ID)"
call :uninstall_pkg "com.xiaomi.payment"               "Xiaomi Payment / Mi Pay"
call :uninstall_pkg "com.sohu.inputmethod.sogou.xiaomi" "Sogou Input Method"
call :uninstall_pkg "com.iflytek.inputmethod.miui"      "iFlytek Voice Input"
call :uninstall_pkg "com.baidu.input_mi"                "Baidu Input Method"
call :uninstall_pkg "com.miui.browser"                  "Mi Browser"
call :uninstall_pkg "com.miui.cleanmaster"              "MIUI Clean Master / Phone Cleaner"
call :uninstall_pkg "com.xiaomi.gamecenter"             "Xiaomi Game Center"
call :uninstall_pkg "com.miui.antispam"                 "MIUI Anti-Spam Filter"
call :uninstall_pkg "com.miui.newchannels"              "MIUI News Channels"
call :uninstall_pkg "com.miui.translation"              "MIUI Translation Service"
call :uninstall_pkg "com.mi.android.globaltranslation"  "Xiaomi Global Translation"
call :uninstall_pkg "com.xiaomi.channel"                "Xiaomi Channel (Promotions)"
call :uninstall_pkg "com.mi.globalminusscreen"          "Mi Global Minus Screen"
call :uninstall_pkg "com.mi.appfinder"                  "Mi App Finder"
call :uninstall_pkg "com.miui.backup"                   "MIUI Backup"
call :uninstall_pkg "com.miui.cleaner"                  "MIUI Phone Cleaner"
call :uninstall_pkg "com.miui.phrase"                   "MIUI Auto Phrase / Quick Phrases"
call :uninstall_pkg "com.xiaomi.glgm"                   "Xiaomi GLGM (Analytics)"
call :uninstall_pkg "com.mi.globalbrowser"              "Mi Browser (Global)"
call :uninstall_pkg "com.xiaomi.mi_connect_service"     "Mi Connect Service"
call :uninstall_pkg "com.xiaomi.discover"               "Xiaomi Discover"
call :uninstall_pkg "com.xiaomi.mtb"                    "Xiaomi MTB (Message Top Boards)"
call :uninstall_pkg "com.xiaomi.mirror"                 "Mi Mirror (Screen Cast)"
call :disable_pkg   "com.miui.miservice"               "MIUI Mi Service"
call :disable_pkg   "com.miui.micloudsync"             "MIUI Mi Cloud Sync"

echo   %GREEN%[OK]%NC%    Xiaomi/Redmi system bloat removed.
goto :eof

:: =============================================================================
:debloat_oneplus
echo.
echo %BLUE%  == OnePlus / OxygenOS Bloatware ==%NC%
echo   %DIM%Removes OnePlus-specific apps and services not needed on OxygenOS 13/14.%NC%
echo   %YELLOW%[INFO]%NC%  OPlus-namespaced packages are covered in the ColorOS sections.
call :confirm "Remove OnePlus/OxygenOS bloatware?"
if !CONFIRMED!==0 (echo   %CYAN%[INFO]%NC%  Skipped. & goto :eof)

call :uninstall_pkg "com.oneplus.account"              "OnePlus Account"
call :uninstall_pkg "com.oneplus.appcenter"            "OnePlus App Center"
call :uninstall_pkg "com.oneplus.store"                "OnePlus Store"
call :uninstall_pkg "com.oneplus.community"            "OnePlus Community Forum"
call :uninstall_pkg "net.oneplus.odm"                  "OnePlus ODM Service"
call :uninstall_pkg "com.oneplus.logkit"               "OnePlus Log Kit (Diagnostics)"
call :uninstall_pkg "com.oneplus.brickmode"            "OnePlus Brick Mode"
call :uninstall_pkg "com.oneplus.region"               "OnePlus Region Service"
call :uninstall_pkg "com.oneplus.tips"                 "OnePlus Tips"
call :uninstall_pkg "com.oneplus.clipboard"            "OnePlus Clipboard"
call :uninstall_pkg "com.oneplus.wallet"               "OnePlus Wallet"
call :uninstall_pkg "com.oneplus.health"               "OnePlus Health"
call :uninstall_pkg "com.oneplus.gamespace"            "OnePlus Game Space"
call :uninstall_pkg "net.oneplus.widget"               "OnePlus Widgets"
call :uninstall_pkg "com.oneplus.push"                 "OnePlus Push Service"
call :uninstall_pkg "com.amazon.appstore"              "Amazon App Store (Preload)"
call :uninstall_pkg "com.oneplus.zen"                  "OnePlus Zen Mode"

echo   %GREEN%[OK]%NC%    OnePlus/OxygenOS bloatware removed.
goto :eof

:: =============================================================================
:debloat_android_extras
echo.
echo %BLUE%  == AOSP / Android System Extras ==%NC%
echo   %DIM%Removes or disables rarely-needed AOSP system apps and background services.%NC%
echo   %YELLOW%[INFO]%NC%  Safe on all brands. Does NOT touch core telephony or Settings.
call :confirm "Remove/disable AOSP system extras?"
if !CONFIRMED!==0 (echo   %CYAN%[INFO]%NC%  Skipped. & goto :eof)

call :uninstall_pkg "com.android.devicediagnostics"        "Android Device Diagnostics"
call :uninstall_pkg "com.android.traceur"                  "Android System Tracer (Developer)"
call :uninstall_pkg "com.android.DeviceAsWebcam"           "Device as Webcam"
call :uninstall_pkg "com.android.providers.partnerbookmarks" "Partner Bookmarks Provider"
call :disable_pkg   "com.android.calllogbackup"            "Call Log Backup Service"
call :disable_pkg   "com.android.carrierdefaultapp"        "Carrier Default App"

echo   %GREEN%[OK]%NC%    AOSP system extras debloated.
goto :eof

:: =============================================================================
:debloat_vendor_overlays
echo.
echo %BLUE%  == Vendor Overlays ^& Runtime Resources (RROs) ==%NC%
echo   %DIM%Disables MIUI/Xiaomi and carrier RRO overlay packages.%NC%
echo   %YELLOW%[INFO]%NC%  All entries are DISABLED, not uninstalled, for safe recovery.
echo   %RED%[WARN]%NC%  Disabling SystemUI or Settings overlays may alter UI on some ROMs.
call :confirm "Disable vendor overlay packages?"
if !CONFIRMED!==0 (echo   %CYAN%[INFO]%NC%  Skipped. & goto :eof)

call :disable_pkg   "android.qvaoverlay.common"                      "QVA Common Overlay"
call :disable_pkg   "android.autoinstalls.config.Xiaomi.model"       "Xiaomi Auto-Install Config Overlay"
call :disable_pkg   "com.android.inputsettings.overlay.miui"         "Input Settings MIUI Overlay"
call :disable_pkg   "com.android.managedprovisioning.overlay"        "Managed Provisioning Overlay"
call :disable_pkg   "com.android.phone.auto_generated_characteristics_rro" "Phone Characteristics RRO"
call :disable_pkg   "com.android.role.notes.enabled"                 "Notes Role Overlay"
call :disable_pkg   "com.android.stk.overlay.miui"                   "STK MIUI Overlay"
call :disable_pkg   "com.miui.miwallpaper.overlay"                   "MIUI Wallpaper Overlay"
call :disable_pkg   "com.miui.miwallpaper.overlay.customize"         "MIUI Wallpaper Customize Overlay"
call :disable_pkg   "com.miui.phone.carriers.overlay.h3g"            "MIUI H3G Carrier Overlay"
call :disable_pkg   "com.miui.phone.carriers.overlay.vodafone"       "MIUI Vodafone Carrier Overlay"
call :disable_pkg   "com.miui.settings.rro.device.type.overlay"      "MIUI Settings Device-Type Overlay"
call :disable_pkg   "com.miui.wallpaper.overlay"                     "MIUI Wallpaper Generic Overlay"
call :disable_pkg   "com.miui.wallpaper.overlay.customize"           "MIUI Wallpaper Customize Overlay (Alt)"
call :disable_pkg   "com.mi.globallayout"                            "Mi Global Layout Overlay"
call :disable_pkg   "com.xiaomi.micloud.sdk"                         "Xiaomi Mi Cloud SDK"
call :disable_pkg   "com.coloros.activation.overlay.common"          "ColorOS Activation Common Overlay"

echo   %GREEN%[OK]%NC%    Vendor overlays disabled.
goto :eof

:: =============================================================================
:debloat_qualcomm
echo.
echo %BLUE%  == Qualcomm ^& Hardware Diagnostics ==%NC%
echo   %DIM%Removes OEM factory-test tools and disables Qualcomm background services.%NC%
echo   %YELLOW%[INFO]%NC%  Safe on Snapdragon devices. Not applicable to MediaTek/Exynos.
call :confirm "Remove/disable Qualcomm & diagnostics packages?"
if !CONFIRMED!==0 (echo   %CYAN%[INFO]%NC%  Skipped. & goto :eof)

call :uninstall_pkg "com.qualcomm.qti.devicestatisticsservice" "Qualcomm Device Statistics Service"
call :uninstall_pkg "com.miui.cit"                             "MIUI CIT Factory Test Tool"
call :uninstall_pkg "com.goodix.gftest"                        "Goodix Fingerprint Test Tool"
call :uninstall_pkg "com.fingerprints.sensortesttool"          "Fingerprint Sensor Test Tool"
call :disable_pkg   "com.qualcomm.qti.callfeaturessetting"     "Qualcomm Call Features Setting"
call :disable_pkg   "com.qti.qualcomm.deviceinfo"              "Qualcomm Device Info Service"
call :disable_pkg   "com.qualcomm.qti.xrcb"                    "Qualcomm XR Callback Service"
call :disable_pkg   "com.qualcomm.qti.xrvd.service"            "Qualcomm XR Virtual Display Service"

echo   %GREEN%[OK]%NC%    Qualcomm ^& hardware diagnostics debloated.
goto :eof

:: =============================================================================
:debloat_microsoft
echo.
echo %BLUE%  == Microsoft ^& Third-Party Preloads ==%NC%
echo   %DIM%Removes Microsoft app-management and cross-device integration preloads.%NC%
call :confirm "Remove Microsoft & third-party preloads?"
if !CONFIRMED!==0 (echo   %CYAN%[INFO]%NC%  Skipped. & goto :eof)

call :uninstall_pkg "com.microsoft.appmanager"                  "Microsoft App Manager"
call :uninstall_pkg "com.microsoftsdk.crossdeviceservicebroker" "Microsoft Cross-Device Service Broker"
call :uninstall_pkg "com.microsoft.deviceintegrationservice"    "Microsoft Device Integration Service"

echo   %GREEN%[OK]%NC%    Microsoft ^& third-party preloads removed.
goto :eof

:: =============================================================================
:debloat_all
echo.
echo %BLUE%  == Full Debloat - All Categories ==%NC%
echo   %RED%%BOLD%This will run every debloat category sequentially.%NC%
echo   %YELLOW%Recommended for a fresh setup. Confirm each category individually.%NC%
call :debloat_analytics
call :debloat_coloros
call :debloat_gaming
call :debloat_payments
call :debloat_social
call :debloat_google
call :debloat_miui_analytics
call :debloat_miui_apps
call :debloat_oneplus
call :debloat_android_extras
call :debloat_vendor_overlays
call :debloat_qualcomm
call :debloat_microsoft
goto :eof

:: =============================================================================
:list_packages
echo.
echo %BLUE%  == Installed Packages ==%NC%
set /p "FILTER=  Filter by keyword (leave blank to list all): "
echo.
if defined FILTER (
    adb shell pm list packages 2>nul | findstr /i "!FILTER!"
) else (
    adb shell pm list packages 2>nul
)
echo.
goto :eof

:: =============================================================================
:reinstall_pkg
echo.
echo %BLUE%  == Reinstall Package ==%NC%
set /p "PKG=  Enter package name to reinstall: "
if not defined PKG (echo   %YELLOW%[WARN]%NC%  No package entered. & goto :eof)
echo   %CYAN%[INFO]%NC%  Reinstalling !PKG!...
adb shell cmd package install-existing "!PKG!"
goto :eof

:: =============================================================================
:custom_uninstall
echo.
echo %BLUE%  == Custom Package Removal ==%NC%
set /p "PKG=  Enter package name to uninstall: "
if not defined PKG (echo   %YELLOW%[WARN]%NC%  No package entered. & goto :eof)
call :confirm "Uninstall !PKG!?"
if !CONFIRMED!==0 (echo   %CYAN%[INFO]%NC%  Cancelled. & goto :eof)
call :uninstall_pkg "!PKG!" "!PKG!"
goto :eof

:: =============================================================================
:toggle_dry_run
if !DRY_RUN!==0 (
    set DRY_RUN=1
    echo   %YELLOW%[WARN]%NC%  Dry-run ENABLED. No changes will be made to the device.
) else (
    set DRY_RUN=0
    echo   %GREEN%[OK]%NC%    Dry-run DISABLED. Changes will now be applied to the device.
)
goto :eof

:: =============================================================================
:toggle_logging
if !LOG_ENABLED!==0 (
    set LOG_ENABLED=1
    echo   %GREEN%[OK]%NC%    Logging ENABLED - !LOG_FILE!
    echo Session started %DATE% %TIME% >> "!LOG_FILE!"
) else (
    set LOG_ENABLED=0
    echo   %CYAN%[INFO]%NC%  Logging disabled.
)
goto :eof

:: =============================================================================
:print_summary
echo.
echo %BLUE%  == Session Summary ==%NC%
echo   %BOLD%Packages removed this session :%NC% !REMOVED_COUNT!
echo   %BOLD%Packages disabled this session:%NC% !DISABLED_COUNT!
echo.
if exist "!RESTORE_FILE!" (
    echo   %GREEN%%BOLD%Restore list saved to: !RESTORE_FILE!%NC%
    echo   %DIM%Reinstall : adb shell cmd package install-existing ^<package_id^>%NC%
    echo   %DIM%Re-enable : adb shell pm enable --user 0 ^<package_id^>%NC%
) else (
    echo   %GREEN%%BOLD%To restore any removed package:%NC%
    echo   %DIM%adb shell cmd package install-existing ^<package.name^>%NC%
)
echo.
goto :eof

:: =============================================================================
:main_menu
:menu_loop
if !DRY_RUN!==1 (set "DR_STAT=%YELLOW%ON %NC%") else (set "DR_STAT=%GREEN%OFF%NC%")
if !LOG_ENABLED!==1 (set "LOG_STAT=%GREEN%ON %NC%") else (set "LOG_STAT=%DIM%OFF%NC%")
echo.
echo %BLUE%%BOLD%  +=====================================================+
echo   ^|                    MAIN MENU                       ^|
echo   +-----------------------------------------------------+
echo   ^|  [1]   List installed packages                     ^|
echo   ^|  [2]   Debloat: Analytics ^& Telemetry (ColorOS)   ^|
echo   ^|  [3]   Debloat: ColorOS / OPPO bloatware           ^|
echo   ^|  [4]   Debloat: Game Space ^& Gaming services      ^|
echo   ^|  [5]   Debloat: Payment ^& Financial apps          ^|
echo   ^|  [6]   Debloat: Facebook ^& Social preloads        ^|
echo   ^|  [7]   Debloat: Google bloatware                  ^|
echo   ^|  [8]   Debloat: ALL categories (full clean)       ^|
echo   ^|  [9]   Custom uninstall                           ^|
echo   ^|  [10]  Debloat: Xiaomi/Redmi Analytics ^& Ads     ^|
echo   ^|  [11]  Debloat: Xiaomi/Redmi System Apps         ^|
echo   ^|  [12]  Debloat: OnePlus / OxygenOS bloatware     ^|
echo   ^|  [13]  Debloat: AOSP / Android System Extras     ^|
echo   ^|  [14]  Debloat: Vendor Overlays ^& RROs           ^|
echo   ^|  [15]  Debloat: Qualcomm ^& HW Diagnostics        ^|
echo   ^|  [16]  Debloat: Microsoft ^& 3rd-Party Preloads   ^|
echo   ^|  [r]   Reinstall / restore a package              ^|%NC%
echo   ^|  [d]  Dry-run   : !DR_STAT!                              ^|
echo   ^|  [l]  Logging   : !LOG_STAT!                             ^|
echo %BLUE%%BOLD%  ^|  [s]  Show session summary                         ^|
echo   ^|  [0]  Exit                                         ^|
echo   +=====================================================+%NC%
echo.

set /p "OPTION=  Enter option: "

if "!OPTION!"=="1"  (call :list_packages             & goto menu_loop)
if "!OPTION!"=="2"  (call :debloat_analytics         & goto menu_loop)
if "!OPTION!"=="3"  (call :debloat_coloros           & goto menu_loop)
if "!OPTION!"=="4"  (call :debloat_gaming            & goto menu_loop)
if "!OPTION!"=="5"  (call :debloat_payments          & goto menu_loop)
if "!OPTION!"=="6"  (call :debloat_social            & goto menu_loop)
if "!OPTION!"=="7"  (call :debloat_google            & goto menu_loop)
if "!OPTION!"=="8"  (call :debloat_all               & goto menu_loop)
if "!OPTION!"=="9"  (call :custom_uninstall          & goto menu_loop)
if "!OPTION!"=="10" (call :debloat_miui_analytics    & goto menu_loop)
if "!OPTION!"=="11" (call :debloat_miui_apps         & goto menu_loop)
if "!OPTION!"=="12" (call :debloat_oneplus           & goto menu_loop)
if "!OPTION!"=="13" (call :debloat_android_extras    & goto menu_loop)
if "!OPTION!"=="14" (call :debloat_vendor_overlays   & goto menu_loop)
if "!OPTION!"=="15" (call :debloat_qualcomm          & goto menu_loop)
if "!OPTION!"=="16" (call :debloat_microsoft         & goto menu_loop)
if /i "!OPTION!"=="r" (call :reinstall_pkg           & goto menu_loop)
if /i "!OPTION!"=="d" (call :toggle_dry_run          & goto menu_loop)
if /i "!OPTION!"=="l" (call :toggle_logging          & goto menu_loop)
if /i "!OPTION!"=="s" (call :print_summary           & goto menu_loop)
if "!OPTION!"=="0" (
    call :print_summary
    echo   %CYAN%[INFO]%NC%  Exiting. Enjoy your optimised device!
    exit /b 0
)

echo   %YELLOW%[WARN]%NC%  Invalid option. Please try again.
goto menu_loop
