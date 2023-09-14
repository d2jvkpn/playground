#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

name=vol01; cap=10Gi
mkdir -p k8s_apps/data

kubecte create ns dev || true

cat > k8s_apps/data/pv_$name.yaml <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: $name
  labels: { type: local }
spec:
  storageClassName: manual
  capacity: { storage: $cap }
  accessModes: [ ReadWriteOnce ]
  hostPath:
    path: "/data/$name"

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $name
  namespace: dev
spec:
  storageClassName: manual
  accessModes: [ ReadWriteOnce ]
  resources:
    requests: { storage: $cap }
  volumeName: $name
EOF

kubectl apply -f k8s_apps/data/pv_$name.yaml

# kubectl -n dev delete pvc/$name
# kubectl delete pv/$name
