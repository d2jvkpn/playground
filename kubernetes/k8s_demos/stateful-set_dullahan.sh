#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


kubectl apply -f k8s.local/data/stateful-set_dullahan.yaml

kubectl get storageclass
kubectl get service
kubectl get statefulset
