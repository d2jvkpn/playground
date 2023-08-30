#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

target=$1
KVM_Network=${KVM_Network:-default}

# virsh dumpxml $target
# virsh dumpxml --domain $target
# virsh net-dumpxml $KVM_Network

####
source_file=$(virsh dumpxml --domain $target | grep -o "/.*.qcow2")
echo "==> Source file: $source_file"

virsh shutdown $target 2>/dev/null || true

while [ $(virsh list --state-running | awk -v target=$target '$2==target{print 1}') == "1" ]; do
    sleep 1 && echo -n .
done
echo ""

sudo rm $source_file

##### virsh destroy $target
virsh undefine $target 2>/dev/null || true

virsh net-dumpxml $KVM_Network | grep -v "name='$target'" > $KVM_Network.xml

virsh net-define $KVM_Network.xml
virsh net-destroy $KVM_Network
virsh net-start $KVM_Network

rm $KVM_Network.xml

####
conf="$HOME/.ssh/kvm.conf"
sed 's/^Host/\n&/' $conf | sed '/^Host '"$target"'$/,/^$/d; /^$/d' > $conf.tmp
mv $conf.tmp $conf
