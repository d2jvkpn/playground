#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# https://docs.projectcalico.org/manifests/calico.yaml
mkdir -p k8s_apps/data

# !! calico/node is not ready: BIRD is not ready: BGP not established
# add to calico.yaml after section "-name: CLUSTER_TYPE"
# - name: IP_AUTODETECTION_METHOD
#   value: "interface=enp3"

intf=$(ip -o -4 route show to default | awk '{print $5}')
# grep -A 8 'value: "k8s,bgp"' calico.yaml

s10="$(printf ' %.0s' {1..10})"

sed "/k8s,bgp/a\  ${s10}- name: IP_AUTODETECTION_METHOD\n    ${s10}value: \"interface=${intf}\"" \
  k8s_apps/calico.yaml > k8s_apps/data/calico.yaml

kubectl apply -f k8s_apps/data/calico.yaml

# sed -i '/image:/s#docker.io/##' calico.yaml
# grep "image:" calico.yaml
# awk '/image:/{print $NF}' calico.yaml | sort -u
