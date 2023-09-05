#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

kubectl -n dev create configmap demo-web --from-file=config.dev.yaml

kubectl apply -f deploy.yaml

kubectl -n dev get deploy/demo-web

kubectl scale --replicas=2 deploy/demo-web
