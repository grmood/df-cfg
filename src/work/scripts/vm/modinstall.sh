depmod
mount /dev/md127p2 /boot
dracut --force
umount /boot
reboot


