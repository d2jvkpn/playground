#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

####
kubectl get pod -A

kubectl get all -A

kubectl explain pods --recursive

####
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


####
kubeadm config print init-defaults

kubeadm reset -f

systemctl status containerd
systemctl status kubelet

journalctl -fxeu containerd
journalctl -fxeu kubelet

nerdctl -n k8s.io ps

kubeadm token list
kubeadm token create --print-join-command

kubectl -n kube-system describe pod/kube-scheduler-vm2

#### Turning off auto-approval of node client certificates
## https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/
kubectl delete clusterrolebinding kubeadm:node-autoapprove-bootstrap
kubectl get csr
kubectl certificate approve node-csr-c69HXe7aYcqkS1bKmH4faEnHAWxn6i2bHZ2mD04jZyQ

curl -k https://localhost:6443

#### To generate --certificate-key key, you can use the following command:
kubeadm certs certificate-key

kubeadm token create --print-join-command
kubeadm token list

kubectl get pods -A -o wide --no-headers

kubectl get pods -A  -o wide \
  -o custom-columns=POD-NAME:.metadata.name,NAMESPACE:.metadata.namespace,NODE:.spec.nodeName
