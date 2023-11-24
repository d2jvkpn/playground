#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

cp_node=$1; ingress_node=$2

ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_apply_flannel.sh"

ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_apply_ingress.sh $ingress_node"
ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_tcp-services.sh postgres 5432"

ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_apply_metrics-server.sh"

# ansible $cp_node --one-line -m fetch \
#   -a "flat=true src=k8s_apps/data/kubeadm-init.yaml dest=k8s_apps/data/"

rsync -arPv $cp_node:k8s_apps/data/ k8s_apps/data/
