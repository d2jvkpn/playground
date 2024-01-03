#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

kubectl apply -f k8s_apps/data/stateful-set_dullahan.yaml

kubectl get storageclass
kubectl get service
kubectl get statefulset
