#!/bin/sh

# Update image to latest status
apt-get update
apt-get --yes dist-upgrade

# Be verbose about Cloud-Init version
apt-cache policy cloud-init

# Update GRUB bootloader (why ?)
update-grub

# Remove Cloud Image specific Grub settings for Generic Cloud Images
[ -f /etc/default/grub.d/50-cloudimg-settings.cfg ] && rm /etc/default/grub.d/50-cloudimg-settings.cfg

# Clean-up unused packages
apt-get autoremove --purge --yes

# Reset cloud-init status (to ship a pristine template)
cloud-init clean

