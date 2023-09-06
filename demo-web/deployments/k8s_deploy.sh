#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### copy demo-web to node k8s-cp01 and create /data/logs on all worker nodes
ansible k8s-cp01 -m copy -a 'src=../demo-web dest=./'
ansible k8s_workers -m shell -a 'sudo mkdir -p /data/logs && sudo chmod -R 777 /data/logs'

ssh k8s-cp01
cd demo-web

#### deployment
kubectl config set-context --current --namespace=dev
# kubectl config view --minify -o jsonpath='{..namespace}'
kubectl config view | grep namespace

# kubectl -n dev create configmap demo-web --from-file=deployments/dev.yaml
kubectl create configmap demo-web --from-file=deployments/dev.yaml

kubectl apply -f deployments/deploy.yaml
kubectl get pods | awk '/^demo-web-/{print $1; exit}' | xargs -i kubectl describe pod/{}

kubectl get pods | awk 'NR>1{print $1}' | xargs -i kubectl logs pod/{}

kubectl get deploy/demo-web
kubectl describe deploy/demo-web

kubectl scale --replicas=2 deploy/demo-web

pod=$(kubectl get pods | awk '/^demo-web-/{print $1; exit}')
kubectl get pod/$pod -o wide
kubectl exec -it $pod -- sh

#### services and ingress-http
kubectl apply -f deployments/k8s_cluster-ip.yaml
kubectl apply -f deployments/ingress.http.yaml

# curl -H 'Host: demo-web.dev.noreply.local' k8s-ingress01/api/v1/open/hello
# curl -H 'Host: demo-web.dev.noreply.local' k8s-ingress01/api/v1/open/world

####
kubectl create secret tls noreply.local --key noreply.local.key --cert noreply.local.cer
# noreply.local.key domains: *.dev.noreply.local, *.test.noreply.local

kubectl -n prod get secret/noreply.local

#### create secret and ingress-https
kubectl create secret tls noreply.local \
  --key noreply.local.key --cert noreply.local.cer -o yaml --dry-run=client |
  kubectl apply -f -

kubectl create secret docker-registry noreply.local \
  --docker-server=registry.noreply.local --docker-email=EMAIL \
  --docker-username=USERNAME --docker-password=PASSWORD

# curl -k -H 'Host: demo-web.dev.noreply.local' https://k8s-ingress01/api/v1/open/hello
# curl -H 'Host: demo-web.dev.noreply.local' https://k8s-ingress01/api/v1/open/world
