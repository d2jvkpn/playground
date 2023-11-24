#! /usr/bin/env bash
set -eu -o pipefail

_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})
# set -x

ls k8s_apps/{k8s.yaml,kube-flannel.yaml} \
  k8s_apps/{ingress-nginx_cloud.yaml,metrics-server_components.yaml} > /dev/null

awk '/image: /{
  sub("@sha256.*", "", $NF); sub(":", "_", $NF); sub(".*/", "", $NF);
  print "k8s_apps/images/"$NF".tar.gz";
}' k8s_apps/k8s.yaml | xargs -i ls {} > /dev/null

command -v yq
command -v ansible
command -v virsh
