#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0) # set -x

ansible all -m synchronize \
  -a "mode=push src=image_traefik_v3.2.2.tar dest=./k8s.local/data"

ansible all -m shell --become \
  -a "ctr -n=k8s.io image import ./k8s.local/data/image_traefik_v3.2.2.tar"

kubectl get pods --namespace kube-system -l app.kubernetes.io/name=traefik

helm template myrelease mychart --output-dir ./output

helm template myrelease mychart --output-dir ./output --values custom-values.yaml
