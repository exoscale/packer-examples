#!/bin/sh

set -e

# cloud init: move files and change permissions
mv /tmp/cloud-init/* /etc/cloud/cloud.cfg.d/
chown -R root:root /etc/cloud/cloud.cfg.d/

# cleanup cloud-init data
rm -rf /var/lib/cloud/*

ln -s /var/lib/cloud/instances /var/lib/cloud/instance

# cleanup cloud-init logs
rm -rf /var/log/cloud-init*

# cleanup tmp files
rm -rf /tmp/cloud-init
