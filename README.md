# How to build Exoscale templates with Packer and Qemu

## Generates a keypair

In order to build the template, you need a public/private keypair. This key will be used by Packer to configure t he machine through SSH.

Once the key is generated, you should export 2 environment variables:

- `PACKER_PUBLIC_KEY`: the path to your public key.
- `PACKER_PRIVATE_KEY`: the path to your private key.

## Build the image

Launch the `build.sh` script with the name of the directory you want to build as a parameter, for example:

```
./build.sh ubuntu-bionic
```

You can also export `PACKER_LOG=1` te see more Packer logs.

### Mac user

You can use `build-docker.sh` script with the name of the directory you want to build as a parameter.
This script will use [Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/install/), which should be already installed, and will create a 
container to run Packer.

## Clone OpenBSD cloud init

In order to build the OpenBSD image, you should clone the [OpenBSD Cloud Init](https://github.com/exoscale/openbsd-cloud-init) repository at the root of the project.

## How it works

The script will

- Write an `user-data` file containing the generated public key.
- Create a new cloud init disk using the `cloud-localds` command (you should have this command available in your PATH).
- Launch `packer build` on the packer.json file

The `packer.json` file will start the virtual machine, and configure it through SSH. Once the VM booted, Packer will copy the cloud init configuration for Exoscale into the machine.
Then, Packer will execute a serie of script on the virtual machine (to configure cloud init, do some cleanup, activate the password authentication...).

When the Virtual machine is stopped by Packer, the `shutdown_command` is executed. In this command, we remove all public keys from the `.ssh/authorized_keys` files.

Packer will create the resulting virtual machine in the `output-qemu` directory.

## Debug the build

You can connect to the virtual machine through VNC on he port `5910`.
