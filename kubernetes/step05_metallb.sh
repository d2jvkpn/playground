#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

#### 1. metallb
# https://www.cnblogs.com/hahaha111122222/p/17222831.html
# https://metallb.universe.tf/installation/

# https://raw.githubusercontent.com/metallb/metallb/refs/heads/main/config/manifests/metallb-native.yamlhttps://github.com/metallb/metallb/blob/main/config/manifests/metallb-native.yaml

cp k8s.local/metallb-native.yaml k8s.local/data/

kubectl apply -f k8s.local/data/metallb-native.yaml

# https://metallb.universe.tf/installation/
# kubectl get configmap kube-proxy -n kube-system -o yaml |
#   sed -e "s/strictARP: false/strictARP: true/" |
#   kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml |
  sed -e "s/strictARP: false/strictARP: true/" |
  kubectl apply -f - -n kube-system

# https://metallb.universe.tf/configuration/_advanced_ipaddresspool_configuration/

#### 2. metallb-config
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

ansible $cp_node -m synchronize \
  -a "mode=push src=k8s.local/data/ dest=./k8s.local/data/"

ansible $cp_node -m shell -a 'kubectl apply -f k8s.local/data/metallb-config.yaml'

#### 3. allocate ip for ingress-nginx
kubectl -n ingress-nginx patch svc ingress-nginx-controller \
  -p '{"spec": {"type": "LoadBalancer"}}'

ingress_ip=$(
  kubectl -n ingress-nginx get services/ingress-nginx-controller -o yaml |
  yq .status.loadBalancer.ingress[0].ip
)

echo "==> ingress-nginx ip: $ingress_ip"

exit
# kubectl get svc -n ingress-nginx

kubectl -n ingress-nginx get pods |
  awk '/^ingress-nginx-controller-/{print $1}' |
  xargs -i kubectl -n ingress-nginx logs {}

kubectl -n metallb-system get pods |
  awk '/^controller-/{print $1}' |
  xargs -i kubectl -n metallb-system logs {}
