#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

cp_node=$1; ingress_node=$2

##### 1. apply plugins
ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_apply_flannel.sh"

ansible $cp_node --become -a "bash k8s_scripts/kube_apply_ingress.sh $ingress_node"

ansible $cp_node --become -a "bash k8s_scripts/kube_apply_metrics-server.sh"

#### 2. create and set default namespace dev
ansible $cp_node -a 'kubectl create ns dev'

ansible k8s_cps -a 'kubectl config set-context --current --namespace=dev'

# kubectl config view --minify -o jsonpath='{..namespace}'
# kubectl config view | grep namespace
