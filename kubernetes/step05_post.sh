#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

cp_node=$1

# rsync -arPv $cp_node:k8s_apps/data/ k8s_apps/data/
ansible $cp_node -m synchronize -a "mode=pull src=k8s_apps/data/ dest=./k8s_apps/data"
