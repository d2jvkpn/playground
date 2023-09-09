#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

node_kind=$1

cp_endpoint=$(yq .cp_endpoint k8s_data/kubeadm-init.yaml)
token=$(yq .token k8s_data/kubeadm-init.yaml)
cert_hash=$(yq .cert_hash k8s_data/kubeadm-init.yaml)
cert_key=$(yq .cert_key k8s_data/kubeadm-init.yaml)

if [ "$node_kind" == "worker" ]; then
    echo kubeadm join $cp_endpoint --token ${token} --discovery-token-ca-cert-hash ${cert_hash}
elif [ "$node_kind" == "control-plane" ]; then
    echo kubeadm join $cp_endpoint --token ${token} --discovery-token-ca-cert-hash ${cert_hash} \
      --control-plane --certificate-key $cert_key
else
    >&2 echo "unknown node_kind"
    exit 1
fi
