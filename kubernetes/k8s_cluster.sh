#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

action=$1

creation_msg="exit"
creation_log=k8s_cluster.log

function creation_on_exit() {
    date +"==> %FT%T%:z $creation_msg" >> $creation_log
    cat $creation_log
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
        # command -v rsync
    } > /dev/null
    ;;

"create")
    bash $0 check

    mkdir -p logs
    echo "================================================================" >> $creation_log
    trap creation_on_exit EXIT

    date +"==> %FT%T%:z step01_kvm_node.sh" >> $creation_log
    bash step01_kvm_node.sh ubuntu k8s-cp01

    date +"==> %FT%T%:z step02_clone_nodes.sh" >> $creation_log
    bash step02_clone_nodes.sh k8s-cp01 k8s-cp{02,03} k8s-node{01..04}

    date +"==> %FT%T%:z step03_cluster_up.sh" >> $creation_log
    bash step03_cluster_up.sh k8s-cp01 k8s-node01

    date +"==> %FT%T%:z step04_kube_apply.sh" >> $creation_log
    bash step04_kube_apply.sh k8s-cp01 k8s-node01

    creation_msg="done"
    ;;

"start")
    ansible k8s_all --list-hosts | awk 'NR>1' | xargs -i virsh start {} || true

    while ! ansible k8s_all --one-line -m ping; do
         sleep 1
    done
    ;;

"down")
    ansible k8s_all -m shell --become -a 'shutdown -h now'
    ;;

"erase")
    for node in $(awk '{print $2}' configs/k8s_hosts.txt); do
        bash ../kvm/src/virsh_delete.sh $node || true
    done
    ;;

*)
    >&2 echo "unknown action"
    exit 1
    ;;
esac
