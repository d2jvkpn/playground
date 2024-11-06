#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

####
#
kubectl set image deployment/app01 app01-api=my-image:new-tag

#
kubectl rollout status deployment/app01

#
kubectl rollout history deployment/app01

#
kubectl rollout undo deployment/app01

####
kubectl rollout restart deployment/app01
