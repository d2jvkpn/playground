#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# version=1.28.2; node=node01
# version=$(yq .version k8s_apps/k8s.yaml)
version=$1; node=$2; step=$3

case "$step" in
"1")
    #### on a cp node
    kubectl get pod -A -o wide | grep $node
    kubectl drain $node --ignore-daemonsets
    kubectl get pod -A -o wide | grep $node
    ;;
"2")
    #### on the worker node
    apt-get update

    # apt-mark unhold kubeadm kubelet kubectl
    # apt-get install -y kubeadm=${version}-00 kubelet=${version}-00 kubectl=${version}-00
    apt-mark unhold kubeadm kubelet kubectl
    apt-get upgrade -y kubeadm kubelet kubectl
    apt-mark hold kubeadm kubelet kubectl
    systemctl daemon-reload
    systemctl restart kubelet
    ;;
"3")
    #### on a cp node
    kubectl uncordon $node
    ;;
*)
    >&2 echo "unknown step: $step"
    ;;
esac
