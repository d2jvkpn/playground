#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

if [ $# -lt 2 ]; then
    echo "Usage: bash virsh_proxy.sh <node> <local_port:vm_port>..." >&2
    exit 1
fi

node=$1
shift
ports=$* # LOCAL_Port:VM_Port...

# TODO: wait for ssh port of node to be ready

node_ip=$(ssh -G $node | awk '$1=="hostname"{print $2}')

listenings=$(
  echo $ports | awk -v node_ip=$node_ip '{
    for(i=1; i<=NF; i++) {sub(":", ":"node_ip":", $i); $i="-L "$i;}
    print $0;
  }')

ssh -f -gN $listenings $node
