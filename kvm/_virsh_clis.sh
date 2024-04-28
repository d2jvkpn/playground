#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

#### 1. extend disk size
target=ubuntu

# virsh domblklist $target
# qemu-img info /var/lib/libvirt/images/$target.qcow2
# qemu-img resize /var/lib/libvirt/images/$target.qcow2 +10G
# qemu-img info /var/lib/libvirt/images/$target.qcow2

# Please note that qemu-img can’t resize an image which has snapshots. You will need to first remove
# all VM snapshots. See this example:
# virsh snapshot-list $target
# virsh snapshot-delete --domain $target --snapshotname $??

ssh root@$target
lsblk
pvs
vgdisplay
fdisk -l | grep -- "--lv"
lvextend -L +14G /dev/mapper/ubuntu--vg-ubuntu--lv
resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv

#### 2. network
virsh net-dumpxml $kvm_network
virsh net-edit $kvm_network
virsh net-destroy $kvm_network && virsh net-start $kvm_network
virsh net-dhcp-leases $kvm_network
virsh net-dumpxml $kvm_network

#### 3. more vrish commands
virsh edit $VHOST

virsh setvcpus $target 2 --config

virsh net-list --all
virsh net-info default
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

virsh net-dumpxml default |
  xmllint --xpath "//network//ip//dhcp//child::*[position()>1]//@ip" - |
  sed 's/ip="//; s/"//'

virsh list --all
