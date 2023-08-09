#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export PATH=/opt/bin:$PATH

node_kind=$1
yaml=k8s_${node_kind}_join.yaml

cp_node_ip=$(yq .cp_node_ip $yaml)
cp_node_name=$(yq .cp_node_name $yaml)
token=$(yq .token $yaml)
cert_hash=$(yq .cert_hash $yaml)
cert_key=$(yq .cert_key $yaml)

if [[ -z "$(grep "${cp_node_ip} ${cp_node_name}" /etc/hosts)" ]]; then
    echo -e "\n\n${cp_node_ip} ${cp_node_name}" | sudo tee -a /etc/hosts
fi

if [ "$node_kind" == "worker" ]; then
    kubeadm join ${cp_node_name}:6443 --token ${token} --discovery-token-ca-cert-hash ${cert_hash}
elif [ "$node_kind" == "control-plane" ]; then
    sudo kubeadm join ${cp_node_name}:6443 --token ${token} \
      --discovery-token-ca-cert-hash ${cert_hash} \
      --control-plane --certificate-key $cert_key
else
   echo "unknown node_kind" 1>&2
   exit 1
fi
