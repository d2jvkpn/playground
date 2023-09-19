#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

op=$1
# username=$(whoami)

if [ $(id -u) -ne 0 ]; then
    >&2 echo "Please run as root"
    exit 1
fi

mkdir -p data

if [[ "$op" == "backup" ]]; then
    target=$2
    out_zip=data/${target}_kvm_$(date +%FT%H-%M-%S.%N).zip
    echo "==> backup $target to $out_zip"

    virsh shutdown $target || true
    virsh dumpxml $target > data/$target.kvm.xml
    qemu-img convert -O raw /var/lib/libvirt/images/$target.qcow2 data/$target.kvm.raw
    # sudo chown $username:$username data/$target.kvm.raw

    zip -j -r $out_zip data/$target.kvm.xml data/$target.kvm.raw
    rm -f data/$target.kvm.xml data/$target.kvm.raw
    echo "==> saved $out_zip"
elif [[ "$op" == "restore" ]]; then
    zip_file=$2
    target=$(basename $zip_file | sed 's/_kvm_[1-9]*.*//')

    unzip $zip_file -d data
    echo "==> restore $target"
    ls data/$target.kvm.xml data/$target.kvm.raw > /dev/null

    virsh define data/$target.kvm.xml
    qemu-img convert -O qcow2 data/$target.kvm.raw /var/lib/libvirt/images/$target.qcow2
    rm -f data/$target.kvm.xml data/$target.kvm.raw
else
    >&2 echo "invalid operation"
    exit 1
fi

exit 0

virt-clone --original ubuntu --name ubuntu-node --file ubuntu-node.qcow2

virt-install --name ubuntu --import --os-variant=generic --network default --nograph \
  --memory 2048 --vcpus 2 --disk /var/lib/libvirt/images/ubuntu-node.qcow2,bus=sata
