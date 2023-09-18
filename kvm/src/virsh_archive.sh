#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

op=$1
username=$(whoami)

set -x

if [[ "$op" == "backup" ]]; then
    target=$2
    base=data/${target}_kvm_$(date +%FT%H-%M-%S.%N)
    echo "==> backup $target"
    mkdir -p $base

    virsh shutdown $target || true
    virsh dumpxml $target > $base/$target.kvm.xml
    sudo qemu-img convert -O raw /var/lib/libvirt/images/$target.qcow2 $base/$target.kvm.raw
    sudo chown -R $username:$username $base

    zip -r $base.zip $base
    rm -r $base
elif [[ "$op" == "restore" ]]; then
    base=$2
    echo "==> restore $base"
    ls $base.kvm.xml $base.kvm.raw > /dev/null

    virsh define $base.kvm.xml
    target=$(basename $base)
    sudo qemu-img convert -O qcow2 $base.kvm.raw /var/lib/libvirt/images/$target.qcow2
else
    >&2 echo "invalid operation"
    exit 1
fi

# virt-clone --original ubuntu --name ubuntu-node --file ubuntu-node.qcow2

# virt-install --name ubuntu --import --os-variant=generic --network default --nograph \
#   --memory 2048 --vcpus 2 --disk /var/lib/libvirt/images/ubuntu-node.qcow2,bus=sata
