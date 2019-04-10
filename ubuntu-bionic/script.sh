#!/bin/sh

apt-get update
apt-get -y dist-upgrade
update-grub

# cloud-init: Remove Cloud Image specific Grub settings for Generic Cloud Images
[ -f /etc/default/grub.d/50-cloudimg-settings.cfg ] && rm /etc/default/grub.d/50-cloudimg-settings.cfg

# clean for real
cloud-init clean

