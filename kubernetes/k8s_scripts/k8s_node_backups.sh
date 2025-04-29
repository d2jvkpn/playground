#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


endpoints=${1:-127.0.0.1:2379}

output_dir=cache/k8s.data/backups_$(date +%FT%H-%M-%S)
db=$output_dir/etcd_snapshot.db
# sudo apt install etcd-client

mkdir -p $output_dir

kubectl get cm -A -o yaml > $output_dir/configmaps.yaml
kubectl get secrets -A -o yaml > $output_dir/secrets.yaml

sudo ETCDCTL_API=3 etcdctl --endpoints=$endpoints \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt snapshot save $db

sudo ETCDCTL_API=3 etcdctl --write-out=table snapshot status $db

# member list
exit

sudo ETCDCTL_API=3 etcdctl --endpoints 10.2.0.9:2379 snapshot restore $db
sudo ETCDCTL_API=3 etcdctl snapshot restore $db --data-dir /var/lib/etcd
