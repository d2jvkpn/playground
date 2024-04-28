#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

cp_node=$1

#### 1. storage
ansible $cp_node --become -a "bash k8s_scripts/kube_storage_nfs.sh $cp_node 10Gi"
# node=k8s-cp02
# ansible $node -m shell --become -a "namespace=prod bash k8s_scripts/kube_storage_nfs.sh $node 10Gi"

#### 2. expose k8s cluster port 5432
ansible $cp_node -a "bash k8s_scripts/kube_tcp-services.sh postgres 5432"

#### 3. sync data
# rsync -arPv $cp_node:k8s_apps/data/ k8s_apps/data/
ansible $cp_node -m synchronize -a "mode=pull src=k8s_apps/data/ dest=./k8s_apps/data"
