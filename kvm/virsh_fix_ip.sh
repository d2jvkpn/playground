#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

target=$1
kvm_network=${kvm_network:-default}

# ls configs/$target.password > /dev/null
# command -v sshpass || { echo "no sshpass installed"; exit 1; }

record=$(virsh net-dumpxml $kvm_network | grep "name='"$target"'" || true)
[ -z "$record" ] || { >&2 echo "address of $target has been set"; exit 1; }

#### 1. start vm
echo "==> 1.1 starting $target"

virsh start $target || true
# virsh list --all
# virsh net-list
# virsh net-dhcp-leases default
# rm /var/lib/libvirt/dnsmasq/virbr0.*

#### 2. getting ip address
echo "==> 2.1 allocating ip address for $target"
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
    [ $n -gt 180 ] && { >&2 echo "failed to get ip of $target"; exit 1; }
done
echo ""
echo "==> 2.2 got ip address: $addr"

#### 3. fix ip through net-update
# mac=$(virsh dumpxml $target | xq -r '.domain.devices.interface.mac."@address"')
mac=$(virsh domiflist $target | awk 'NR==3{print $NF}')
[[ -z "$mac" ]] && { >&2 echo "3.1 failed to extract mac address" >&2; exit 1; }

record=$(printf "<host mac='%s' name='%s' ip='%s'/>" $mac $target $addr)
echo "==> 3.2 virsh net-update add record: $record"
virsh net-update $kvm_network add ip-dhcp-host "$record" --live --config


# pip3 install xq
# virsh net-dumpxml $kvm_network | xq .kvm_network.ip.dhcp.host
virsh net-dumpxml $kvm_network | grep name="'"$target"'"
