#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# sudo apt update && apt -y upgrade && apt install -y nfs-kernel-server nfs-common

# name=cp01 # k8s node name
name=$1
# cap=20; pvc_cap=10
cap=$2
pvc_cap=$3
node_ip=$(ip route show default | awk '/default/ {print $9}')

mkdir -p k8s_apps/data

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

#### 2. namespace dev and prod
echo "==> Creating ns: dev"
kubectl create ns dev &> /dev/null || true

echo "==> Creating ns: prod"
kubectl create ns prod &> /dev/null || true

#### 3. PersistentVolume
echo "==> Creating pv: $name"

cat > k8s_apps/data/pv_$name.yaml << EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: $name
spec:
  storageClassName: manual
  capacity: { storage: ${cap}Gi }
  accessModes: [ ReadWriteMany ]
  persistentVolumeReclaimPolicy: Retain
  # nfs: { path: /data/nfs/$name, server: $name, readOnly: false }
  nfs: { path: /data/nfs/$name, server: $node_ip, readOnly: false }
EOF

kubectl apply -f k8s_apps/data/pv_$name.yaml
# kubectl delete pv/$name

#### 4. PersistentVolumeClaim dev
echo "==> Creating pvc: $name"

cat > k8s_apps/data/pvc_$name.dev.yaml << EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $name
  namespace: dev
spec:
  storageClassName: manual
  accessModes: [ ReadWriteMany ]
  resources:
    requests: { storage: ${pvc_cap}Gi }
  # mannual bound
  volumeName: $name
EOF

kubectl apply -f k8s_apps/data/pvc_$name.dev.yaml
# kubectl -n dev delete pvc/$name
# kubectl -n dev get pvc --show-labels
# kubectl -n dev describe pvc/$name

#### 5. PersistentVolumeClaim prod
cat > k8s_apps/data/pvc_$name.prod.yaml << EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $name
  namespace: prod
spec:
  storageClassName: manual
  accessModes: [ ReadWriteMany ]
  resources:
    requests: { storage: ${pvc_cap}Gi }
  # mannual bound
  volumeName: $name
EOF

kubectl apply -f k8s_apps/data/pvc_$name.prod.yaml
# kubectl -n prod delete pvc/$name
