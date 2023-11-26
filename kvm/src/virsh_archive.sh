#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

op=$1
# username=$(whoami)

[[ $(id -u) -ne 0 ]] && { >&2 echo '''Please run as root!!!'; exit 1; }

mkdir -p data

if [[ "$op" == "backup" ]]; then
    target=$2
    out_file=data/${target}.kvm.$(date +%s-%F).tgz
    echo "==> backup $target to $out_file"

    virsh shutdown $target || true
    virsh dumpxml $target > data/$target.kvm.xml

    sudo cp /var/lib/libvirt/images/$target.qcow2 data/
    sudo chown -R $USER:$USER data

    if [[ -s  ~/.ssh/kvm/$target.conf ]]; then
        cp ~/.ssh/kvm/$target.conf data
        tar -I pigz -cf $out_file data/$target.kvm.xml data/$target.qcow2 data/$target.conf
    else
        tar -I pigz -cf $out_file data/$target.kvm.xml data/$target.qcow2
    fi

    rm -f data/$target.kvm.xml data/$target.qcow2
    echo "==> saved $out_file"
elif [[ "$op" == "restore" ]]; then
    input_file=$2
    target=$(basename $input_file | sed 's/.kvm.[1-9]*.*//')

    # unzip $input_file -d data
    pigz -dc $input_file | tar xf -
    echo "==> restore $target"
    sudo mv data/$target.qcow2 /var/lib/libvirt/images/

    virsh define data/$target.kvm.xml && rm -f data/$target.kvm.xml
else
    >&2 echo "invalid operation"
    exit 1
fi

exit 0

####
virt-clone --original ubuntu --name ubuntu-node --file ubuntu-node.qcow2

virt-install --name ubuntu --import --os-variant=generic --network default --nograph \
  --memory 2048 --vcpus 2 --disk /var/lib/libvirt/images/ubuntu-node.qcow2,bus=sata

####
target=ubuntu

qemu-img convert -O raw /var/lib/libvirt/images/$target.qcow2 data/$target.kvm.raw

qemu-img convert -O qcow2 data/$target.kvm.raw /var/lib/libvirt/images/$target.qcow2
