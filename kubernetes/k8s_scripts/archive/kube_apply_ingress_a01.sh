#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# node_name=k8s-node01
node_name=$1
# node=$(hostname | tr '[:upper:]' '[:lower:]')
# kubectl describe node/$node

node_ip=$(kubectl get node/$node_name -o wide | awk 'NR==2{print $6}')
# node_ip=$(hostname -I | awk '{print $1; exit}')

mkdir -p k8s.local/data
# https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

kubectl label node $node_name --overwrite node-role.kubernetes.io/ingress=
# kubectl label node $node_name node-role.kubernetes.io/ingress-

kubectl taint nodes $node_name --overwrite node-role.kubernetes.io/ingress=:NoSchedule
# kubectl taint nodes $node_name node-role.kubernetes.io/ingress=:NoSchedule-

sed '/image:/s/@sha256:.*//' k8s.local/ingress-nginx.cloud.yaml |
  yq 'select(.kind == "Deployment").spec.template.spec.nodeName = "'$node_name'"' |
  yq 'select(.kind == "Deployment").spec.template.spec.tolerations = [{"key": "node-role.kubernetes.io/ingress", "operator": "Exists", "effect": "NoSchedule"}]' |
  yq 'select(.kind == "Service" and .metadata.name == "ingress-nginx-controller").spec.externalIPs = ["'$node_ip'"]' \
  > k8s.local/data/ingress-nginx.cloud.yaml

kubectl apply -f k8s.local/data/ingress-nginx.cloud.yaml
# kubectl delete -f k8s.local/data/ingress-nginx.yaml

exit
# kubectl -n ingress-nginx patch svc/ingress-nginx-controller \
#   -p "$(printf '{"spec":{"externalIPs":["%s"]}}' $node_ip)"
#   -p '{"spec":{"externalIPs":["'$node_ip'"]}}'

kubectl -n ingress-nginx get deploy
kubectl -n ingress-nginx get pods --field-selector status.phase=Running -o wide
kubectl -n ingress-nginx get svc/ingress-nginx-controller

# curl -i $node_ip
# curl -i k8s.local
