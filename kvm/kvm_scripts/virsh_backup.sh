#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

op=$1; target=$2
username=$(whoami)
base=${target}_kvm_$(date +%F)

set -x

mkdir -p $base

if [ "$op" == "backup" ]; then
    virsh dumpxml $target > $base/$target.xml
    sudo qemu-img convert -O raw /var/lib/libvirt/images/$target.qcow2 $base/$target.raw
    sudo chown -R $username:$username $base

    zip -r $base.zip $base
    rm -r $base
elif [ "$op" == "restore" ]; then
    virsh define $target.xml
    sudo qemu-img convert -O qcow2 $target.raw /var/lib/libvirt/images/$target.qcow2
else
    echo "invalid operation" >&2
    exit 1
fi

# virt-clone --original ubuntu --name ubuntu-node --file ubuntu-node.$(date +'%F').qcow2

# virt-install --name ubuntu --import \
#   --memory 2048 --vcpus 2 --disk /var/lib/libvirt/images/ubuntu-node.$(date +'%F').qcow2,bus=sata \
#   --os-variant=generic --network default \
#   --nograph
