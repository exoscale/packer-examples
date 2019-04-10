#!/bin/sh

# cloud-init: always execute passwords module
sed -i 's/^ - set-passwords$/ - [set-passwords, always]/' /etc/cloud/cloud.cfg
