#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

cp_node=$1
mkdir -p k8s.local/data

##### 1. flannel
grep -w Network k8s.local/flannel.yaml

# cidr=$(sudo awk '/cluster-cidr/' /etc/kubernetes/manifests/kube-controller-manager.yaml | sed 's/.*=//')
cidr=$(yq .networking.podSubnet k8s.local/data/kubeadm-config.yaml)

# kubectl patch node k8s-cp01 -p '{"spec":{"podCIDR":"'"$cidr"'"}}'
# or
sed '/"Network"/s#:.*$#: "'"$cidr"'",#' k8s.local/flannel.yaml > k8s.local/data/flannel.yaml

kubectl apply -f k8s.local/data/flannel.yaml

# kubectl get nodes
# kubectl -n kube-flannel get pods -o wide
# kubectl describe -n kube-flannel pod kube-flannel-ds-rfw2t

#### 2. metrics
## https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/
## https://www.kubecost.com/kubernetes-autoscaling/kubernetes-hpa/

awk '
  /InternalIP,ExternalIP,Hostname/{
    sub("InternalIP,ExternalIP,Hostname", "InternalIP", $0);
    print "        - --kubelet-insecure-tls";
  }
  {print}' k8s.local/metrics-server_components.yaml \
  > k8s.local/data/metrics-server_components.yaml

kubectl apply -f k8s.local/data/metrics-server_components.yaml

#### 3. ingress
sed '/image:/s/@sha256:.*//' k8s.local/ingress-nginx.baremetal.yaml \
  > k8s.local/data/ingress-nginx.baremetal.yaml

kubectl apply -f k8s.local/data/ingress-nginx.baremetal.yaml
# kubectl delete -f k8s.local/data/ingress-nginx.baremetal.yaml

kubectl -n ingress-nginx get pods -o wide

# kubectl -n ingress-nginx get deploy
# kubectl -n ingress-nginx get pods --field-selector status.phase=Running -o wide
# kubectl -n ingress-nginx get svc/ingress-nginx-controller

#### 4. metallb
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

#### 5. storage
ansible $cp_node --become -a "bash k8s_scripts/kube_storage_nfs.sh $cp_node 10Gi"

# node=k8s-cp02
# ansible $node -m shell --become -a "namespace=prod bash k8s_scripts/kube_storage_nfs.sh $node 10Gi"

#### 6. monitor
kubectl top nodes
kubectl top pods -A
