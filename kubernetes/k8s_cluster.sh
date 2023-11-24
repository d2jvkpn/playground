#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

action=$1

function on_exit() {
    date +"==> %FT%T%:z exit" >> logs/k8s_cluster_up.log
}

case $action in
"check")
    ls k8s_apps/{k8s.yaml,kube-flannel.yaml} \
      k8s_apps/{ingress-nginx_cloud.yaml,metrics-server_components.yaml} > /dev/null

    awk '/image: /{
      sub("@sha256.*", "", $NF); sub(":", "_", $NF); sub(".*/", "", $NF);
      print "k8s_apps/images/"$NF".tar.gz";
    }' k8s_apps/k8s.yaml | xargs -i ls {} > /dev/null

    {
        command -v yq
        command -v ansible
        command -v virsh
    } > /dev/null
    ;;

"up")
    bash $0 check

    mkdir -p logs
    echo "================================================================" >> logs/k8s_cluster_up.log
    trap on_exit EXIT

    date +"==> %FT%T%:z step01_kvm_node.sh" >> logs/k8s_cluster_up.log
    bash step01_kvm_node.sh ubuntu k8s-cp01

    date +"==> %FT%T%:z step02_clone_nodes.sh" >> logs/k8s_cluster_up.log
    bash step02_clone_nodes.sh k8s-cp01 \
      k8s-cp02 k8s-cp03 \
      k8s-node01 k8s-node02 k8s-node03 k8s-node04

    date +"==> %FT%T%:z step03_cluster_up.sh" >> logs/k8s_cluster_up.log
    bash step03_cluster_up.sh k8s-cp01 k8s-node01

    date +"==> %FT%T%:z step04_kube_apply.sh" >> logs/k8s_cluster_up.log
    bash step04_kube_apply.sh k8s-cp01 k8s-node01
    ;;

"down")
    ansible k8s_all -m shell --become -a 'shutdown now'
    ;;

"erase")
    for node in $(awk '{print $2}' configs/kvm_k8s.txt); do
        bash ../kvm/src/virsh_delete.sh $node || true
    done
    ;;

*)
    >&2 echo "unknown action"
    exit 1
esac
