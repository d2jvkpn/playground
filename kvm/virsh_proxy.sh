#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


if [ $# -lt 2 ]; then
    echo "Usage: bash virsh_proxy.sh <node> <local_port:vm_port>..." >&2
    exit 1
fi

node=$1
shift
ports=$* # LOCAL_Port:VM_Port...

# TODO: wait for ssh port of node to be ready
# virsh autostart $node; virsh autostart --disable $node

node_ip=$(ssh -G $node | awk '$1=="hostname"{print $2; exit;}')

listenings=$(
  echo $ports | awk -v node_ip=$node_ip '{
    for(i=1; i<=NF; i++) {sub(":", ":"node_ip":", $i); $i="-L "$i;}
    print $0;
  }')

ssh -f -gN $listenings $node
