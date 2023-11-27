#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

action=$1
base_vm=${base_vm:-ubuntu}

creation_msg="exit"
creation_log=logs/k8s_cluster.log

function creation_on_exit() {
    date +"==> %FT%T%:z $creation_msg" >> $creation_log
    cat $creation_log
}

case $action in
"download")
    bash k8s_scripts/k8s_apps_download.sh
    ls -al k8s_apps
    ;;

"check")
    ls k8s_apps/{k8s.yaml,kube-flannel.yaml} \
      k8s_apps/{ingress-nginx_cloud.yaml,metrics-server_components.yaml} > /dev/null

    ls ../kvm/{virsh_wait_until.sh,virsh_clone.sh,virsh_delete.sh} > /dev/null

    awk '/image: /{
      sub("@sha256.*", "", $NF); sub(":", "_", $NF); sub(".*/", "", $NF);
      print "k8s_apps/images/"$NF".tar.gz";
    }' k8s_apps/k8s.yaml | xargs -i ls {} > /dev/null

    { command -v yq; command -v ansible; command -v virsh; } > /dev/null
    # command -v rsync

    ls ~/.ssh/kvm/$base_vm.conf > /dev/null

    virsh start $base_vm
    bash ../kvm/virsh_wait_until.sh $base_vm "running" 60

    n=1
    while ! ssh -o StrictHostKeyChecking=no $base_vm exit; do
        sleep 1

        n=$((n+1))
        [ $n -gt 5 ] && { >&2 echo "ssh can't access vm $base_vm"; exit 1; }
    done
    echo "==> ssh $base_vm: ok"

    virsh shutdown $base_vm
    bash ../kvm/virsh_wait_until.sh $base_vm "shut off"
    ;;

"create")
    mode=$2
    if [[ "$mode" != "mini" && "$mode" != "full" ]]; then
        >&2 echo "unknown mode: $mode, expected: mini, full"
        exit 1
    fi

    # bash $0 check

    mkdir -p logs
    echo "================================================================" >> $creation_log
    trap creation_on_exit EXIT

    date +"==> %FT%T%:z step01_kvm_node.sh" >> $creation_log
    bash step01_kvm_node.sh $base_vm k8s-cp01

    date +"==> %FT%T%:z step02_clone_nodes.sh" >> $creation_log

    if [[ "$mode" = "mini" ]]; then
        bash step02_clone_nodes.sh k8s-cp01 k8s-cp02 k8s-node{01..02}
    else # [[ "$mode" = "full" ]]
        bash step02_clone_nodes.sh k8s-cp01 k8s-cp{02,03} k8s-node{01..04}
    fi

    date +"==> %FT%T%:z step03_cluster_up.sh" >> $creation_log
    bash step03_cluster_up.sh k8s-cp01 k8s-node01

    date +"==> %FT%T%:z step04_kube_apply.sh" >> $creation_log
    bash step04_kube_apply.sh k8s-cp01 k8s-node01

    creation_msg="done"
    ;;

"list")
    virsh list --all |
      awk 'NR==FNR{a[$2]=1; next} FNR<3 || a[$2]{print $0}' configs/k8s_hosts.txt -
    ;;

"start")
    ansible k8s_all --list-hosts | awk 'NR>1' | xargs -i virsh start {} || true

    while ! ansible k8s_all --one-line -m ping; do
        sleep 1
    done
    ;;

"down")
    ansible k8s_all -m shell --become -a 'shutdown -h now' || true

    for node in $(awk '$2 !=""{print $2}' configs/k8s_hosts.txt); do
        bash ../kvm/virsh_wait_until.sh $node "shut off"
    done
    ;;

"erase")
    for node in $(awk '{print $2}' configs/k8s_hosts.txt); do
        bash ../kvm/virsh_delete.sh $node || true
    done
    ;;

*)
    >&2 echo "unknown action"
    exit 1
    ;;
esac
