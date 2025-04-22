#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


node=$1

# kubectl drain $node
kubectl drain $node --ignore-daemonsets --delete-local-data
kubectl delete node $node

exit
kubectl cordon $node
kubectl get pods -o wide
kubectl delete pod $pod
kubectl uncordon $node

exit
#### control-plane node
kubeadm reset -f
