#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

node_kind=$1

cp_endpoint=$(yq .cp_endpoint k8s_data/kubeadm-init.yaml)
token=$(yq .token k8s_data/kubeadm-init.yaml)
cert_hash=$(yq .cert_hash k8s_data/kubeadm-init.yaml)
cert_key=$(yq .cert_key k8s_data/kubeadm-init.yaml)

cmd="kubeadm join $cp_endpoint --token ${token} --discovery-token-ca-cert-hash ${cert_hash}"

case "$node_kind" in
"worker")
    echo $cmd
    ;;
"control-plane")
    echo $cmd --control-plane --certificate-key $cert_key
    ;;
*)
    >&2 echo "unknown node_kind"
    exit 1
esac
