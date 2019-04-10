#!/bin/sh

image=$1

public_key=$(cat ${PACKER_PUBLIC_KEY})

# generate cloud init user data
cat <<EOF > ${image}/user-data
#cloud-config
ssh_authorized_keys:
  - "${public_key}"
EOF

# build cloud init disk
if [ -f ${image}/user-data ]; then cloud-localds seed.img ${image}/user-data; fi

packer build ${image}/packer.json
