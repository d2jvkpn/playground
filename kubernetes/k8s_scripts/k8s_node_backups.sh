#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

endpoints=${1:-127.0.0.1:2379}

out_dir=k8s_apps/data/backups_$(date +%FT%H-%M-%S)
db=$out_dir/etcd_snapshot.db
# sudo apt install etcd-client

mkdir -p $out_dir

kubectl get cm -A -o yaml > $out_dir/configmaps.yaml
kubectl get secrets -A -o yaml > $out_dir/secrets.yaml

sudo ETCDCTL_API=3 etcdctl --endpoints=$endpoints \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt snapshot save $db

sudo ETCDCTL_API=3 etcdctl --write-out=table snapshot status $db

# member list
exit

sudo ETCDCTL_API=3 etcdctl --endpoints 10.2.0.9:2379 snapshot restore $db
sudo ETCDCTL_API=3 etcdctl snapshot restore $db --data-dir /var/lib/etcd
