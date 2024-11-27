#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# sudo apt update && apt -y upgrade && apt install -y nfs-kernel-server nfs-common

# name=k8s-cp01
name=$1
cap=10Gi
node_ip=$(ip route show default | awk '/default/ {print $9}')

mkdir -p k8s.local/data

#### 1. NFS
nfs=/data/nfs/k8s/dev
echo "==> 1. Create $nfs"

mkdir -p $nfs
chmod 1777 $nfs

record="$nfs *(rw,sync,no_root_squash,subtree_check)" # insecure

[ -z "$(grep "^$nfs " /etc/exports)" ] && \
  echo "$record" | sudo tee -a /etc/exports

sudo exportfs -ra
sudo showmount -e --no-headers

echo "Hello, world!" | sudo tee $nfs/hello.txt

#### 2. Namespace
kubectl create ns dev &> /dev/null || true

#### 3. PersistentVolume
echo "==> 2. Creating PersistentVolume: dev"

cat > k8s.local/data/pv_nfs01.yaml << EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs01
spec:
  storageClassName: manual
  capacity: { storage: $cap }
  accessModes: [ ReadWriteMany ] # ReadWriteOnce, ReadOnlyMany
  persistentVolumeReclaimPolicy: Retain # Recycle, Delete
  nfs: { path: /data/nfs/k8s/dev, server: $node_ip, readOnly: false }
EOF

kubectl apply -f k8s.local/data/pv_nfs01.yaml
# kubectl delete pv/nfs01

#### 4. PersistentVolumeClaim
echo "==> 3. Creating PersistentVolumeClaim: dev"

cat > k8s.local/data/pvc_nfs01.dev.yaml << EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  namespace: dev
  name: nfs01
spec:
  storageClassName: manual
  accessModes: [ ReadWriteMany ]
  resources:
    requests: { storage: $cap }
  # mannual bound
  volumeName: nfs01
EOF

kubectl apply -f k8s.local/data/pvc_nfs01.dev.yaml
# kubectl -n dev get pvc --show-labels
# kubectl -n dev describe pvc/nfs01
# kubectl -n dev delete pvc/nfs01
