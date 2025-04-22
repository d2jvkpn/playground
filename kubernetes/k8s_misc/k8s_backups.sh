#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


secs=${secs:-10}
if [ -s ./configs/kube.yaml ]; then
    export KUBECONFIG=./configs/kube.yaml
    echo "==> load $KUBECONFIG"
fi

kubectl=${kubectl:-kubectl} # kubectl="ssh remote kubectl"

bk_dir=backups_$(date +%F)
mkdir -p $bk_dir

[ -s $bk_dir/all-resources.yaml ] || {
    echo "==> $bk_dir/all-resources.yaml"
    $kubectl get all --all-namespaces -o yaml > $bk_dir/all-resources.yaml.tmp
    mv $bk_dir/all-resources.yaml.tmp $bk_dir/all-resources.yaml
    sleep $secs
}

for e in deployments services ingress configmaps secrets persistentVolumes persistentVolumeClaims \
  daemonSets statefulSets cronJob nodes customResourceDefinition; do
    [ -s $bk_dir/resource.$e.yaml ] && continue

    echo "==> $bk_dir/resource.$e.yaml"
    $kubectl get $e -A -o yaml > $bk_dir/resource.$e.yaml.tmp
    mv $bk_dir/resource.$e.yaml.tmp $bk_dir/resource.$e.yaml
    sleep $secs
done

for ns in $($kubectl get ns | awk 'NR>1{print $1}'); do
    [ -s $bk_dir/namespace.$ns.yaml ] && continue

    echo "==> $bk_dir/namespace.$ns.yaml"
    $kubectl -n $ns get all -o yaml > $bk_dir/namespace.$ns.yaml.tmp
    mv $bk_dir/namespace.$ns.yaml.tmp $bk_dir/namespace.$ns.yaml
    sleep $secs
done

exit
# sudo apt install etcd-client
ETCDCTL_API=3 etcdctl --endpoints=<end-point...> snapshot save $bk_dir/etcd.data

etcdctl snapshot restore <backup-file-path>

$kubectl apply -f all-resource-configs.yaml
