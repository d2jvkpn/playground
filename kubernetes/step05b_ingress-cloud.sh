#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# node_name=k8s-node01
node_name=$1
# node=$(hostname | tr '[:upper:]' '[:lower:]')
# kubectl describe node/$node

node_ip=$(kubectl get node/$node_name -o wide | awk 'NR==2{print $6}')
# node_ip=$(hostname -I | awk '{print $1; exit}')

mkdir -p cache/k8s.data
# https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

kubectl label node $node_name --overwrite node-role.kubernetes.io/ingress=
# kubectl label node $node_name node-role.kubernetes.io/ingress-

kubectl taint nodes $node_name --overwrite node-role.kubernetes.io/ingress=:NoSchedule
# kubectl taint nodes $node_name node-role.kubernetes.io/ingress=:NoSchedule-


sed '/image:/s/@sha256:.*//' cache/k8s.downloads/ingress-nginx.yaml |
  awk -v node_name="$node_name" -v  node_ip=$node_ip \
    'BEGIN{RS=ORS="---"; h="\n      "; } \
    /\nkind: Deployment\n/{
      $0=$0""h"nodeName: "node_name;
      $0=$0""h"tolerations: [{key: node-role.kubernetes.io/ingress, operator: Exists, effect: NoSchedule}]\n"
    }
    /\nkind: Service\n/ && /name: ingress-nginx-controller\n/ {$0=$0"  externalIPs: ["node_ip"]\n"}
    {print}' |
  yq --prettyPrint > cache/k8s.data/ingress-nginx.yaml

kubectl apply -f cache/k8s.data/ingress-nginx.yaml
# kubectl delete -f cache/k8s.data/ingress-nginx.yaml

exit
# kubectl -n ingress-nginx patch svc/ingress-nginx-controller \
#   -p "$(printf '{"spec":{"externalIPs":["%s"]}}' $node_ip)"
#   -p '{"spec":{"externalIPs":["'$node_ip'"]}}'

kubectl -n ingress-nginx get deploy
kubectl -n ingress-nginx get pods --field-selector status.phase=Running -o wide
kubectl -n ingress-nginx get svc/ingress-nginx-controller

# curl -i $node_ip
# curl -i k8s.local
exit
# kubectl get nodes/$node_name -o yaml
sed '/image:/s/@sha256:.*//' cache/k8s.downloads/ingress-nginx.yaml |
  awk -v node_name="$node_name" -v  node_ip=$node_ip \
    'BEGIN{RS=ORS="---"; h="\n      "; } \
    /\nkind: Deployment\n/{
      $0=$0""h"nodeName: "node_name;
      $0=$0""h"tolerations: [{key: node-role, value: ingress, operator: Equal, effect: NoSchedule}]\n"
    }
    /\nkind: Service\n/ && /name: ingress-nginx-controller\n/ {$0=$0"  externalIPs: ["node_ip"]\n"}
    {print}' |
  yq --prettyPrint > cache/k8s.data/ingress-nginx.yaml


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

sed '/image:/s/@sha256:.*//' cache/k8s.downloads/ingress-nginx.yaml |
  awk -v fields="$(echo "$fields" | sed 's/^/      /')" \
    'BEGIN{RS=ORS="---"} /Deployment/{$0=$0""fields"\n"} {print}' |
  yq --prettyPrint > cache/k8s.data/ingress-nginx.yaml

sed '/image:/s/@sha256:.*//' cache/k8s.downloads/ingress-nginx.yaml |
  awk 'BEGIN{RS=ORS="---"}
  /Deployment/{sub("nodeSelector:", "nodeSelector:\n        node-role: ingress")}
  { print }' > cache/k8s.data/ingress-nginx.yaml
