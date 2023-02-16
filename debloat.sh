#!/bin/bash

# Version 1.0
# Author: [Saksham Shekher]

echo ""
echo "================================================================="
echo "                 Debloating Realme device (Version 1.0)          "
echo "================================================================="
echo "Author: [Saksham Shekher]                                        "
echo "Warning: Debloat at your own risk!                               "
echo ""

debloat_realme_apps() {
    echo ""
    echo "Uninstalling Assistant Screen..."
    adb shell pm uninstall --user 0 com.coloros.assistantscreen

    echo "Uninstalling OCR Scanner..."
    adb shell pm uninstall --user 0 com.coloros.ocrscanner

    echo "Uninstalling Smart Drive..."
    adb shell pm uninstall --user 0 com.coloros.smartdrive

    echo "Uninstalling Sound Recorder..."
    adb shell pm uninstall --user 0 com.coloros.soundrecorder

    echo "Uninstalling Video Player..."
    adb shell pm uninstall --user 0 com.coloros.video

    echo ""
    echo "================================================================="
    echo "                  Realme apps debloated.                         "
    echo "================================================================="
    echo ""
}

debloat_google_apps() {
    echo ""
    echo "Uninstalling Google Search..."
    adb shell pm uninstall --user 0 com.google.android.googlequicksearchbox

    echo "Uninstalling Google Duo..."
    adb shell pm uninstall --user 0 com.google.android.apps.tachyon

    echo "Uninstalling Google Play Music..."
    adb shell pm uninstall --user 0 com.google.android.music

    echo "Uninstalling Google Play Movies..."
    adb shell pm uninstall --user 0 com.google.android.videos

    echo "Uninstalling YouTube..."
    adb shell pm uninstall --user 0 com.google.android.youtube

    echo ""
    echo "================================================================="
    echo "                  Google apps debloated.                         "
    echo "================================================================="
    echo ""
}

rebloat_realme_apps() {
    echo ""
    echo "Re-bloating Realme apps..."
    adb shell cmd package install-existing

    echo ""
    echo "================================================================="
    echo "                    Realme apps rebloated.                       "
    echo "================================================================="
    echo ""
}

list_installed_apps() {
    echo ""
    echo "Listing installed applications..."
    adb shell pm list packages -f

    echo ""
    echo "================================================================="
    echo "                 Installed applications listed.                  "
    echo "================================================================="
    echo ""
}

option=""
while [ $option != "0" ]
do
    echo "1. Debloat Realme apps"
    echo "2. Debloat Google apps"
    echo "3. Re-bloat Realme"
    echo "4. List installed applications"
    echo "0. Exit"
    echo ""

    read -p "Enter an option: " option

    case $option in
        "1") debloat_realme_apps;;
        "2") debloat_google_apps;;
        "3") rebloat_realme_apps;;
        "4") list_installed_apps;;
        "0") echo ""; echo "Exiting..."; echo ""; break;;
        *) echo "Invalid option. Please try again.";;
    esac
done
