#!/bin/bash

if [[ -t 0 ]]; then
    INTERACTIVE=1
else
    INTERACTIVE=0
fi

function error() {
    if [ "$INTERACTIVE" -eq 1 ]; then
        echo -e "\e[91m${1}\e[0m" >&2
    else
        echo $1 >&2
    fi
}

function usage() {
    echo "" >&2
    echo "Usage: PACKER_PUBLIC_KEY=~/.ssh/id_rsa.pub PACKER_PRIVATE_KEY=~/.ssh/id_rsa build-docker.sh IMAGE" >&2
    echo "" >&2
    echo "  IMAGE: the name of the subdirectory to build" >&2
    echo "" >&2
    echo "Required software:" >&2
    echo " - Docker" >&2
    echo "" >&2
}


PUB_KEY_DIR=$(dirname ${PACKER_PUBLIC_KEY})
PRIVATE_KEY_DIR=$(dirname ${PACKER_PRIVATE_KEY})

DOCKER_CMD="docker run -ti -v $PWD:/packer-examples -v $PUB_KEY_DIR:$PUB_KEY_DIR -v $PRIVATE_KEY_DIR:$PRIVATE_KEY_DIR -w /packer-examples -e PACKER_PUBLIC_KEY=$PACKER_PUBLIC_KEY -e PACKER_PRIVATE_KEY=$PACKER_PRIVATE_KEY exoscale/builder"

image=$1

if [ -z "$image" ]; then
    error "Error: missing image name argument."
    usage
    exit 1
fi

if [ -z "$PACKER_PUBLIC_KEY" ]; then
    error "Error: missing PACKER_PUBLIC_KEY environment variable."
    usage
    exit 1
fi

if [ -z "$PACKER_PRIVATE_KEY" ]; then
    error "Error: missing PACKER_PRIVATE_KEY environment variable."
    usage
    exit 1
fi

if [ ! -f "$PACKER_PUBLIC_KEY" ]; then
    error "Error: packer public key not readable: $PACKER_PUBLIC_KEY"
    usage
    exit 1
fi

if [ ! -f "$PACKER_PRIVATE_KEY" ]; then
    error "Error: packer private key not readable: $PACKER_PRIVATE_KEY"
    usage
    exit 1
fi

if ! hash docker; then
    error "Error: docker not found"
    usage
    exit
fi


if ! docker image ls --format "{{json .Repository}}" | grep -q exoscale/builder; then
    docker build -t exoscale/builder .
fi

public_key=$(cat ${PACKER_PUBLIC_KEY})

#ulimit -H -n 65535
#ulimit -S -n 65535

# generate cloud init user data
cat <<EOF > ${image}/user-data
#cloud-config
ssh_authorized_keys:
  - "${public_key}"
EOF

# build cloud init disk
if [ -f ${image}/user-data ]; then $DOCKER_CMD cloud-localds seed.img ${image}/user-data; fi

$DOCKER_CMD packer build ${image}/packer.json
