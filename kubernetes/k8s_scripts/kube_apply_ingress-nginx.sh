#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# ingress_node=node01 # an worker node
ingress_node=$1

mkdir -p k8s_data

ip=$(kubectl get node/$ingress_node -o wide | awk 'NR==2{print $6}')
kubectl label nodes/$ingress_node ingress-ready=true

# https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
sed '/image:/s/@sha256:.*//' k8s_apps/ingress-nginx_cloud.yaml |
  awk 'BEGIN{RS=ORS="---"}
  /Deployment/{sub("nodeSelector:", "nodeSelector:\n        ingress-ready: \"true\"")}
  { print }' > k8s_data/ingress-nginx.yaml

kubectl apply -f k8s_data/ingress-nginx.yaml

# kubectl delete -f k8s_apps/ingress-nginx_cloud.yaml

kubectl -n ingress-nginx patch svc/ingress-nginx-controller \
  -p "$(printf '{"spec":{"externalIPs":["%s"]}}' $ip)"

kubectl -n ingress-nginx get pods --field-selector status.phase=Running -o wide

kubectl -n ingress-nginx get svc/ingress-nginx-controller

exit

####
node=$(hostname | tr '[:upper:]' '[:lower:]')
kubectl describe node/$node

kubectl -n ingress-nginx get pod
kubectl -n ingress-nginx describe pod

# ip=$(hostname -I | awk '{print $1; exit}')

####
curl -i -H "Host: Your.Domain" $ip
