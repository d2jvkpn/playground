#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

export DEBIAN_FRONTEND=nointeractive

# version=1.28.2; node=node01
# version=$(yq .k8s.version k8s_apps/k8s_apps_download.yaml)
version=$1; node=$2; action=$3

case "$action" in
"1" | "drain")
    ## on a cp node
    kubectl get pod -A -o wide | grep $node
    kubectl drain $node --ignore-daemonsets
    ;;
"2" | "upgrade")
    ## on the worker node
    apt-get update

    apt-mark unhold kubeadm kubelet kubectl
    apt-get upgrade -y kubeadm kubelet kubectl
    apt-mark hold kubeadm kubelet kubectl
    systemctl daemon-reload
    systemctl restart kubelet
    ;;
"3" | "uncordon")
    ## on a cp node
    kubectl uncordon $node
    ;;
*)
    >&2 echo "unknown step: $step"
    ;;
esac
