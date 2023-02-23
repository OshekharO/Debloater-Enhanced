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
    echo Uninstalling Assistant Screen...
    adb shell pm uninstall --user 0 com.coloros.assistantscreen

    echo Uninstalling OCR Scanner...
    adb shell pm uninstall --user 0 com.coloros.ocrscanner

    echo Uninstalling Smart Drive...
    adb shell pm uninstall --user 0 com.coloros.smartdrive

    echo Uninstalling Sound Recorder...
    adb shell pm uninstall --user 0 com.coloros.soundrecorder

    echo Uninstalling Video Player...
    adb shell pm uninstall --user 0 com.coloros.video

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

    echo Uninstalling Google Play Music...
    adb shell pm uninstall --user 0 com.google.android.music

    echo Uninstalling Google Play Movies...
    adb shell pm uninstall --user 0 com.google.android.videos

    echo Uninstalling Google Play Books...
    adb shell pm uninstall --user 0 com.google.android.apps.books

    echo Uninstalling YouTube...
    adb shell pm uninstall --user 0 com.google.android.youtube

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
