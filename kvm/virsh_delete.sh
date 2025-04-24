#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)



if [ $# -eq 1 ]; then
    target=$1
else
    for target in $@; do
        bash $0 "$target"
    done
    exit 0
fi

[ "$EUID" -ne 0 ] && { >&2 echo "Please run as root"; exit 1; }

kvm_network=${kvm_network:-default}

# username=$1
# home_dir=$(eval echo ~$username)
# kvmssh_dir=${kvmssh_dir:-$home_dir/.ssh/kvm}

# virsh dumpxml $target
# virsh dumpxml --domain $target
# virsh net-dumpxml $kvm_network

####
source_file=$(virsh dumpxml --domain $target | grep -o "/.*.qcow2")
echo "==> Source file: $source_file"

virsh shutdown $target 2>/dev/null || true

# while [[ $(virsh list --state-running | awk -v t=$target '$2==t{print 1}') == "1" ]]; do
#     sleep 1 && echo -n .
# done
# echo ""

bash ${_dir}/virsh_wait_until.sh $target "shut off" 180

rm -f $source_file

##### virsh destroy $target
virsh undefine $target 2>/dev/null || true
virsh net-dumpxml $kvm_network | grep -v "name='$target'" > $kvm_network.xml

virsh net-define $kvm_network.xml
virsh net-destroy $kvm_network
virsh net-start $kvm_network

rm $kvm_network.xml
# [ -f $kvmssh_dir/$target.conf ] && rm -f $kvmssh_dir/$target.conf
