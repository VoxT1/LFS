#!/usr/bin/env dash

read -p 'Please enter the LFS root dir (Ex: /mnt/lfs): ' LFS

echo "\$LFS is set to $LFS..."
echo "If this is not correct, abort NOW. (ctrl+c)"
echo
echo "Continuing in 5 seconds..."
sleep 5

if [ "$(id -u)" = "0" ]; then
    echo "Mounting /dev..."
    mount -v --bind /dev $LFS/dev
    echo
    echo "Mounting virtual kernel file systems..."
    mount -v --bind /dev/pts $LFS/dev/pts
    mount -vt proc proc $LFS/proc
    mount -vt sysfs sysfs $LFS/sys
    mount -vt tmpfs tmpfs $LFS/run
    echo
    echo "Necessary filesystem mount complete. Chrooting into LFS..."
    sleep 2

    chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    /bin/bash --login

else
    echo "This script must be run as root to chroot into LFS!"
    exit 1
fi
