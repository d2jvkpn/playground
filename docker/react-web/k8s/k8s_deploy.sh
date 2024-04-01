#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# cd react-web_k8s

#### 1. create deployments
kubectl apply -f k8s_deploy-dev.yaml
kubectl apply -f k8s_deploy-test.yaml
kubectl get deploy

#### 2. create a ClusterIP service (react-web-clusterip) for the deployment (react-web-deploy)
kubectl apply -f service.yaml
kubectl get services

kubectl get ep react-web-clusterip
kubectl describe ep react-web-clusterip
kubectl get service react-web-clusterip -o wide
kubectl describe service react-web-clusterip


#### 3. create a ingress (react-web-ingress) for react-webclusterip
kubectl apply -f k8s_ingress.yaml
kubectl get ingress

kubectl get ingress react-web-ingress
kubectl describe ingress/react-web-ingress

#### test
kubectl get pods -o wide
# curl 10.96.185.201/react-web

curl localhost:80/react-web/dev/index.html
# http://192.168.122.119/react-web/index.html

#### maintance
kubectl scale deployment react-web-dev-deploy --replicas=5

#image=$(
#  kubectl get deploy/react-web-dev-deploy -o jsonpath="{.spec.template.spec.containers[0].image}"
#)

#if [[ "$image" == *-xx ]]; then
#    new_image=${image%-xx}
#else
#    new_image=${image}-xx
#fi

# nerdctl pull registry.cn-shanghai.aliyuncs.com/d2jvkpn/react-web:dev

#= rollout
# not use namespace k8s.io: -n k8s.io

# https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
tag=dev
base=registry.cn-shanghai.aliyuncs.com/d2jvkpn/react-web

nerdctl rmi $base:dev
nerdctl pull $base:dev

image=$(nerdctl inspect $base:dev | jq -r .[0].RepoDigests[0])
# image=registry.cn-shanghai.aliyuncs.com/d2jvkpn/react-web:$version
kubectl set image deployment/react-web-${tag}-deploy react-web-${tag}=$image
# kubectl edit deployment/nginx-deployment

kubectl rollout status deployment/react-web-${tag}-deploy

kubectl get rs

kubectl describe deployment/react-web-${tag}-deploy

#= rollback
kubectl rollout history deployment/react-web-${tag}-deploy
kubectl rollout undo deployment/react-web-${tag}-deploy --to-revision=5

kubectl get deployment/react-web-${tag}-deploy -o yaml

# set resource
kubectl set resources deploy/react-web-${tag}-deploy -c=react-web-${tag} \
  --limits=cpu=200m,memory=512Mi
