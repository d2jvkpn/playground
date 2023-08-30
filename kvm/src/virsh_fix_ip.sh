#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# pip3 install xq
target=$1
KVM_Network=${KVM_Network:-default}

####
# virsh list --all
virsh start $target || true

####
echo "==> Allocating ip address for $target"
addr=""; n=0
while [[ -z "$addr" ]]; do
    # output of 'virsh domifaddr' may contains multilines 
    addr=$(
      virsh domifaddr $target |
      awk 'NR>2 && $1!=""{split($NF, a, "/"); addr=a[1]} END{print addr}'
    )

    sleep 1 && echo -n "."
    n=$((n+1))
    [ $((n % 60 )) == 0 ] && echo ""
done
echo ""
echo "==> Got ip address: $addr"

# mac=$(virsh dumpxml $target | xq -r '.domain.devices.interface.mac."@address"')
mac=$(virsh domiflist $target | awk 'NR==3{print $NF}')
[[ -z "$mac" ]] && { echo "failed to extract mac address" >&2; exit 1; }

####
record=$(printf "<host mac='%s' name='%s' ip='%s'/>" $mac $target $addr)
virsh net-update $KVM_Network add ip-dhcp-host "$record" --live --config

# virsh net-dumpxml $KVM_Network | xq .network.ip.dhcp.host
virsh net-dumpxml $KVM_Network | grep $target

####
# virsh net-dumpxml $KVM_Network
# virsh net-edit $KVM_Network
# virsh net-destroy $KVM_Network
# virsh net-start $KVM_Network

# virsh net-dhcp-leases $KVM_Network
# virsh net-dumpxml $KVM_Network
