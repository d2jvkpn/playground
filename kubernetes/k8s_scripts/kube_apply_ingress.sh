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

kubectl label nodes/$ingress_node --overwrite node-role=ingress
# kubectl label nodes/$ingress_node node-role-

kubectl taint nodes $ingress_node --overwrite node-role=ingress:NoSchedule
# kubectl taint nodes $ingress_node node-role=ingress:NoSchedule-

# kubectl get nodes/$ingress_node -o yaml
sed '/image:/s/@sha256:.*//' k8s_apps/ingress-nginx_cloud.yaml |
  awk -v ingress_node="$ingress_node" -v  node_ip=$node_ip \
    'BEGIN{RS=ORS="---"; h="\n      "; } \
    /\nkind: Deployment\n/{
      $0=$0""h"nodeName: "ingress_node;
      $0=$0""h"tolerations: [{key: node-role, value: ingress, operator: Equal, effect: NoSchedule}]\n"
    }
    /\nkind: Service\n/ && /name: ingress-nginx-controller\n/ {$0=$0"  externalIPs: ["node_ip"]\n"}
    {print}' |
  yq --prettyPrint > k8s_apps/data/ingress-nginx.yaml

kubectl apply -f k8s_apps/data/ingress-nginx.yaml
# kubectl delete -f k8s_apps/data/ingress-nginx.yaml

# kubectl -n ingress-nginx patch svc/ingress-nginx-controller \
#   -p "$(printf '{"spec":{"externalIPs":["%s"]}}' $node_ip)"
#   -p '{"spec":{"externalIPs":["'$node_ip'"]}}'

kubectl -n ingress-nginx get deploy
kubectl -n ingress-nginx get pods --field-selector status.phase=Running -o wide
kubectl -n ingress-nginx get svc/ingress-nginx-controller

# curl -i $node_ip
# curl -i k8s.local

####
exit

fields='''
tolerations:
- { key: node-role, value: ingress, operator: Equal, effect: NoSchedule }
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - { key: node-role, operator: In, values: [ingress] }'''

sed '/image:/s/@sha256:.*//' k8s_apps/ingress-nginx_cloud.yaml |
  awk -v fields="$(echo "$fields" | sed 's/^/      /')" \
    'BEGIN{RS=ORS="---"} /Deployment/{$0=$0""fields"\n"} {print}' |
  yq --prettyPrint > k8s_apps/data/ingress-nginx.yaml

sed '/image:/s/@sha256:.*//' k8s_apps/ingress-nginx_cloud.yaml |
  awk 'BEGIN{RS=ORS="---"}
  /Deployment/{sub("nodeSelector:", "nodeSelector:\n        node-role: ingress")}
  { print }' > k8s_apps/data/ingress-nginx.yaml
