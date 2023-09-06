#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

####
ansible k8s-cp01 -m copy -a 'src=../demo-web dest=./'
ansible k8s_workers -m shell -a 'sudo mkdir -p /data/logs && sudo chmod -R 777 /data/logs'

ssh k8s-cp01
cd demo-web/k8s

####
kubectl config set-context --current --namespace=dev
# kubectl config view --minify -o jsonpath='{..namespace}'
kubectl config view | grep namespace

# kubectl -n dev create configmap demo-web --from-file=dev.yaml
kubectl create configmap demo-web --from-file=dev.yaml

kubectl apply -f deploy.yaml
kubectl get pods | awk '/^demo-web-/{print $1; exit}' | xargs -i kubectl describe pod/{}

kubectl get pods | awk 'NR>1{print $1}' | xargs -i kubectl logs pod/{}

kubectl get deploy/demo-web
kubectl describe deploy/demo-web

kubectl scale --replicas=2 deploy/demo-web

pod=$(kubectl get pods | awk '/^demo-web-/{print $1; exit}')
kubectl get pod/$pod -o wide
kubectl exec -it $pod -- sh

####
kubectl apply -f cluster-ip.yaml
kubectl apply -f ingress.http.yaml

# curl -H 'Host: demo-web.dev.noreply.local' k8s-ingress01/api/v1/open/hello
# curl -H 'Host: demo-web.dev.noreply.local' k8s-ingress01/api/v1/open/world
