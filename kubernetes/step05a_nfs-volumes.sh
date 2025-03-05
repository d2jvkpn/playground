#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

# cp_node=k8s-cp01
cp_node=$(awk '$1!=""{print $1; exit}' configs/k8s_hosts.ini)

ansible $cp_node --become -a "bash k8s_scripts/kube_storage_nfs.sh $cp_node 10Gi"

# node=k8s-cp02
# ansible $node -m shell --become -a "namespace=prod bash k8s_scripts/kube_storage_nfs.sh $node 10Gi"
