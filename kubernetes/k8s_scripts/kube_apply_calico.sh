#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# https://docs.projectcalico.org/manifests/calico.yaml

# !! calico/node is not ready: BIRD is not ready: BGP not established
# add to calico.yaml after section "-name: CLUSTER_TYPE"
# - name: IP_AUTODETECTION_METHOD
#   value: "interface=enp3"

intf=$(ip -o -4 route show to default | awk '{print $5}')
# grep -A 8 'value: "k8s,bgp"' calico.yaml

s11="$(printf ' %.0s' {1..11})"

sed "/k8s,bgp/a\ ${s11}- name: IP_AUTODETECTION_METHOD\n   ${s11}value: \"interface=${intf}\"" \
  k8s_apps/calico.yaml | kubectl apply -f -

# sed -i '/image:/s#docker.io/##' calico.yaml
# grep "image:" calico.yaml
# awk '/image:/{print $NF}' calico.yaml | sort -u
