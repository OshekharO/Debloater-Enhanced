@echo off

:: Version 1.0
:: Author: [Saksham Shekher]

echo.
echo "================================================================="
echo "                 Debloating Realme device (Version 1.0)          "
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

rem Get the device name
for /f "tokens=*" %%a in ('adb shell getprop ro.product.model') do set device_name=%%a

echo "Device name: %device_name%"
echo.

:menu
echo 1. Debloat Realme apps                                         
echo 2. Debloat Google apps                                         
echo 3. Re-bloat Realme
echo 4. List installed applications
echo 0. Exit                                                        
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
    echo Uninstalling Google Search...
    adb shell pm uninstall --user 0 com.google.android.googlequicksearchbox

    echo Uninstalling Google Duo...
    adb shell pm uninstall --user 0 com.google.android.apps.tachyon

    echo Uninstalling Google Play Music...
    adb shell pm uninstall --user 0 com.google.android.music

    echo Uninstalling Google Play Movies...
    adb shell pm uninstall --user 0 com.google.android.videos

    echo Uninstalling YouTube...
    adb shell pm uninstall --user 0 com.google.android.youtube

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
