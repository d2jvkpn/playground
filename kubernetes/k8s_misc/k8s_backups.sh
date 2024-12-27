#!/bin/bash
# set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0) # set -x

[ -s ./kubeconfig.yaml ] && export KUBECONFIG=./kubeconfig.yaml
echo "==> load $(ls $KUBECONFIG)"

kubectl=${kubectl:-kubectl} # kubectl="ssh remote kubectl"

bk_dir=backups_$(date +%F)

mkdir -p $bk_dir

[ -s $bk_dir/all-resources.yaml ] || {
    echo "==> $bk_dir/all-resources.yaml"
    $kubectl get all --all-namespaces -o yaml > $bk_dir/all-resources.yaml
}

for e in deployments services ingress \
  daemonSets configmaps secrets \
  persistentVolumes persistentVolumeClaims statefulSets cronJob nodes; do
    [ -s $bk_dir/resource.$e.yaml ] && continue

    echo "==> $bk_dir/resource.$e.yaml"
    $kubectl get $e -A -o yaml > $bk_dir/resource.$e.yaml
    sleep 10
done

for ns in $($kubectl get ns | awk 'NR>1{print $1}'); do
    [ -s $bk_dir/namespace.$ns.yaml ] && continue

    echo "==> $bk_dir/namespace.$ns.yaml"
    $kubectl -n $ns get all -o yaml > $bk_dir/namespace.$ns.yaml
    sleep 10
done

exit
# sudo apt install etcd-client
ETCDCTL_API=3 etcdctl --endpoints=<end-point...> snapshot save $bk_dir/etcd.data

etcdctl snapshot restore <backup-file-path>

$kubectl apply -f all-resource-configs.yaml
