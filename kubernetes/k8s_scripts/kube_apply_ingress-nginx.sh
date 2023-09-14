#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# ingress_node=k8s-ingress01
ingress_node=$1
# node=$(hostname | tr '[:upper:]' '[:lower:]')
# kubectl describe node/$node

node_ip=$(kubectl get node/$ingress_node -o wide | awk 'NR==2{print $6}')
# node_ip=$(hostname -I | awk '{print $1; exit}')

mkdir -p k8s_apps/data
# https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

kubectl label nodes/$ingress_node --overwrite node-type=ingress
# kubectl label nodes/$ingress_node node-type-

kubectl taint nodes $ingress_node --overwrite node-type=ingress:NoSchedule
# kubectl taint nodes $ingress_node node-type=ingress:NoSchedule-

# kubectl get nodes/$ingress_node -o yaml

# sed '/image:/s/@sha256:.*//' k8s_apps/ingress-nginx_cloud.yaml |
#   awk 'BEGIN{RS=ORS="---"}
#   /Deployment/{sub("nodeSelector:", "nodeSelector:\n        node-type: ingress")}
#   { print }' > k8s_apps/data/ingress-nginx.yaml

fields='''
      tolerations:
      - { key: node-type, value: ingress, operator: Equal, effect: NoSchedule }
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                - { key: node-type, operator: In, values: [ingress] }
'''

sed '/image:/s/@sha256:.*//' k8s_apps/ingress-nginx_cloud.yaml |
  awk -v fields="$fields" 'BEGIN{RS=ORS="---"}
  /Deployment/{$0=$0""fields} {print}' |
  yq --prettyPrint > k8s_apps/data/ingress-nginx.yaml

kubectl apply -f k8s_apps/data/ingress-nginx.yaml
# kubectl get pods -A -o wide
# kubectl delete -f k8s_apps/data/ingress-nginx.yaml

kubectl -n ingress-nginx patch svc/ingress-nginx-controller \
  -p "$(printf '{"spec":{"externalIPs":["%s"]}}' $node_ip)"
# -p '{"spec":{"externalIPs":["'$ip'"]}}'

kubectl -n ingress-nginx get deploy
kubectl -n ingress-nginx get pods --field-selector status.phase=Running -o wide
kubectl -n ingress-nginx get svc/ingress-nginx-controller
# kubectl -n ingress-nginx get pod -o wide
# kubectl -n ingress-nginx describe pod

# curl -i $node_ip
