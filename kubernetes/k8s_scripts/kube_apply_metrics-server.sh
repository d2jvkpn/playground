#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

## https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/
## https://www.kubecost.com/kubernetes-autoscaling/kubernetes-hpa/

awk '
  /InternalIP,ExternalIP,Hostname/{
    sub("InternalIP,ExternalIP,Hostname", "InternalIP", $0);
    print "        - --kubelet-insecure-tls";
  }
  {print}' \
  k8s_apps/metrics-server_components.yaml > k8s_apps/data/metrics-server_components.yaml

kubectl apply -f k8s_apps/data/metrics-server_components.yaml
