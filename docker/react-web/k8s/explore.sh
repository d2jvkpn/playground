#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)/
_path=$(dirname $0)/

####
kubectl get pods --show-labels
kubectl get service -o wide

pod=$(kubectl get pods | awk 'NR==2{print $1}')
kubectl get pod $pod -o wide
kubectl describe pod/$pod
kubectl logs $pod

####
kubectl exec $pod -- apk add curl
kubectl exec $pod -- curl -i localhost:80/react-web/index.html
kubectl port-forward pods/$pod 10080:80

kubectl port-forward deployment/react-web-dev-deploy 10080:80
kubectl get rs
kubectl port-forward replicaset/react-web-dev-deploy-777cc6d7c5 10080:80

curl localhost:10080/api/open/ping

####
kubectl get csinodes
kubectl describe csinodes vm3

kubectl get storageclasses
kubectl describe storageclasses

kubectl get pv

####
kubectl describe svc react-web-clusterip
kubectl get ep react-web-clusterip

kubectl get pods -l app=react-web -o wide

kubectl exec react-web-dev-deploy-777cc6d7c5-jq4lr -- printenv | grep SERVICE

####
kubectl get services kube-dns --namespace=kube-system

kubectl run curl --image=radial/busyboxplus:curl -i --tty
nslookup react-web
# kubectl attach curl -c curl -i -t

# https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/
make keys KEY=/tmp/nginx.key CERT=/tmp/nginx.crt
kubectl create secret tls nginxsecret --key /tmp/nginx.key --cert /tmp/nginx.crt

kubectl get secrets

kubectl create configmap nginxconfigmap --from-file=default.conf

kubectl get configmaps

####
kubectl get service hello --output yaml

kubectl get endpoints

####
kubectl apply -f ingress_hello.yaml
kubectl describe ingress minimal-ingress

kubectl logs -n ingress-nginx

####
kubectl scale deployment react-web-dev-deploy --replicas=3

kubectl rollout restart deploy/react-web-dev-deploy
kubectl rollout restart -f deploy-dev.yaml

image=$(kubectl get deploy/react-web-deploy -o jsonpath="{.spec.template.spec.containers[0].image}")
if [[ "$image" == *-xx ]]; then
    new_image=${image%-xx}
else
    new_image=${image}-xx
fi

kubectl set image deployment/react-web-dev-deploy react-web-dev=$new_image

kubectl set image deployment/react-web-test-deploy react-web-test=$new_image
