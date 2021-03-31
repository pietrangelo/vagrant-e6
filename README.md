# How to

## Prerequisites

### Software

- VirtualBox > 6.1 https://www.virtualbox.org/wiki/Downloads
- Any of Linux, Windows > 8.1 (Professional), Mac OSX
- Vagrant https://www.vagrantup.com/downloads.html
- Oc client tools installed in your host pc [Download From here](https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz)

### Hardware

The vagrant box will be configured to allocate by default *6GB* of RAM and *4 VCPU* so your host pc should have at least:
- A cpu with 4 cores, more is better
- 16 GB of RAM if you want also to develop directly on your host pc while executing the VM
- SSD disk

## Create the Box

In the root of this project run `vagrant up` and wait until the process ends. The first time it will take longer so you can take a coffee and relax.

**During the startup phase vagrant will ask you to choose the network interface to use for the bridging.** This way all the network configuration will be done automatically and you'll access to openshift web console from your pc.

## Login to the VM

Execute `vagrant ssh` and you'll be connected in ssh to the newly created VM.

## Start Openshift installation

Execute `./start-oc.sh` and yes... if you want you can take another coffee. This script will also :
- assigns the cluster-role rights to the **developer** user
- install the Entando CRD (v6.2.7)
- create a project called **my-app**

## Common vagrant commands

- `vagrant up` The first time create the VM from scratch or start the VM if already created.
- `vagrant ssh` connects you to the VM by a ssh connection
- `vagrant halt` Shutdown the vm gracefully. Everything will be saved
- `vagrant destroy` Delete the VM. All your work will bi lost
- `vagrant snapshot save [name]` saves a named snapshot of the machine. The state is preserved
- `vagrant snapshot restore [name]` restores the named snapshot
- `vagrant snapshot list` shows you the snapshots
- `vagrant snapshot delete [name]` delete the named snapshot


## Entando helm instructions

The value of `ENTANDO_DEFAULT_ROUTING_SUFFIX` you have to update in your `values.yaml` file of the [helm quickstart project](https://github.com/entando-k8s/entando-helm-quickstart) is made by: **[your-openshift-cluster-ip].xip.io**
