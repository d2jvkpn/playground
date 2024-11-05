#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

cp_node=$1

#### 1. expose k8s cluster port 5432
ansible $cp_node -a "bash k8s_scripts/kube_tcp-services.sh postgres 5432"

#### 2. deploy an app
kubectl apply -f k8s_demos/k8s_web01.yaml

ip_addr=$(kubectl get service/web01 -o yaml | yq .status.loadBalancer.ingress[0].ip)

echo "==> get public ip: $ip_addr"

curl $ip_addr


#### 3. DaemonSet
# *https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/*

kubectl apply -f k8s_demos/ds_tail-f-hosts.yaml

kubectl -n kube-system get pods --selector=name=tail-f-hosts
