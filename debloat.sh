#!/bin/bash

# Version 1.3
# Author: [Saksham Shekher]

# Function to check if the device is connected
check_device_connected() {
    adb devices | grep -w "device" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Please connect your device via USB."
        exit 1
    fi
}

# Function to get device details
get_device_details() {
    DEVICE_MODEL=$(adb shell getprop ro.product.model)
    DEVICE_BRAND=$(adb shell getprop ro.product.brand)
    ANDROID_VERSION=$(adb shell getprop ro.build.version.release)

    echo
    echo "Model:       $DEVICE_MODEL"
    echo "Brand:       $DEVICE_BRAND"
    echo "Android:     $ANDROID_VERSION"
    echo
}

# Function to list installed applications
list_installed_apps() {
    echo
    echo "Listing installed applications..."
    adb shell pm list packages -f

    echo
    echo "================================================================="
    echo "                 Installed Applications Listed.                 "
    echo "================================================================="
    echo
}

# Function to debloat Realme apps
debloat_realme_apps() {
    echo
    echo "Uninstalling Realme apps..."
    adb shell pm uninstall --user 0 com.opos.cs
    adb shell pm uninstall --user 0 com.realmecomm.app
    adb shell pm uninstall --user 0 com.heytap.music
    adb shell pm uninstall --user 0 com.heytap.pictorial
    adb shell pm uninstall --user 0 com.oppo.quicksearchbox
    adb shell pm uninstall --user 0 com.coloros.video
    adb shell pm uninstall --user 0 com.heytap.browser
    adb shell pm uninstall --user 0 com.tencent.soter.soterserver
    adb shell pm uninstall --user 0 com.oplus.multiapp
    adb shell pm uninstall --user 0 com.oppo.sos
    adb shell pm uninstall --user 0 com.coloros.compass2
    adb shell pm uninstall --user 0 com.coloros.oshare
    adb shell pm uninstall --user 0 com.heytap.quickgame
    adb shell pm uninstall --user 0 com.heytap.accessory
    adb shell pm uninstall --user 0 com.realme.wellbeing
    adb shell pm uninstall --user 0 com.oppo.opperationManual
    adb shell pm uninstall --user 0 com.coloros.oppomultiapp
    adb shell pm uninstall --user 0 com.coloros.backuprestore
    adb shell pm uninstall --user 0 com.coloros.gamespaceui
    adb shell pm uninstall --user 0 com.coloros.gamespace
    adb shell pm uninstall --user 0 com.os.docvault
    adb shell pm uninstall --user 0 com.finshell.fin
    adb shell pm uninstall --user 0 com.heytap.usercenter
    adb shell pm uninstall --user 0 com.redteamobile.roaming
    adb shell pm uninstall --user 0 com.oplus.pay
    adb shell pm uninstall --user 0 com.nearme.atlas
    adb shell pm uninstall --user 0 com.heytap.cloud
    adb shell pm uninstall --user 0 com.heytap.habit.analysis
    adb shell pm uninstall --user 0 com.coloros.activation
    adb shell pm uninstall --user 0 com.coloros.smartdrive
    adb shell pm uninstall --user 0 com.oplus.cosa
    adb shell pm uninstall --user 0 com.oplus.lfeh
    adb shell pm uninstall --user 0 com.oplus.stdid
    adb shell pm uninstall --user 0 com.oplus.synergy
    adb shell pm uninstall --user 0 com.realme.securitycheck
    adb shell pm uninstall --user 0 com.coloros.securepay
    adb shell pm uninstall --user 0 com.realmepay.payments
    adb shell pm uninstall --user 0 com.oplus.logkit
    adb shell pm uninstall --user 0 com.oplus.crashbox
    adb shell pm uninstall --user 0 com.oppoex.afterservice
    adb shell pm uninstall --user 0 com.realme.movieshot
    adb shell pm uninstall --user 0 com.oplus.games
    adb shell pm uninstall --user 0 com.coloros.ocrscanner
    adb shell pm uninstall --user 0 com.oplus.linker
    adb shell pm uninstall --user 0 com.oplus.encryption
    adb shell pm uninstall --user 0 com.facebook.services
    adb shell pm uninstall --user 0 com.facebook.appmanager
    adb shell pm uninstall --user 0 com.facebook.system
    adb shell pm uninstall --user 0 com.facebook.katana
    adb shell pm uninstall --user 0 com.nearme.statistics.rom
    adb shell pm disable-user --user 0 com.heytap.themestore
    adb shell pm disable-user --user 0 com.android.fmradio
    adb shell pm disable-user --user 0 com.coloros.phonemanager
    adb shell pm disable-user --user 0 com.glance.internet

    echo
    echo "================================================================="
    echo "                  Realme Apps Debloated.                         "
    echo "================================================================="
    echo
}

