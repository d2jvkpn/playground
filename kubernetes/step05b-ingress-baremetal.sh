#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

# cp_node=k8s-cp01
cp_node=$(awk '$1!=""{print $1; exit}' configs/k8s_hosts.ini)
cp_ip=$(awk '$1!=""{sub(/.*=/, "", $2); print $2; exit}' configs/k8s_hosts.ini)
echo "==> cp: $cp_node, $cp_ip"

#### 1. apply ingress baremetal
sed '/image:/s/@sha256:.*//' k8s.local/ingress-nginx.baremetal.yaml > k8s.local/data/ingress-nginx.baremetal.yaml

kubectl apply -f k8s.local/data/ingress-nginx.baremetal.yaml
# kubectl delete -f k8s.local/data/ingress-nginx.baremetal.yaml

kubectl -n ingress-nginx get pods -o wide

# kubectl -n ingress-nginx get deploy
# kubectl -n ingress-nginx get pods --field-selector status.phase=Running -o wide
# kubectl -n ingress-nginx get svc/ingress-nginx-controller

#### 2. apply metallb native
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

#### 3. config metallb
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

ansible $cp_node -m shell --become -a "chown -R ubuntu:ubuntu k8s.local"

ansible $cp_node -m synchronize \
  -a "mode=push src=k8s.local/data/ dest=./k8s.local/data/"

ansible $cp_node -m shell -a 'kubectl apply -f k8s.local/data/metallb-config.yaml'

#### 5. allocate ip for ingress-nginx
kubectl -n ingress-nginx patch svc ingress-nginx-controller \
  -p '{"spec":{"type":"LoadBalancer"}}'

ingress_ip=$(
  kubectl -n ingress-nginx get services/ingress-nginx-controller -o yaml |
    yq .status.loadBalancer.ingress[0].ip
)

echo "==> ingress-nginx ip: $ingress_ip"
curl -i $ingress_ip

exit
curl -H "Host: demo-api.dev.k8s.local"  $ingress_ip

####
exit
# kubectl get svc -n ingress-nginx

kubectl -n ingress-nginx get pods |
  awk '/^ingress-nginx-controller-/{print $1}' |
  xargs -i kubectl -n ingress-nginx logs {}

kubectl -n metallb-system get pods |
  awk '/^controller-/{print $1}' |
  xargs -i kubectl -n metallb-system logs {}
