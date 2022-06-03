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
adb wait-for-any-device
adb reconnect
adb wait-for-any-device
adb shell pm uninstall cn.wps.moffice_eng rem WPS Office
adb shell pm uninstall com.google.android.apps.podcasts rem Podcast
adb shell pm uninstall com.realme.link rem Realme Link
adb shell pm uninstall com.google.android.apps.youtube.music rem YouTube Music
adb shell pm uninstall com.google.android.apps.tachyon rem
adb shell pm uninstall -k --user 0 com.android.hotwordenrollment.okgoogle rem Google Assistant Enroll
adb shell pm uninstall -k --user 0 com.google.android.apps.nbu.files rem Files By Google
adb shell pm uninstall -k --user 0 com.google.android.printservice.recommendation rem
adb shell pm uninstall -k --user 0 com.google.ar.core rem AR Core
adb shell pm uninstall -k --user 0 com.google.android.apps.googleassistant rem Assistant
adb shell pm uninstall -k --user 0 com.google.ar.lens rem Lens
adb shell pm uninstall -k --user 0 com.google.android.apps.docs 
adb shell pm uninstall -k --user 0 com.google.android.keep rem Keep Notes
adb shell pm uninstall -k --user 0 com.google.android.apps.photos rem Photos
adb shell pm uninstall -k --user 0 com.google.android.projection.gearhead
adb shell pm uninstall -k --user 0 com.google.android.feedback rem Feedback
adb shell pm uninstall -k --user 0 com.coloros.childrenspace
adb shell pm uninstall -k --user 0 com.coloros.compass2 rem Compass
adb shell pm uninstall -k --user 0 com.coloros.logkit 
adb shell pm uninstall -k --user 0 com.coloros.systemclone
adb shell pm uninstall -k --user 0 com.realmepay.payments
adb shell pm uninstall -k --user 0 com.opos.cs
adb shell pm uninstall -k --user 0 com.facebook.katana rem FB JUNK
adb shell pm uninstall -k --user 0 com.facebook.system rem FB JUNK
adb shell pm uninstall -k --user 0 com.facebook.appmanager rem FB JUNK
adb shell pm uninstall -k --user 0 com.facebook.services rem FB JUNK
adb shell pm uninstall -k --user 0 com.realme.securitycheck
adb shell pm uninstall -k --user 0 com.coloros.phonemanager rem Phone Manager
adb shell pm uninstall -k --user 0 com.coloros.oppomultiapp
:: adb shell pm uninstall -k --user 0 com.coloros.gamespace
adb shell pm uninstall -k --user 0 com.heytap.music rem Music
adb shell pm uninstall -k --user 0 com.heytap.themestore rem Theme Store
adb shell pm uninstall -k --user 0 com.heytap.pictorial
adb shell pm uninstall -k --user 0 com.heytap.habit.analysis
adb shell pm uninstall -k --user 0 com.coloros.backuprestore
adb shell pm uninstall -k --user 0 com.google.android.apps.magazines
adb shell pm uninstall -k --user 0 com.google.android.apps.subscriptions.red
adb shell pm uninstall -k --user 0 com.coloros.oshare
adb shell pm uninstall -k --user 0 com.oppo.quicksearchbox
:: adb shell pm uninstall -k --user 0 com.coloros.gamespaceui
adb shell pm uninstall -k --user 0 com.google.android.youtube rem YouTube
adb shell pm uninstall -k --user 0 com.coloros.assistantscreen
adb shell pm uninstall -k --user 0 com.google.android.apps.nbu.paisa.user rem Gpay
adb shell pm uninstall -k --user 0 com.coloros.videoeditor
adb shell pm uninstall -k --user 0 com.coloros.video
adb shell pm uninstall -k --user 0 com.heytap.browser
adb shell pm uninstall -k --user 0 com.os.docvault rem Doc Vault
adb shell pm uninstall -k --user 0 com.finshell.fin rem Finshell
adb shell pm uninstall com.coloros.onekeylockscreen
adb shell pm uninstall com.realmecomm.app
adb shell pm uninstall com.heytap.quickgame
adb shell pm uninstall -k --user 0 com.heytap.cloud
adb shell pm uninstall -k --user 0 com.heytap.usercenter
adb shell pm uninstall -k --user 0 com.oplus.games
adb shell pm uninstall com.realmestore.app rem Realme Store
adb shell pm uninstall com.google.android.videos
adb shell pm uninstall -k --user 0 com.redteamobile.roaming rem Oroaming
adb shell pm disable-user com.android.fmradio rem Radio
adb shell pm disable-user com.nearme.statistics.rom
adb shell pm disable-user com.glance.internet
echo %s%
echo your device has been debloated
echo %s%
echo %m1%
echo %s%
echo if you like this work, dont forget to follow OshekharO at GitHub 
echo %s%
pause