# Function to debloat Google apps
debloat_google_apps() {
    echo
    echo "Uninstalling Google apps..."
    adb shell pm uninstall --user 0 com.google.android.apps.tachyon
    adb shell pm uninstall --user 0 com.google.android.apps.nbu.paisa.user
    adb shell pm uninstall --user 0 com.google.android.apps.subscriptions.red
    adb shell pm uninstall --user 0 com.google.android.marvin.talkback
    adb shell pm uninstall --user 0 com.google.android.keep
    adb shell pm uninstall --user 0 com.google.android.music
    adb shell pm uninstall --user 0 com.google.android.videos
    adb shell pm uninstall --user 0 com.google.android.apps.books
    adb shell pm uninstall --user 0 com.android.hotwordenrollment.okgoogle
    adb shell pm uninstall --user 0 com.google.android.apps.googleassistant
    adb shell pm uninstall --user 0 com.google.android.youtube
    adb shell pm uninstall --user 0 com.google.android.apps.wellbeing
    adb shell pm uninstall --user 0 com.google.android.apps.podcasts
    adb shell pm uninstall --user 0 com.google.android.apps.youtube.music
    adb shell pm uninstall --user 0 com.google.android.apps.nbu.files
    adb shell pm uninstall --user 0 com.google.ar.core
    adb shell pm uninstall --user 0 com.google.android.printservice.recommendation
    adb shell pm uninstall --user 0 com.google.ar.lens
    adb shell pm uninstall --user 0 com.google.android.apps.docs
    adb shell pm uninstall --user 0 com.google.android.apps.photos
    adb shell pm uninstall --user 0 com.google.android.feedback
    adb shell pm uninstall --user 0 com.google.android.projection.gearhead
    adb shell pm disable-user --user 0 com.android.stk
    adb shell pm disable-user --user 0 com.android.nfc

    echo
    echo "================================================================="
    echo "                  Google Apps Debloated.                         "
    echo "================================================================="
    echo
}

# Function to debloat Xiaomi apps
debloat_xiaomi_apps() {
    echo
    echo "Uninstalling Xiaomi apps..."
    adb shell pm uninstall --user 0 com.android.browser
    adb shell pm uninstall --user 0 com.xiaomi.shop
    adb shell pm uninstall --user 0 com.facebook.services
    adb shell pm uninstall --user 0 com.facebook.appmanager
    adb shell pm uninstall --user 0 com.facebook.system
    adb shell pm uninstall --user 0 com.facebook.katana
    adb shell pm uninstall --user 0 in.amazon.mShop.android.shopping
    adb shell pm uninstall --user 0 com.amazon.appmanager
    adb shell pm uninstall --user 0 com.linkedin.android
    adb shell pm uninstall --user 0 cn.wps.xiaomi.abroad.lite
    adb shell pm uninstall --user 0 com.netflix.mediaclient
    adb shell pm uninstall --user 0 com.miui.analytics
    adb shell pm uninstall --user 0 com.miui.bugreport
    adb shell pm uninstall --user 0 com.miui.videoplayer
    adb shell pm uninstall --user 0 com.miui.player
    adb shell pm uninstall --user 0 com.miui.notes
    adb shell pm uninstall --user 0 com.miui.yellowpage
    adb shell pm uninstall --user 0 com.miui.msa.global
    adb shell pm uninstall --user 0 com.miui.systemAdSolution
    adb shell pm uninstall --user 0 com.xiaomi.glgm
    adb shell pm uninstall --user 0 com.miui.daemon
    adb shell pm uninstall --user 0 com.miui.audiomonitor
    adb shell pm uninstall --user 0 com.miui.carlink
    adb shell pm uninstall --user 0 com.miui.translation.kingsoft
    adb shell pm uninstall --user 0 com.miui.translation.xmcloud
    adb shell pm uninstall --user 0 com.miui.translationservice
    adb shell pm uninstall --user 0 com.miui.cloudbackup
    adb shell pm uninstall --user 0 com.miui.cloudservice
    adb shell pm uninstall --user 0 com.miui.cloudservice.sysbase
    adb shell pm uninstall --user 0 com.miui.micloudsync
    adb shell pm uninstall --user 0 com.mipay.wallet.in
    adb shell pm uninstall --user 0 com.xiaomi.payment
    adb shell pm uninstall --user 0 com.miui.nextpay
    adb shell pm uninstall --user 0 com.unionpay.tsmservice.mi
    adb shell pm uninstall --user 0 org.mipay.android.manager
    adb shell pm uninstall --user 0 com.tencent.soter.soterserver

    echo
    echo "================================================================="
    echo "                    Miui Apps Debloated.                         "
    echo "================================================================="
    echo
}

# Function to perform custom uninstall
custom_uninstall() {
    echo
    read -p "Enter package name to uninstall: " package
    echo "Uninstalling $package..."
    adb shell pm uninstall --user 0 $package

    echo
    echo "================================================================="
    echo "                 Custom Uninstall Completed.                     "
    echo "================================================================="
    echo
}

# Main menu
main_menu() {
    echo
    echo "================================================================="
    echo "                 Debloater Enhanced (Version 1.3)                "
    echo "================================================================="
    echo "Author: [Saksham Shekher]                                        "
    echo "Warning: Debloat at your own risk!                               "
    echo

    get_device_details

    while true; do
        echo "1  = List installed applications"
        echo "2  = Debloat Realme Apps"
        echo "3  = Debloat Google Apps"
        echo "4  = Debloat Xiaomi Apps"
        echo "5  = Custom uninstall"
        echo "0  = Exit"
        echo

        read -p "Enter an option: " option

        case $option in
            1) list_installed_apps;;
            2) debloat_realme_apps;;
            3) debloat_google_apps;;
            4) debloat_xiaomi_apps;;
            5) custom_uninstall;;
            0) echo "Exiting..."; exit 0;;
            *) echo "Invalid option.";;
        esac
    done
}

# Check if device is connected and start the main menu
check_device_connected
main_menu
