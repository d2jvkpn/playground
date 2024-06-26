#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

cat container_demo-api.yaml k8s_deploy_mainifest.yaml | yq .spec.template.spec.containers[0].env

cat container_demo-api.yaml k8s_deploy_mainifest.yaml | yq '. | explode(.) | del .demo-api'
