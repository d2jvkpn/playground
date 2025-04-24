#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)



op=$1
# username=$(whoami)
# [[ $(id -u) -ne 0 ]] && { >&2 echo '''Please run as root!!!'; exit 1; }

mkdir -p data

case "$op" in
"backup")
    target=$2
    out_file=data/${target}.kvm.$(date +%s-%F).tgz
    echo "==> backup $target to $out_file"

    virsh shutdown $target || true
    virsh dumpxml $target > data/$target.xml

    sudo cp /var/lib/libvirt/images/$target.qcow2 data/
    sudo chown $USER:$USER data/$target.qcow2

    tar -I pigz -C data -cf $out_file.temp $target.xml $target.qcow2
    mv $out_file.temp $out_file
    rm -f data/$target.xml data/$target.qcow2

    echo "==> saved $out_file"
    ;;
"restore")
    input_file=$2
    target=$(basename $input_file | sed 's/.kvm.*$//')

    # unzip $input_file -d data
    tar -I pigz -xf $input_file -C data
    ls data/$target.xml data/$target.qcow2 > /dev/null

    echo "==> restore $target"
    sudo mv data/$target.qcow2 /var/lib/libvirt/images/
    virsh define data/$target.xml && rm -f data/$target.xml
    ;;
*)
    >&2 echo "invalid operation"
    exit 1
    ;;
esac

exit 0

####
virt-clone --original ubuntu --name ubuntu-node --file ubuntu-node.qcow2

virt-install --name ubuntu --import --os-variant=generic --network default --nograph \
  --memory 2048 --vcpus 2 --disk /var/lib/libvirt/images/ubuntu-node.qcow2,bus=sata

####
target=ubuntu

sudo qemu-img convert -O raw /var/lib/libvirt/images/$target.qcow2 data/$target.raw

sudo qemu-img convert -O qcow2 data/$target.raw data/$target.qcow2
