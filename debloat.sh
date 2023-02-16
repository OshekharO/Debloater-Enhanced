#!/bin/bash

# Version 1.1
# Author: [Saksham Shekher]

# Check if device is connected
adb devices >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Please connect your device via USB."
    exit 1
fi

echo ""
echo "================================================================="
echo "                 Debloating Realme device (Version 1.1)          "
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
    echo "Uninstalling Google Duo..."
    adb shell pm uninstall --user 0 com.google.android.apps.tachyon

    echo "Uninstalling Google Play Music..."
    adb shell pm uninstall --user 0 com.google.android.music

    echo "Uninstalling Google Play Movies..."
    adb shell pm uninstall --user 0 com.google.android.videos

    echo "Uninstalling Google Play Books..."
    adb shell pm uninstall --user 0 com.google.android.apps.books

    echo "Uninstalling YouTube..."
    adb shell pm uninstall --user 0 com.google.android.youtube

    echo "Uninstalling Podcast..."
    adb shell pm uninstall --user 0 com.google.android.apps.podcasts

    echo "Uninstalling Youtube Music..."
    adb shell pm uninstall --user 0 com.google.android.apps.youtube.music

    echo "Uninstalling Files By Google..."
    adb shell pm uninstall --user 0 com.google.android.apps.nbu.files

    echo "Uninstalling AR Core..."
    adb shell pm uninstall --user 0 com.google.ar.core

    echo "Uninstalling Print Service Component..."
    adb shell pm uninstall --user 0 com.google.android.printservice.recommendation

    echo "Uninstalling Google Lens..."
    adb shell pm uninstall --user 0 com.google.ar.lens

    echo "Uninstalling Google Drive..."
    adb shell pm uninstall --user 0 com.google.android.apps.docs

    echo "Uninstalling Google Photos..."
    adb shell pm uninstall --user 0 com.google.android.apps.photos

    echo "Uninstalling Google Feedback..."
    adb shell pm uninstall --user 0 com.google.android.feedback

    echo "Uninstalling Android Auto..."
    adb shell pm uninstall --user 0 com.google.android.projection.gearhead

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
echo ╔═════════════════════════════════════════════════════════════╗  
echo ║                                                                        ║
echo ║              __    __     ______     __   __     __  __                ║
echo ║             /\ "-./  \   /\  ___\   /\ "-.\ \   /\ \/\ \               ║
echo ║             \ \ \-./\ \  \ \  __\   \ \ \-.  \  \ \ \_\ \              ║
echo ║              \ \_\ \ \_\  \ \_____\  \ \_\\"\_\  \ \_____\             ║
echo ║               \/_/  \/_/   \/_____/   \/_/ \/_/   \/_____/             ║
echo ║                                                                        ║
echo ║                                                                        ║
echo ║═════════════════════════════════════════════════════════════║
echo ║    1   =   Debloat Realme Apps                                         ║
echo ║————————————————————————————————————————————————————————————————————————║
echo ║    2   =   Debloat Google Apps                                         ║
echo ║————————————————————————————————————————————————————————————————————————║
echo ║    3   =   Re-bloat Realme                                             ║
echo ║————————————————————————————————————————————————————————————————————————║
echo ║    4   =   List installed applications.                                ║
echo ║————————————————————————————————————————————————————————————————————————║
echo ║    0   =   Exit.                                                       ║                                                        ║
echo ╚═════════════════════════════════════════════════════════════╝                                                         
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
