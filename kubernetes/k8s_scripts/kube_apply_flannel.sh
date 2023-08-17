#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

yq_path=$(ls -d /opt/yq*)
export PATH=$yq_path:$PATH

grep -w Network k8s_apps/kube-flannel.yaml

# cidr=$(sudo awk '/cluster-cidr/' /etc/kubernetes/manifests/kube-controller-manager.yaml | sed 's/.*=//')
cidr=$(yq .networking.podSubnet kubeadm-config.yaml)

# kubectl patch node k8scp01 -p '{"spec":{"podCIDR":"'"$cidr"'"}}'
# or
sed '/"Network"/s#:.*$#: "'"$cidr"'",#' k8s_apps/kube-flannel.yaml | kubectl apply -f -

# kubectl get nodes
# kubectl -n kube-flannel get pods -o wide
# kubectl describe -n kube-flannel pod kube-flannel-ds-rfw2t
