#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# https://www.cnblogs.com/hahaha111122222/p/17222831.html
# https://metallb.universe.tf/installation/


mkdir -p k8s_apps/data

#### 1.
kubectl create namespace metallb-system

# https://raw.githubusercontent.com/metallb/metallb/refs/heads/main/config/manifests/metallb-native.yamlhttps://github.com/metallb/metallb/blob/main/config/manifests/metallb-native.yaml


kubectl apply -f k8s_apps/data/metallb-native.yaml

#### 2. configmap
cat > k8s_apps/data/metallb-configmap.yaml <<<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.1.240-192.168.1.250
EOF

kubectl apply -f k8s_apps/data/metallb-configmap.yaml

#### 3. load balancer
cat > k8s_apps/data/metallb-service.yaml <<<EOF
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  type: LoadBalancer
  ports:
  - { protocol: TCP, port: 80, targetPort: 80 }
  - { protocol: TCP, port: 443, targetPort: 443 }
EOF

kubectl apply -f k8s_apps/data/metallb-service.yaml
