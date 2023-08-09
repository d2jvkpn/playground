#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### 1. extend disk size
vm=vm1

# virsh domblklist $vm
# qemu-img info /var/lib/libvirt/images/$vm.qcow2
# qemu-img resize /var/lib/libvirt/images/$vm.qcow2 +10G
# qemu-img info /var/lib/libvirt/images/$vm.qcow2

# Please note that qemu-img can’t resize an image which has snapshots. You will need to first remove
# all VM snapshots. See this example:
# virsh snapshot-list $vm
# virsh snapshot-delete --domain $vm --snapshotname $??

ssh root@$vm
lsblk
pvs
vgdisplay
fdisk -l | grep -- "--lv"
lvextend -L +10G /dev/mapper/ubuntu--vg-ubuntu--lv
resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv

#### 2. more vrish commands
virsh edit $VHOST

virsh setvcpus vm1 2 --config

virsh net-list --all
virsh net-dhcp-leases default

man virsh

virsh start foo
virsh reboot foo
virsh shutdown foo
virsh suspend foo
virsh resume foo

virsh console foo

virsh dumpxml foo
virsh define foo
virsh destroy foo_new
virsh undefine foo_new
