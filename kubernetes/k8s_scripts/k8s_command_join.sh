#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


node_kind=$1
yaml_file=${yaml_file:-k8s.local/data/kubeadm-init.yaml}

cp_endpoint=$(yq .cp_endpoint $yaml_file)
token=$(yq .token $yaml_file)
cert_hash=$(yq .cert_hash $yaml_file)
cert_key=$(yq .cert_key $yaml_file)

cmd="kubeadm join $cp_endpoint --token ${token} \
  --discovery-token-ca-cert-hash ${cert_hash}"

case "$node_kind" in
"worker")
    echo $cmd
    ;;
"control-plane")
    echo $cmd --control-plane --certificate-key $cert_key
    ;;
*)
    >&2 echo "unknown node_kind: $node_kind"
    exit 1
    ;;
esac
