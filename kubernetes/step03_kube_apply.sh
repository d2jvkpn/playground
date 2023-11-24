#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

cp_node=$(yq .cp_node configs/k8s_config.yaml)
ingress_node=$(yq .ingress_node configs/k8s_config.yaml)

ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_apply_flannel.sh"

ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_apply_ingress.sh $ingress_node"
ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_tcp-services.sh postgres 5432"

ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_apply_metrics-server.sh"
