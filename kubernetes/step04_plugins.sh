#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


##### 1. apply flannel
grep -w Network cache/k8s.downloads/flannel.yaml

# cidr=$(sudo awk '/cluster-cidr/' /etc/kubernetes/manifests/kube-controller-manager.yaml | sed 's/.*=//')
cidr=$(yq .networking.podSubnet cache/k8s.data/kubeadm-config.yaml)

# kubectl patch node k8s-cp01 -p '{"spec":{"podCIDR":"'"$cidr"'"}}'
# or
sed '/"Network"/s#:.*$#: "'"$cidr"'",#' cache/k8s.downloads/flannel.yaml \
  > cache/k8s.data/flannel.yaml

kubectl apply -f cache/k8s.data/flannel.yaml

# kubectl get nodes
# kubectl -n kube-flannel get pods -o wide
# kubectl describe -n kube-flannel pod kube-flannel-ds-rfw2t

#### 2. apply metrics
## https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/
## https://www.kubecost.com/kubernetes-autoscaling/kubernetes-hpa/

awk '
  /InternalIP,ExternalIP,Hostname/{
    sub("InternalIP,ExternalIP,Hostname", "InternalIP", $0);
    print "        - --kubelet-insecure-tls";
  }
  {print}' cache/k8s.downloads/metrics-server_components.yaml \
  > cache/k8s.data/metrics-server_components.yaml

kubectl apply -f cache/k8s.data/metrics-server_components.yaml
