#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

if [ $# -eq 1 ]; then
    target=$1
else
    for target in $*; do
        bash $0 $target
    done
    exit 0
fi

KVM_Network=${KVM_Network:-default}
KVM_SSH_Config=${KVM_SSH_Config:-$HOME/.ssh/kvm.conf}

# virsh dumpxml $target
# virsh dumpxml --domain $target
# virsh net-dumpxml $KVM_Network

####
source_file=$(virsh dumpxml --domain $target | grep -o "/.*.qcow2")
echo "==> Source file: $source_file"

virsh shutdown $target 2>/dev/null || true

while [[ $(virsh list --state-running | awk -v t=$target '$2==t{print 1}') == "1" ]]; do
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
sed 's/^Host/\n&/' $KVM_SSH_Config | sed '/^Host '"$target"'$/,/^$/d; /^$/d' > $KVM_SSH_Config.tmp
mv $KVM_SSH_Config.tmp $KVM_SSH_Config
