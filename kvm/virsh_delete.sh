#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

if [ $# -eq 1 ]; then
    target=$1
else
    for target in $@; do
        bash $0 "$target"
    done
    exit 0
fi

[ "$EUID" -ne 0 ] && { >&2 echo "Please run as root"; exit 1; }

KVM_Network=${KVM_Network:-default}

# user=$1
# home_dir=$(eval echo ~$user)
# KVM_SSH_Dir=${KVM_SSH_Dir:-$home_dir/.ssh/kvm}

# virsh dumpxml $target
# virsh dumpxml --domain $target
# virsh net-dumpxml $KVM_Network

####
source_file=$(virsh dumpxml --domain $target | grep -o "/.*.qcow2")
echo "==> Source file: $source_file"

virsh shutdown $target 2>/dev/null || true

# while [[ $(virsh list --state-running | awk -v t=$target '$2==t{print 1}') == "1" ]]; do
#     sleep 1 && echo -n .
# done
# echo ""

bash ${_path}/virsh_wait_until.sh $target "shut off" 180

rm -f $source_file

##### virsh destroy $target
virsh undefine $target 2>/dev/null || true
virsh net-dumpxml $KVM_Network | grep -v "name='$target'" > $KVM_Network.xml

virsh net-define $KVM_Network.xml
virsh net-destroy $KVM_Network
virsh net-start $KVM_Network

rm $KVM_Network.xml
# [ -f $KVM_SSH_Dir/$target.conf ] && rm -f $KVM_SSH_Dir/$target.conf
