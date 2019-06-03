FROM ubuntu:latest

ARG PACKER_VERSION="1.3.5"
ARG PACKER_SHA256SUM="14922d2bca532ad6ee8e936d5ad0788eba96f773bcdcde8c2dc7c95f830841ec"

RUN apt-get update && apt-get install -y qemu-system-x86 \
    qemu-utils wget busybox \
    kmod cpio udev lvm2 unzip cloud-utils

RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
        && echo "${PACKER_SHA256SUM} packer_${PACKER_VERSION}_linux_amd64.zip" | sha256sum -c \
        && unzip packer_${PACKER_VERSION}_linux_amd64.zip \
&& mv packer /usr/bin
