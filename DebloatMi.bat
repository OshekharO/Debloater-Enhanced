@echo OFF
set s=---------------------------------------------------------------------------
set m1= Script Made By OshekharO
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
adb shell pm uninstall -k --user 0 com.android.browser rem Mi Browser
adb shell pm uninstall -k --user 0 com.facebook.katana rem Facebook
adb shell pm uninstall -k --user 0 in.amazon.mShop.android.shopping rem Amazon
adb shell pm uninstall -k --user 0 com.miui.cloudbackup rem Mi cloud
adb shell pm uninstall -k --user 0 com.google.android.apps.subscriptions.red rem Google One
adb shell pm uninstall -k --user 0 com.google.android.apps.nbu.paisa.user rem Google Pay
adb shell pm uninstall -k --user 0 com.linkedin.android rem Linkedin
adb shell pm uninstall -k --user 0 com.xiaomi.account rem Xiaomi Account
adb shell pm uninstall -k --user 0 com.xiaomi.mi_connect_service rem Mi Connect
adb shell pm uninstall -k --user 0 cn.wps.xiaomi.abroad.lite rem WPS
adb shell pm uninstall -k --user 0 com.miui.mishare.connectivity rem Mi Share
adb shell pm uninstall -k --user 0 com.netflix.mediaclient rem Netflix
adb shell pm uninstall -k --user 0 com.amazon.avod.thirdpartyclient rem Amazon Prime Video
adb shell pm uninstall -k --user 0 com.xiaomi.drop rem Share me
adb shell pm uninstall -k --user 0 com.miui.weather2 rem Weather
adb shell pm uninstall -k --user 0 com.miui.cloudservice rem Mi Cloud
adb shell pm uninstall -k --user 0 com.facebook.appmanager rem Facebook App Manager
adb shell pm uninstall -k --user 0 com.facebook.services rem Facebook Services
adb shell pm uninstall -k --user 0 com.facebook.system rem Facebook App Installer
adb shell pm uninstall -k --user 0 com.google.android.apps.tachyon rem Google Duo
adb shell pm uninstall -k --user 0 com.google.android.music rem Google Music
adb shell pm uninstall -k --user 0 com.google.android.videos rem Play Movies
adb shell pm uninstall -k --user 0 com.google.android.youtube rem Youtube
adb shell pm uninstall -k --user 0 com.mi.android.globalFileexplorer rem Administrador de archivos
adb shell pm uninstall -k --user 0 com.miui.analytics rem Analytics
adb shell pm uninstall -k --user 0 com.miui.bugreport rem Mi Feedback
adb shell pm uninstall -k --user 0 com.miui.calculator rem Calculator
adb shell pm uninstall -k --user 0 com.miui.msa.global rem mas (main system advertising)
adb shell pm uninstall -k --user 0 com.miui.notes rem Mi Notes
adb shell pm uninstall -k --user 0 com.miui.player rem Mi Music
adb shell pm uninstall -k --user 0 com.miui.videoplayer rem Mi Video
adb shell pm uninstall -k --user 0 com.xiaomi.mipicks rem Mi Apps
adb shell pm uninstall -k --user 0 com.xiaomi.glgm rem Mi games
adb shell pm uninstall -k --user 0 com.miui.hybrid rem Quick Apps
adb shell pm uninstall -k --user 0 com.xiaomi.payment rem MiPay
adb shell pm uninstall -k --user 0 com.mipay.wallet.id rem Mipay Id 
adb shell pm uninstall -k --user 0 com.xiaomi.o2o rem o2o
adb shell pm uninstall -k --user 0 com.xiaomi.vipaccount rem VIP account , found in some devices
adb shell pm uninstall -k --user 0 com.xiaomi.joyose rem joyose
adb shell pm uninstall -k --user 0 com.xiaomi.lens rem Xiaomi lens
adb shell pm uninstall -k --user 0 com.xiaomi.pass rem xioami Pass
adb shell pm uninstall -k --user 0 com.miui.systemAdSolution rem SystemAdsolution
adb shell pm uninstall -k --user 0 com.baidu.input_mi rem Mi input
adb shell pm uninstall -k --user 0 com.baidu.duersdk.opensdk rem baidu open sdk
adb shell pm uninstall -k --user 0 com.autonavi.minimap rem autonavi minimap
adb shell pm uninstall -k --user 0 com.miui.daemon rem miui daemon
adb shell pm uninstall -k --user 0 com.miui.contentcatcher rem content catcher
adb shell pm uninstall -k --user 0 com.mipay.wallet.in rem Mi pay
echo %s%
echo your device has been debloated
echo %s%
echo %m1%
echo %s%
echo if you like this work, dont forget to follow OshekharO at GitHub 
echo %s%
pause
