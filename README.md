# How to build Exoscale templates with Packer and QEMU

## Requirements

Before starting, you must ensure that you have the following components installed on your machine:

* [Packer](http://packer.io/downloads.html)
* [QEMU](https://www.qemu.org/)
* The `cloud-localds` tool (usually found in the `cloud-image-utils` package for Debian/Ubuntu based systems)

Additionally, in order to build the template you need a public/private SSH key pair. This key will be used by Packer to configure the machine through SSH.

Once the key is generated, you must export 2 environment variables:

- `PACKER_PUBLIC_KEY`: the path to the public SSH key.
- `PACKER_PRIVATE_KEY`: the path to the private SSH key.

## Building images

Run the `build.sh` script followed by the name of the directory corresponding to the image you want to build as a parameter, for example:

```
./build.sh ubuntu-bionic
```

You can also export `PACKER_LOG=1` te see more Packer logs.

### Mac user

On macOS, you can use `build-docker.sh` script with the name of the directory you want to build as a parameter. This script will use [Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/install/) (which must be already installed), and will create a container to run Packer.

### How it works

The script will:

1. Write an `user-data` file containing the generated public key
1. Create a new cloud init disk using the `cloud-localds` command
1. Run the `packer build` command

During this last step, Packer will read the `<image directory>/packer.json` file then start a QEMU virtual machine and configure it through SSH. Once the VM has booted, Packer will copy the *cloud-init* configuration for Exoscale into the machine, then perform a series of tasks in the VM (configure *cloud-init*, do some cleanup, activate the password authentication etc.). When the VM is stopped by Packer, the `shutdown_command` is executed. In this command, we remove all public keys from the `.ssh/authorized_keys` files.

Packer will create the resulting VM template in the `output-qemu` directory.

### OpenBSD images

In order to build an OpenBSD image, you must clone the [openbsd-cloud-init](https://github.com/exoscale/openbsd-cloud-init) repository at the root of the project.

## Debugging the build process

You can connect to the virtual machine through VNC on the port `5910`.
