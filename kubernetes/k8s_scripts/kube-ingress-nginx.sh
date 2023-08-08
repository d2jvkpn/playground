#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
sed '/image:/s/@sha256:.*//' k8s_apps/ingress-nginx_cloud.yaml | kubectl apply -f -

# kubectl delete -f ingress-nginx_cloud.yaml

node=$(hostname | tr '[:upper:]' '[:lower:]')
kubectl describe node/$node

kubectl -n ingress-nginx get pod
kubectl -n ingress-nginx describe pod

ip=$(hostname -I | awk '{print $1; exit}')

kubectl -n ingress-nginx patch svc/ingress-nginx-controller \
  -p "$(printf '{"spec":{"externalIPs":["%s"]}}' $ip)"

exit
curl -i -H "Host: Your.Domain" $ip
