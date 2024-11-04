#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

##### 1. apply plugins
bash k8s_scripts/kube_apply_flannel.sh

bash k8s_scripts/kube_apply_metrics-server.sh

#### 2. create and set default namespace dev
kubectl create ns dev
kubectl config set-context --current --namespace=dev

# kubectl config view --minify -o jsonpath='{..namespace}'
# kubectl config view | grep namespace

#### 3. ingress
sed '/image:/s/@sha256:.*//' k8s.local/ingress-nginx.baremetal.yaml > k8s.local/data/ingress-nginx.baremetal.yaml

kubectl apply -f k8s.local/data/ingress-nginx.baremetal.yaml
# kubectl delete -f k8s.local/data/ingress-nginx.baremetal.yaml

kubectl -n ingress-nginx get pods -o wide

# kubectl -n ingress-nginx get deploy
# kubectl -n ingress-nginx get pods --field-selector status.phase=Running -o wide
# kubectl -n ingress-nginx get svc/ingress-nginx-controller

#### 4. metallb
kubectl apply -f k8s.local/metallb-native.yaml

# https://metallb.universe.tf/installation/
# kubectl get configmap kube-proxy -n kube-system -o yaml |
#   sed -e "s/strictARP: false/strictARP: true/" | \
#   kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml |
  sed -e "s/strictARP: false/strictARP: true/" |
  kubectl apply -f - -n kube-system

# https://metallb.universe.tf/configuration/_advanced_ipaddresspool_configuration/

cat > k8s.local/data/metallb-config.yaml <<EOF
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  namespace: metallb-system
  name: local-ip-pool
spec:
  # autoAssign: false
  addresses:
  - 192.168.122.240-192.168.122.250
  # - 192.168.10.0/24
  # - 192.168.1.15

---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  namespace: metallb-system
  name: local-l2-advertisement
spec:
  ipAddressPools:
  - local-ip-pool
EOF

kubectl apply -f k8s.local/data/metallb-config.yaml
