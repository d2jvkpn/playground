#! /usr/bin/env bash
set -eu -o pipefail
# set -x
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

node_kind=$1
yaml_file=${yaml_file:-k8s_apps/data/kubeadm-init.yaml}

cp_endpoint=$(yq .cp_endpoint $yaml_file)
token=$(yq .token $yaml_file)
cert_hash=$(yq .cert_hash $yaml_file)
cert_key=$(yq .cert_key $yaml_file)

cmd="kubeadm join $cp_endpoint --token ${token} --discovery-token-ca-cert-hash ${cert_hash}"

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
