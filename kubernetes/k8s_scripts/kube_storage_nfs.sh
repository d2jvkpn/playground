#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# sudo apt update && apt -y upgrade && apt install -y nfs-kernel-server nfs-common

# name=cp01 # k8s node name
name=$1
# cap=10Gi
cap=$2
node_ip=$(ip route show default | awk '/default/ {print $9}')

mkdir -p k8s_data

#### 1. NFS
nfs=/data/nfs/$name

mkdir -p $nfs
chmod 1777 /data/nfs

record="$nfs *(rw,sync,no_root_squash,subtree_check)"

[ -z "$(grep "^$nfs " /etc/exports)" ] &&
  echo "$record" | sudo tee -a /etc/exports

sudo exportfs -ra
sudo showmount -e $name

echo "Hello, world!" | sudo tee $nfs/hello.txt

#### 2. namespace de
echo "==> Creating ns: dev"
kubectl create ns dev || true

#### 3. PersistentVolume
echo "==> Creating pv: $name"

cat > k8s_data/pv_$name.yaml << EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: $name
spec:
  storageClassName: manual
  capacity: { storage: $cap }
  accessModes: [ ReadWriteMany ]
  persistentVolumeReclaimPolicy: Retain
  # nfs: { path: /data/nfs/$name, server: $name, readOnly: false }
  nfs: { path: /data/nfs/$name, server: $node_ip, readOnly: false }
EOF

kubectl apply -f k8s_data/pv_$name.yaml
# kubectl delete pv/$name

#### 4. PersistentVolumeClaim
echo "==> Creating pvc: $name"

cat > k8s_data/pv_$name.yaml << EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $name
  namespace: dev
spec:
  storageClassName: manual
  accessModes: [ ReadWriteMany ]
  resources:
    requests: { storage: $cap }
  # mannual bound
  volumeName: $name
EOF

kubectl -n dev apply -f k8s_data/pv_$name.yaml
# kubectl -n dev delete pvc/$name

# kubectl -n dev get pvc --show-labels
# kubectl -n dev describe pvc/$name
