#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

mkdir -p k8s.local/data

grep -w Network k8s.local/flannel.yaml

# cidr=$(sudo awk '/cluster-cidr/' /etc/kubernetes/manifests/kube-controller-manager.yaml | sed 's/.*=//')
cidr=$(yq .networking.podSubnet k8s.local/data/kubeadm-config.yaml)

# kubectl patch node k8s-cp01 -p '{"spec":{"podCIDR":"'"$cidr"'"}}'
# or
sed '/"Network"/s#:.*$#: "'"$cidr"'",#' k8s.local/flannel.yaml > k8s.local/data/flannel.yaml

kubectl apply -f k8s.local/data/flannel.yaml

# kubectl get nodes
# kubectl -n kube-flannel get pods -o wide
# kubectl describe -n kube-flannel pod kube-flannel-ds-rfw2t
