#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

node=$1

# kubectl cordon $node
# kubectl get pods -o wide
# kubectl delete pod pod001
# kubectl uncordon $node

# kubectl drain $node
kubectl drain $node --ignore-daemonsets --delete-local-data
kubectl delete node $node

# if $node is control-plane node, run this command on $node
# kubeadm reset -f
