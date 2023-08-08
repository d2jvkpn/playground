#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# wget https://docs.projectcalico.org/manifests/calico.yaml
# !! calico/node is not ready: BIRD is not ready: BGP not established
# add to calico.yaml after section "-name: CLUSTER_TYPE"
# - name: IP_AUTODETECTION_METHOD
#   value: "interface=enp3"

interface=$(ip -o -4 route show to default | awk '{print $5}')

sed "/k8s,bgp/a \            - name: IP_AUTODETECTION_METHOD\
\n              value: \"interface=${interface}\"" \
  k8s_apps/ calico.yaml> calico.yaml

grep -A 8 'value: "k8s,bgp"' calico.yaml

# sed -i '/image:/s#docker.io/##' calico.yaml
# grep "image:" calico.yaml
# awk '/image:/{print $NF}' calico.yaml | sort -u

kubectl apply -f calico.yaml

# kubectl describe pod/calico-node-d8nxw -n kube-system
