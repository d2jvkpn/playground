#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

target=$1
KVM_Network=${KVM_Network:-default}

# virsh dumpxml $target
# virsh dumpxml --domain $name
# virsh net-dumpxml KVM_Network

source_file=$(virsh dumpxml --domain $target | grep -o "/.*.qcow2")
echo "==> Source file: $source_file"

virsh shutdown $target 2>/dev/null || true
# virsh destroy $target
virsh undefine $target 2>/dev/null || true

sudo rm $source_file

sed 's/^Host/\n&/' ~/.ssh/config | sed '/^Host '"$target"'$/,/^$/d; /^$/d' > ssh.tmp.config
mv ssh.tmp.config ~/.ssh/config

virsh net-dumpxml $KVM_Network | grep -v "name='$target'" > $KVM_Network.xml
virsh net-define $KVM_Network.xml
virsh net-destroy $KVM_Network
virsh net-start $KVM_Network
