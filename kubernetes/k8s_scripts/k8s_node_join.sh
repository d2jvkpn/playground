#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

yq_path=$(ls -d /opt/yq*)
export PATH=$yq_path:$PATH

node_kind=$1

cp_ip=$(yq .cp_ip kubeadm-init.yaml)
cp_node=$(yq .cp_node kubeadm-init.yaml)
cp_endpoint=$(yq .cp_endpoint kubeadm-init.yaml)
token=$(yq .token kubeadm-init.yaml)
cert_hash=$(yq .cert_hash kubeadm-init.yaml)
cert_key=$(yq .cert_key kubeadm-init.yaml)
addr=${cp_ip}:6443

record="$cp_ip $cp_node"
if [[ -z "$(grep "^$record$" /etc/hosts)" ]]; then
    echo -e "\n\n$record" | sudo tee -a /etc/hosts
fi

if [ "$node_kind" == "worker" ]; then
    kubeadm join $cp_endpoint --token ${token} --discovery-token-ca-cert-hash ${cert_hash}
elif [ "$node_kind" == "control-plane" ]; then
    kubeadm join $cp_endpoint --token ${token} --discovery-token-ca-cert-hash ${cert_hash} \
      --control-plane --certificate-key $cert_key
else
   echo "unknown node_kind" 1>&2
   exit 1
fi
