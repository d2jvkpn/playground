#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

####
ansible k8s-cp01 -m copy -a 'src=../demo-web dest=./'
ssh k8s-cp01

cd demo-web/k8s

####
kubectl config set-context --current --namespace=dev
# kubectl config view --minify -o jsonpath='{..namespace}'
kubectl config view | grep namespace

# kubectl -n dev create configmap demo-web --from-file=dev.yaml
kubectl create configmap demo-web --from-file=dev.yaml

kubectl apply -f deploy.yaml
kubectl get pods | awk '/^demo-web-/{print "pod/"$1; exit}' | xargs -i kubectl describe {}

kubectl get deploy/demo-web
kubectl describe deploy/demo-web

kubectl scale --replicas=2 deploy/demo-web
