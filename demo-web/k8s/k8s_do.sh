#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

kubectl config set-context --current --namespace=dev

sudo mkdir -p /data/local/demo-web
sudo chmod -R 777 /data/local

# kubectl -n dev create configmap demo-web --from-file=config.dev.yaml

kubectl create configmap demo-web --from-file=config.dev.yaml

kubectl apply -f deploy.yaml

kubectl get deploy/demo-web

kubectl describe deploy/demo-web

kubectl scale --replicas=2 deploy/demo-web
