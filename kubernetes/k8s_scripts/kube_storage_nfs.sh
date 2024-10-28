#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# sudo apt update && apt -y upgrade && apt install -y nfs-kernel-server nfs-common

# name=k8s-cp01 # node name as pv name
# cap=10Gi
name=$1; cap=$2

node_ip=$(ip route show default | awk '/default/ {print $9}')
namespace=${namespace:-dev}

mkdir -p k8s.local/data

#### 1. NFS
nfs=/data/nfs/$name

mkdir -p $nfs
chmod 1777 /data/nfs

record="$nfs *(rw,sync,no_root_squash,subtree_check)"

[ -z "$(grep "^$nfs " /etc/exports)" ] && \
  echo "$record" | sudo tee -a /etc/exports

sudo exportfs -ra
sudo showmount -e $name

echo "Hello, world!" | sudo tee $nfs/hello.txt

#### 2. Namespace
echo "==> Creating Namespace: $namespace"
kubectl create ns $namespace &> /dev/null || true

#### 3. PersistentVolume
echo "==> Creating PersistentVolume: $name"

cat > k8s.local/data/pv_$name.yaml << EOF
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

kubectl apply -f k8s.local/data/pv_$name.yaml
# kubectl delete pv/$name

#### 4. PersistentVolumeClaim
echo "==> Creating PersistentVolumeClaim: $name"

cat > k8s.local/data/pvc_$name.$namespace.yaml << EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $name
  namespace: $namespace
spec:
  storageClassName: manual
  accessModes: [ ReadWriteMany ]
  resources:
    requests: { storage: $cap }
  # mannual bound
  volumeName: $name
EOF

kubectl apply -f k8s.local/data/pvc_$name.$namespace.yaml
# kubectl -n $namespace delete pvc/$name

# kubectl -n $namespace get pvc --show-labels
# kubectl -n $namespace describe pvc/$name
