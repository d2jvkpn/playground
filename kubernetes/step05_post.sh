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

#### 3. deploy an app
kubectl apply -f k8s_demos/app_nginx.yaml

ip_addr=$(kubectl get service/nginx -o yaml | yq .status.loadBalancer.ingress[0].ip)

echo "==> get public ip: $ip_addr"

curl $ip_addr
