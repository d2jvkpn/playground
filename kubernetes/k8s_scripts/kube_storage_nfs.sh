#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# sudo apt update && apt -y upgrade && apt install -y nfs-kernel-server nfs-common

# name=k8scp01; cap=10Gi
name=$1; cap=$2
sudo mkdir -p k8s_data

#### 1. NFS
nfs=/data/nfs/$name

sudo mkdir -p $nfs
sudo chmod 1777 /data/nfs

[[ -f /etc/exports && ! -f /etc/exports.bk ]] && \
  sudo cp /etc/exports /etc/exports.bk

echo "$nfs *(rw,sync,no_root_squash,subtree_check)" | sudo tee -a /etc/exports

sudo exportfs -ra
sudo showmount -e $name

echo "Hello, world!" | sudo tee $nfs/hello.txt

#### 2. PersistentVolume
echo "==> create pv: $name"

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
  nfs: { path: /data/nfs/$name, server: $name, readOnly: false }
EOF

kubectl create -f k8s_data/pv_$name.yaml

# kubectl delete pv/$name

#### 3. namespace
echo "==> create ns: dev"
kubectl create ns dev || true

#### 4. PersistentVolumeClaim
echo "==> create pvc: $name"

cat > k8s_data/pvc_dev_$name.yaml << EOF
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

kubectl create -f k8s_data/pvc_dev_$name.yaml

# kubectl -n dev delete pvc/$name
kubectl -n dev get pvc --show-labels
kubectl -n dev describe pvc/$name
