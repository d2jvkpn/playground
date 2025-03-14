#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

#### copy demo-api to node k8s-cp01 and create /data/logs on all worker nodes
ansible k8s-cp01 -m copy -a 'src=../services/demo-api/deployments dest=./demo-api/'

# ansible k8s_workers -m shell --become -a 'mkdir -p /data/local && chmod -R 777 /data/local'

ssh k8s-cp01

#### Configmap
# kubectl -n dev create configmap demo-api --from-file=dev.yaml
# kubectl create configmap demo-api --from-file=deployments/dev.yaml

kubectl -n dev create configmap demo-api \
  --from-file=dev.yaml -o yaml --dry-run=client |
  kubectl apply -f -

kubectl get configmap demo-api -o yaml

##### ClusterIP, NodePort, Deployment, Ingress(http) and HPA
kubectl apply -f k8s.dev.yaml
# kubectl get deploy/demo-api
# kubectl describe deploy/demo-api

kubectl -n dev get svc
kubectl -n dev patch svc demo-api -p '{"spec":{"type":"LoadBalancer"}}'

####
kubectl get pods -o wide

kubectl get pods -l app=demo-api -o=custom-columns=NAME:.metadata.name |
  sed '1d' |
  xargs -i kubectl describe pod/{}

kubectl get pods -l app=demo-api |
  awk 'NR>1{print $1}' |
  xargs -i kubectl logs pod/{}

kubectl scale --replicas=1 deploy/demo-api

pod=$(kubectl get pods -l app=demo-api | awk 'NR==2{print $1; exit}')
kubectl get pod/$pod -o wide
kubectl exec -it $pod -- ls

####
curl -H 'Host: demo-api.dev.k8s.local' k8s.local/meta | jq
curl -H 'Host: demo-api.dev.k8s.local' k8s.local/api/v1/open/hello | jq

exit
# method 1
kubectl rollout restart deploy/demo-api

# method 2
kubectl scale --replicas=0 deploy/demo-api
kubectl scale --replicas=3 deploy/demo-api

# method 3
# imagePullPolicy: "Always"
# imagePullPolicy: "IfNotPresent"
# imagePullPolicy: "Nerver"
kubectl set image deploy/demo-api \
  demo-api=registry.cn-shanghai.aliyuncs.com/d2jvkpn/demo-api:dev@sha256:xxxxxx

# method 4
kubectl patch deploy/demo-api -p \
  '{"spec":{"template":{"spec":{"terminationGracePeriodSeconds":30}}}}'

date +"==> %FT%T%:z" && \
  kubectl get pods -o wide && \
  curl -H 'Host: demo-api.dev.k8s.local' k8s.local/meta | jq

exit

#### ingress tls(https)
kubectl create secret tls k8s.local --key k8s.local.key --cert k8s.local.cer
# k8s.local.key domains: *.dev.k8s.local, *.test.k8s.local

kubectl -n prod get secret/k8s.local

#### create secret and ingress-https
kubectl create secret tls k8s.local --key k8s.local.key --cert k8s.local.cer \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret docker-registry k8s.local \
  --docker-server=registry.k8s.local --docker-email=EMAIL \
  --docker-username=USERNAME --docker-password=PASSWORD

kubectl apply -f demo-api/deployments/k8s_prod.yaml

#### get image sha256 of containers
kubectl get pods -l app=demo-api -o json |
  jq -r '.items[].status.containerStatuses[0].imageID'

kubectl get pods -l app=demo-api -o json |
  jq -r '.items[].status | .hostIP + ", " + .containerStatuses[0].imageID + ", " + .phase'
