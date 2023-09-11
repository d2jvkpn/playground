#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### copy demo-api to node k8s-cp01 and create /data/logs on all worker nodes
ansible k8s-cp01 -m copy -a 'src=../demo-api/deployments dest=./demo-api'

ansible k8s_workers -m shell --become -a 'mkdir -p /data/local && chmod -R 777 /data/local'

ssh k8s-cp01
cd demo-api

#### deployment
kubectl config set-context --current --namespace=dev
# kubectl config view --minify -o jsonpath='{..namespace}'
# kubectl config view | grep namespace

# kubectl -n dev create configmap demo-api --from-file=deployments/dev.yaml
kubectl create configmap demo-api --from-file=deployments/dev.yaml

kubectl apply -f deployments/k8s_deploy.yaml
kubectl get deploy/demo-api
kubectl describe deploy/demo-api

kubectl get pods -o wide
kubectl get pods | awk '/^demo-api-/{print $1; exit}' | xargs -i kubectl describe pod/{}
kubectl get pods | awk 'NR>1{print $1}' | xargs -i kubectl logs pod/{}

kubectl scale --replicas=2 deploy/demo-api

pod=$(kubectl get pods | awk '/^demo-api-/{print $1; exit}')
kubectl get pod/$pod -o wide
# kubectl exec -it $pod -- sh

#### services and ingress http
kubectl apply -f deployments/k8s_cluster-ip.yaml
kubectl apply -f deployments/k8s_ingress_http.yaml

curl -H 'Host: demo-api.dev.noreply.local' k8s-ingress01/api/v1/open/hello
curl -H 'Host: demo-api.dev.noreply.local' k8s-ingress01/api/v1/open/meta

exit
# method 1
kubectl rollout restart deploy/demo-api

# method 2
kubectl scale --replicas=0 deploy/demo-api
kubectl scale --replicas=3 deploy/demo-api

# method 3
# imagePullPolicy: "Always"
kubectl set image deploy/demo-api \
  demo-api=registry.cn-shanghai.aliyuncs.com/d2jvkpn/demo-api:dev@xxxxxx

# method 4
kubectl patch deploy/demo-api -p \
  '{"spec":{"template":{"spec":{"terminationGracePeriodSeconds":31}}}}'

exit

#### ingress tls(https)
kubectl create secret tls noreply.local --key noreply.local.key --cert noreply.local.cer
# noreply.local.key domains: *.dev.noreply.local, *.test.noreply.local

kubectl -n prod get secret/noreply.local

#### create secret and ingress-https
kubectl create secret tls noreply.local --key noreply.local.key --cert noreply.local.cer \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret docker-registry noreply.local \
  --docker-server=registry.noreply.local --docker-email=EMAIL \
  --docker-username=USERNAME --docker-password=PASSWORD

kubectl apply -f deployments/k8s_ingress_tls.yaml

curl -k -H 'Host: demo-api.dev.noreply.local' https://k8s-ingress01/api/v1/open/hello
curl -H 'Host: demo-api.dev.noreply.local' https://k8s-ingress01/api/v1/open/meta
