@echo OFF
set s=---------------------------------------------------------------------------
set m1= Script Edited By OshekharO
set m2= Go turn on usb debugging if you haven't did till now and connect your device to pc.
set m3= you wont face any issues 99.69% of times, but still take backup of really important files
echo %m1%
echo %m3%
echo %s%
echo %m2%
echo %s%
pause

echo ----------- Waiting For Connected ADB Devices -----------
adb wait-for-any-device

echo ----------- Finding Connected ADB Devices -----------
adb reconnect

echo ----------- Waiting For Connected ADB Devices -----------
adb wait-for-any-device

echo Uninstalling WPS Office
adb shell pm uninstall cn.wps.moffice_eng

echo Uninstalling Podcast
adb shell pm uninstall com.google.android.apps.podcasts

echo Uninstalling Realme Link
adb shell pm uninstall com.realme.link

echo Uninstalling YouTube Music
adb shell pm uninstall com.google.android.apps.youtube.music

echo Uninstalling Google Duo
adb shell pm uninstall com.google.android.apps.tachyon

echo Uninstalling Ok Google Enroll
adb shell pm uninstall -k --user 0 com.android.hotwordenrollment.okgoogle

echo Uninstalling Files By Google
adb shell pm uninstall -k --user 0 com.google.android.apps.nbu.files

echo Uninstalling Print Service Component
adb shell pm uninstall -k --user 0 com.google.android.printservice.recommendation

echo Uninstalling AR Core
adb shell pm uninstall -k --user 0 com.google.ar.core

echo Uninstalling Sound Amplifier
adb shell pm uninstall -k --user 0 com.google.android.accessibility.soundamplifier

echo Uninstalling Google Assistant
adb shell pm uninstall -k --user 0 com.google.android.apps.googleassistant

echo Uninstalling Google Lens
adb shell pm uninstall -k --user 0 com.google.ar.lens

echo Uninstalling Google Drive
adb shell pm uninstall -k --user 0 com.google.android.apps.docs 

echo Uninstalling Keep Notes
adb shell pm uninstall -k --user 0 com.google.android.keep

echo Uninstalling Google Photos
adb shell pm uninstall -k --user 0 com.google.android.apps.photos

echo Uninstalling Android Auto
adb shell pm uninstall -k --user 0 com.google.android.projection.gearhead

echo Uninstalling Feedback
adb shell pm uninstall -k --user 0 com.google.android.feedback

echo Uninstalling Kid Space
adb shell pm uninstall -k --user 0 com.coloros.childrenspace

echo Uninstalling Compass
adb shell pm uninstall -k --user 0 com.coloros.compass2

echo Uninstalling 
adb shell pm uninstall -k --user 0 com.coloros.logkit 

echo Uninstalling 
adb shell pm uninstall -k --user 0 com.coloros.systemclone 

echo Uninstalling 
adb shell pm uninstall -k --user 0 com.realmepay.payments 

echo Uninstalling Payment Protection
adb shell pm uninstall -k --user 0 com.coloros.securepay 

echo Uninstalling Hot Apps
adb shell pm uninstall -k --user 0 com.opos.cs

echo Uninstalling Facebook Katana
adb shell pm uninstall -k --user 0 com.facebook.katana

echo Uninstalling Facebook System
adb shell pm uninstall -k --user 0 com.facebook.system

echo Uninstalling Facebook Appmanager
adb shell pm uninstall -k --user 0 com.facebook.appmanager

echo Uninstalling Facebook Services
adb shell pm uninstall -k --user 0 com.facebook.services

echo Uninstalling Security Analysis
adb shell pm uninstall -k --user 0 com.realme.securitycheck

echo Uninstalling Phone Manager
adb shell pm uninstall -k --user 0 com.coloros.phonemanager

echo Uninstalling 
adb shell pm uninstall -k --user 0 com.coloros.oppomultiapp 

echo Uninstalling GameSpace
:: adb shell pm uninstall -k --user 0 com.coloros.gamespace

echo Uninstalling Realme Music
adb shell pm uninstall -k --user 0 com.heytap.music

echo Disabling Theme Store
adb shell pm disable-user --user 0 com.heytap.themestore

echo Uninstalling lockscreen magazine
adb shell pm uninstall -k --user 0 com.heytap.pictorial

echo Uninstalling Intelligent Analytics System
adb shell pm uninstall -k --user 0 com.heytap.habit.analysis

echo Uninstalling Clone Phone
adb shell pm uninstall -k --user 0 com.coloros.backuprestore

echo Uninstalling 
adb shell pm uninstall -k --user 0 com.google.android.apps.magazines

echo Uninstalling 
adb shell pm uninstall -k --user 0 com.google.android.apps.subscriptions.red

echo Uninstalling Realme Share
adb shell pm uninstall -k --user 0 com.coloros.oshare

echo Uninstalling HomeScreen Search
adb shell pm uninstall -k --user 0 com.oppo.quicksearchbox

echo Uninstalling Game Space
:: adb shell pm uninstall -k --user 0 com.coloros.gamespaceui

echo Uninstalling YouTube
adb shell pm uninstall -k --user 0 com.google.android.youtube

echo Uninstalling 
adb shell pm uninstall -k --user 0 com.coloros.assistantscreen

echo Uninstalling Google Pay
adb shell pm uninstall -k --user 0 com.google.android.apps.nbu.paisa.user

echo Uninstalling 
adb shell pm uninstall -k --user 0 com.coloros.videoeditor

echo Uninstalling Realme Video
adb shell pm uninstall -k --user 0 com.coloros.video

echo Uninstalling Realme Browser
adb shell pm uninstall -k --user 0 com.heytap.browser

echo Uninstalling Doc Vault
adb shell pm uninstall -k --user 0 com.os.docvault

echo Uninstalling Finshell
adb shell pm uninstall -k --user 0 com.finshell.fin

echo Uninstalling 
adb shell pm uninstall com.coloros.onekeylockscreen 

echo Uninstalling 
adb shell pm uninstall com.realmecomm.app 

echo Uninstalling 
adb shell pm uninstall com.heytap.quickgame 

echo Uninstalling Realme Cloud
adb shell pm uninstall -k --user 0 com.heytap.cloud

echo Uninstalling My Realme
adb shell pm uninstall -k --user 0 com.heytap.usercenter

echo Uninstalling Games
adb shell pm uninstall -k --user 0 com.oplus.games

echo Uninstalling Realme Store
adb shell pm uninstall com.realmestore.app

echo Uninstalling Sound Recorder
adb shell pm uninstall -k --user 0 com.coloros.soundrecorder

echo Uninstalling gamecentre
adb shell pm uninstall -k --user 0 com.nearme.gamecenter

echo Uninstalling 
adb shell pm uninstall com.google.android.videos 

echo Uninstalling Oroaming
adb shell pm uninstall -k --user 0 com.redteamobile.roaming

echo Disabling FM Radio
adb shell pm disable-user --user 0 com.android.fmradio

echo Disabling 
adb shell pm disable-user --user 0 com.nearme.statistics.rom

echo Disabling Glance For Realme
adb shell pm disable-user  --user 0 com.glance.internet

echo %s%
echo your device has been debloated
echo %s%
echo %m1%
echo %s%
echo if you like this work, dont forget to follow OshekharO at GitHub 
echo %s%
pause
