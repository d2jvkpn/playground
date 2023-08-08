#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

kubectl get node --show-labels
kubectl get nodes --show-labels -o wide

node=$(hostname | tr '[:upper:]' '[:lower:]')
kubectl label nodes/$node ingress-ready=true

kubectl taint nodes --all node-role.kubernetes.io/control-plane-

kubectl label nodes/$node nodePool=cluster
# kubectl taint nodes --all node-role.kubernetes.io/master-

# kubectl taint nodes k8scp node-role.kubernetes.io/master-
# ?? MountVolume.SetUp failed for volume "webhook-cert" : secret "ingress-nginx-admission" not found
# undo taint
# kubectl taint nodes k8scp node-role.kubernetes.io/master:NoSchedule

kubectl describe node/$node

systemctl status kubelet
journalctl -xefu kubelet
ls -1 /var/log/pods
