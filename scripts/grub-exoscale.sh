#!/bin/sh

# boot: setup kernel to output to tty0, ttyS0 and use ethX

mkdir -p /etc/default/grub.d

echo 'GRUB_CMDLINE_LINUX_DEFAULT="elevator=deadline net.ifnames=0 biosdevname=0 console=tty0 console=ttyS0,115200 consoleblank=0 systemd.show_status=true"' > /etc/default/grub.d/60-exoscale.cfg

/usr/sbin/update-grub
