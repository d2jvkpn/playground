#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

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

#### backup and restore
kubectk get cm -A -o yaml > configmaps.yaml
kubectk get secrets -A -o yaml > secrets.yaml

sudo apt install etcd-client

mkdir -p etcd

sudo ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379  \
  --cert=/etc/kubernetes/pki/etcd/server.crt  --key=/etc/kubernetes/pki/etcd/server.key  \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt snapshot save etcd/snap-$(date +%FT%d-%H-%M).db

sudo ETCDCTL_API=3 etcdctl snapshot restore etcd/snap-2023-09-11T11-13-02.db \
  --data-dir /var/lib/etcd
