@echo off

echo If you can read this, means that your Thrive
echo isn't connected, you have USB Debugging disabled on your
echo Thrive, or the ADB drivers are not installed on
echo your computer.
echo If it is simply that you have USB Debugging disabled
echo (as it is on any stock device), then please go to 
echo Settings -^> Developer Options -^> USB debugging enabled.
echo.
roottool\adb wait-for-device
cls

echo Welcome to the opportunity to free your Thrive!
echo.
echo Originally developed by TYBAR at the Thrive forums
echo and finalized by AmEv and pio_masaki,
echo this tool pushes several files onto your device,
echo then flashes the unlocked bootloader, then
echo installs the SU binary.
echo.
echo I am not responsible if you break your tablet, you
echo were the one that ran this. In the off chance that
echo something does happen, please PM me, pio_masaki,
echo or dalepl for help. Also, I am completely not 
echo responsible for pixies flying out of your HDMI
echo port, either. ;)
echo.
echo Please connect your tablet now, or exit to keep
echo a full stock Thrive. Also, either be plugged in,
echo or have at least 30% battery.

pause
cls

echo.
echo.
echo At this time, a screen will pop up on your device
echo asking for a restore. There are no passwords. Press it.

pause

cd roottool
adb wait-for-device
adb restore fakebackup.ab
adb shell "while ! ln -s /data/local.prop /data/data/com.android.settings/a/file99; do :; done" > %NUL
echo Backup restore successful! Rebooting...
adb reboot

adb wait-for-device
cls
echo.
echo Making tempdirs...
adb shell "mkdir /data/x-root"
adb shell "mkdir /data/x-root/bin"
echo.
echo Pushing unlocked bootloader....
adb push blob /data/x-root/blob
echo.
echo Pushing rootable boot image
adb push boot.img /data/x-root/boot.img
echo.
echo Pushing CWM...
adb push recovery.img /data/x-root/recovery.img
echo.
echo Bypassing sealime....
adb shell "mv /dev/block/mmcblk0p6 /dev/block/mmcblk0p9"
echo.
echo Flashing unlocked bootloader....
adb shell dd if=/data/x-root/blob of=/dev/block/mmcblk0p9
echo.
echo Flashing rootable boot image...
adb shell dd if=/data/x-root/boot.img of=/dev/block/mmcblk0p2
echo Flashing CWM....
adb shell dd if=/data/x-root/recovery.img of=/dev/block/mmcblk0p1
echo.
echo Rebooting to take effect...
adb reboot
echo Your screen will most likely go blank here.
echo DO NOT POWER OFF! Give it a full 60 seconds
echo before calling for help!
echo.
adb wait-for-device 
cls
echo Pushing files....
adb push busybox /data/x-root/bin/busybox
adb push su /data/x-root/bin/su
echo.
echo Setting up BusyBox and SU....
adb shell "chmod 755 /data/x-root/bin/busybox"
echo.
echo Mounting /System
adb remount
echo.
echo Pushing su binary into system....
adb shell "data/x-root/bin/busybox cp /data/x-root/bin/su /system/bin/"
adb shell "data/x-root/bin/busybox cp /data/x-root/bin/busybox /system/xbin/"

adb shell "chmod 4555 /system/bin/su"
adb shell sync
echo.
echo Pushing matching kernel modules...
adb push bcm4329.ko /system/lib/modules/bcm4329.ko
adb push bcmdhd.ko /system/lib/modules/bcmdhd.ko
adb push scsi_wait_scan.ko /system/lib/modules/scsi_wait_scan.ko
echo.
echo Setting permissions...
adb shell chown root:root /system/lib/modules/bcm4329.ko
adb shell chown root:root /system/lib/modules/bcmdhd.ko
adb shell chown root:root /system/lib/modules/scsi_wait_scan.ko
adb shell chmod 0644 /system/lib/modules/bcm4329.ko
adb shell chmod 0644 /system/lib/modules/bcmdhd.ko
adb shell chmod 0644 /system/lib/modules/scsi_wait_scan.ko
echo.
echo Editing local.prop for stable use....
adb shell "echo "ro.kernel.qemu=0" > /data/local.prop"
adb reboot
cls

echo Now we need to install ChainsDD's "SuperUser" 
echo from the Play store. Free version is fine.
echo Please run it in order for root to work. We need
echo it to continue.
echo.
echo If it does not install, please let us know on the
echo Thrive forums.
pause
cls
echo.
echo Cleaning up....
echo.
adb shell "busybox rm /data/x-root -rf"

echo Grats, should now be running a fully open system.
echo Flash away!
echo Credit goes to pio_masaki, Walking_corpse, and AmEv for
echo testing and building this script.
pause
cls



