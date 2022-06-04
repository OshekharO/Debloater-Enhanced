@echo OFF
set s=---------------------------------------------------------------------------
set m1= Script Made By OshekharO
set m2= Go turn on usb debugging if you haven't did till now and connect your device to pc.
set m3= you wont face any issues 99.99% of times, but still take backup of really important files
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

echo Installing WPS Office
adb shell cmd package install-existing cn.wps.moffice_eng

echo Installing Podcast
adb shell cmd package install-existing com.google.android.apps.podcasts

echo Installing Realme Link
adb shell cmd package install-existing com.realme.link

echo Installing YouTube Music
adb shell cmd package install-existing com.google.android.apps.youtube.music

echo Installing Google Duo
adb shell cmd package install-existing com.google.android.apps.tachyon

echo Installing Ok Google Enroll
adb shell cmd package install-existing com.android.hotwordenrollment.okgoogle

echo Installing Files By Google
adb shell cmd package install-existing com.google.android.apps.nbu.files

echo Installing Print Service Component
adb shell cmd package install-existing com.google.android.printservice.recommendation

echo Installing AR Core
adb shell cmd package install-existing com.google.ar.core

echo Installing Sound Amplifier
adb shell cmd package install-existing com.google.android.accessibility.soundamplifier

echo Installing Google Assistant
adb shell cmd package install-existing com.google.android.apps.googleassistant

echo Installing Google Lens
adb shell cmd package install-existing com.google.ar.lens

echo Installing Google Drive
adb shell cmd package install-existing com.google.android.apps.docs 

echo Installing Keep Notes
adb shell cmd package install-existing com.google.android.keep

echo Installing Google Photos
adb shell cmd package install-existing com.google.android.apps.photos

echo Installing Android Auto
adb shell cmd package install-existing com.google.android.projection.gearhead

echo Installing Feedback
adb shell cmd package install-existing com.google.android.feedback

echo Installing Kid Space
adb shell cmd package install-existing com.coloros.childrenspace

echo Installing Compass
adb shell cmd package install-existing com.coloros.compass2

echo Installing 
adb shell cmd package install-existing com.coloros.logkit 

echo Installing 
adb shell cmd package install-existing com.coloros.systemclone 

echo Installing 
adb shell cmd package install-existing com.realmepay.payments 

echo Installing Payment Protection
adb shell cmd package install-existing com.coloros.securepay 

echo Installing Hot Apps
adb shell cmd package install-existing com.opos.cs

echo Installing Facebook Katana
adb shell cmd package install-existing com.facebook.katana

echo Installing Facebook System
adb shell cmd package install-existing com.facebook.system

echo Installing Facebook Appmanager
adb shell cmd package install-existing com.facebook.appmanager

echo Installing Facebook Services
adb shell cmd package install-existing com.facebook.services

echo Installing Security Analysis
adb shell cmd package install-existing com.realme.securitycheck

echo Installing Phone Manager
adb shell cmd package install-existing com.coloros.phonemanager

echo Installing 
adb shell cmd package install-existing com.coloros.oppomultiapp 

:: echo Installing GameSpace
:: adb shell cmd package install-existing com.coloros.gamespace

echo Installing Realme Music
adb shell cmd package install-existing com.heytap.music

echo Enabling Theme Store
adb shell pm enable com.heytap.themestore

echo Installing lockscreen magazine
adb shell cmd package install-existing com.heytap.pictorial

echo Installing Intelligent Analytics System
adb shell cmd package install-existing com.heytap.habit.analysis

echo Installing Clone Phone
adb shell cmd package install-existing com.coloros.backuprestore

echo Installing 
adb shell cmd package install-existing com.google.android.apps.magazines

echo Installing 
adb shell cmd package install-existing com.google.android.apps.subscriptions.red

echo Installing Realme Share
adb shell cmd package install-existing com.coloros.oshare

echo Installing HomeScreen Search
adb shell cmd package install-existing com.oppo.quicksearchbox

:: echo Installing Game Space
:: adb shell cmd package install-existing com.coloros.gamespaceui

echo Installing YouTube
adb shell cmd package install-existing com.google.android.youtube

echo Installing 
adb shell cmd package install-existing com.coloros.assistantscreen

echo Installing Google Pay
adb shell cmd package install-existing com.google.android.apps.nbu.paisa.user

echo Installing 
adb shell cmd package install-existing com.coloros.videoeditor

echo Installing Realme Video
adb shell cmd package install-existing com.coloros.video

echo Installing Realme Browser
adb shell cmd package install-existing com.heytap.browser

echo Installing Doc Vault
adb shell cmd package install-existing com.os.docvault

echo Installing Finshell
adb shell cmd package install-existing com.finshell.fin

echo Installing 
adb shell cmd package install-existing com.coloros.onekeylockscreen 

echo Installing 
adb shell cmd package install-existing com.realmecomm.app 

echo Installing 
adb shell cmd package install-existing com.heytap.quickgame 

echo Installing Realme Cloud
adb shell cmd package install-existing com.heytap.cloud

echo Installing My Realme
adb shell cmd package install-existing com.heytap.usercenter

echo Installing Games
adb shell cmd package install-existing com.oplus.games

echo Installing Realme Store
adb shell cmd package install-existing com.realmestore.app

echo Installing Sound Recorder
adb shell cmd package install-existing com.coloros.soundrecorder

echo Installing gamecentre
adb shell cmd package install-existing com.nearme.gamecenter

echo Installing 
adb shell cmd package install-existing com.google.android.videos 

echo Installing Oroaming
adb shell cmd package install-existing com.redteamobile.roaming

echo Enabling FM Radio
adb shell pm enable com.android.fmradio

echo Enabling 
adb shell pm enable com.nearme.statistics.rom

echo Enabling Glance For Realme
adb shell pm enable com.glance.internet

echo %s%
echo your device has been rebloated
echo %s%
echo %m1%
echo %s%
echo if you like this work, dont forget to follow OshekharO at GitHub 
echo %s%
pause
