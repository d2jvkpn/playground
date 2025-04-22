#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


action=$1
base_vm=${base_vm:-ubuntu}
kvm_dir=../kvm

creation_msg="exit"
creation_log=logs/k8s_cluster.log
creation_ts=$(date +%s)

function elapsed() {
    t0=$1
    t1=$(date +%s)
    delta=$(($t1 - $t0))

    echo "$((delta/60))m$((delta%60))s"
}

function creation_on_exit() {
    date +"==> %FT%T%:z $creation_msg, elapsed $(elapsed $creation_ts)" \
      >> $creation_log
}

case $action in
"download")
    version=$2 # 1.29.0
    bash k8s_scripts/k8s_download.sh $version
    ls -al k8s.local
    ;;

"check")
    ####
    {
      command -v yq;
      command -v ansible;
      command -v virsh;
      command -v rsync;
    } > /dev/null

    ####
    ls k8s.local/{k8s_download.yaml,flannel.yaml} \
      k8s.local/{ingress-nginx.yaml,metrics-server_components.yaml} > /dev/null

    ls $kvm_dir/{virsh_wait_until.sh,virsh_clone.sh,virsh_delete.sh} > /dev/null

    awk '/image: /{
      sub("@sha256.*", "", $NF); sub(":", "_", $NF);
      print "k8s.local/images/"$NF".tar.gz";
    }' k8s.local/k8s_download.yaml | xargs -i ls {} > /dev/null

    ####
    # echo "Include ~/.ssh/kvm/*.conf" >> ~/.ssh/config
    ls ~/.ssh/kvm/$base_vm.conf > /dev/null

    virsh start $base_vm
    bash $kvm_dir/virsh_wait_until.sh $base_vm "running" 60

    # authentication(public key) has already been set up ahead: ssh-copy-id -i ~/.ssh/kvm/kvm.pem $base_vm
    n=1
    while ! ssh -o StrictHostKeyChecking=no $base_vm exit; do
        sleep 1

        n=$((n+1))
        [ $n -gt 30 ] && { >&2 echo "ssh can't access vm $base_vm"; exit 1; }
    done
    echo "==> ssh $base_vm: ok"

    virsh shutdown $base_vm
    ;;

"create")
    shift
    nodes=$*

    # bash $0 check

    mkdir -p logs
    echo "================================================================" \
      >> $creation_log

    trap creation_on_exit EXIT

    ####
    echo "==> $(date +%FT%T%:z) step01_base_node.sh" >> $creation_log
    t0=$(date +%s)

    bash step01_base_node.sh $base_vm k8s-cp01
    echo "==> $(date +%FT%T%:z) elapsed: $(elapsed $t0)" >> $creation_log

    ####
    echo "==> $(date +%FT%T%:z) step02_clone_nodes.sh $nodes" >> $creation_log
    t0=$(date +%s)

    bash step02_clone_nodes.sh $nodes
    echo "==> $(date +%FT%T%:z) elapsed: $(elapsed $t0)" >> $creation_log

    ####
    echo "==> $(date +%FT%T%:z) step03_cluster_up.sh" >> $creation_log
    t0=$(date +%s)

    bash step03_cluster_up.sh
    echo "==> $(date +%FT%T%:z) elapsed: $(elapsed $t0)" >> $creation_log

    ####
    echo "==> $(date +%FT%T%:z) step04_plugins.sh" >> $creation_log
    t0=$(date +%s)

    bash step04_plugins.sh
    echo "==> $(date +%FT%T%:z) elapsed: $(elapsed $t0)" >> $creation_log

    creation_msg="done"
    ;;

"list")
    virsh list --all |
      awk 'NR==FNR && /ansible_/ {a[$1]=1; next} FNR<3 || a[$2]{print $0}' \
      configs/k8s_hosts.ini -
    ;;

"start")
    ansible k8s_all --list-hosts | awk 'NR>1' | xargs -i virsh start {} || true

    n=1
    while ! ansible k8s_all --one-line -m ping; do
        sleep 1

        n=$((n+1))
        [ $n -gt 180 ] && { >&2 echo "failed to start virtual machines"; exit 1; }
    done
    ;;

"down")
    ansible k8s_all -m shell --become -a 'shutdown -h now' || true

    for node in $(awk '/ansible_/{print $1}' configs/k8s_hosts.ini); do
        bash $kvm_dir/virsh_wait_until.sh $node "shut off" 180
    done
    ;;

"erase")
    for node in $(awk '/ansible_/{print $1}' configs/k8s_hosts.ini); do
        bash $kvm_dir/virsh_delete.sh $node || true
    done
    ;;

*)
    >&2 echo "unknown action: $action"
    exit 1
    ;;

esac
