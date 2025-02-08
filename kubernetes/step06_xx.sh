#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

cp_node=$1

#### 1. monitor
kubectl top nodes
kubectl top pods -A

#### 2. expose k8s cluster port 5432
ansible $cp_node -a "bash k8s_scripts/kube_tcp-services.sh postgres 5432"

#### 3. deploy an app
kubectl apply -f k8s_demos/k8s_web01.yaml

ip_addr=$(kubectl get service/web01 -o yaml | yq .status.loadBalancer.ingress[0].ip)

echo "==> get public ip: $ip_addr"

curl $ip_addr

#### 4. daemon set
# *https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/*

kubectl apply -f k8s_demos/daemon-set_tail-f-hosts.yaml

kubectl -n kube-system get pods --selector=app=tail-f-hosts
