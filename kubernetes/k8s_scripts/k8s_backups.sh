#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

endpoints=${1:-127.0.0.1:2379}

mkdir -p k8s_apps/backups
tag=$(date +%FT%H-%M-%S)
# sudo apt install etcd-client

kubectl get cm -A -o yaml > k8s_apps/backups/configmaps.$tag.yaml
kubectl get secrets -A -o yaml > k8s_apps/backups/secrets.$tag.yaml

db=k8s_apps/backups/etcd_snapshot.$tag.db

sudo ETCDCTL_API=3 etcdctl --endpoints=$endpoints  \
  --cert=/etc/kubernetes/pki/etcd/server.crt  --key=/etc/kubernetes/pki/etcd/server.key  \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt snapshot save $db

sudo ETCDCTL_API=3 etcdctl --write-out=table snapshot status $db

# member list
exit
sudo ETCDCTL_API=3 etcdctl --endpoints 10.2.0.9:2379 snapshot restore $db
sudo ETCDCTL_API=3 etcdctl snapshot restore $db --data-dir /var/lib/etcd
