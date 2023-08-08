#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# cp_node_name=k8scp01
# cp_node_ip=192.168.122.55
# token=610c4k.u4v5dco9crsfy70v
# cert_hash=sha256:220bc6f1e266de69cfb267a0b99718cbcf9b86554f9b6c06b45e601e4a67afb5

if [[ -z "$(grep "${cp_node_ip} ${cp_node_name}" /etc/hosts)" ]]; then
    echo -e "\n\n${cp_node_ip} ${cp_node_name}" | sudo tee -a /etc/hosts
fi

kubeadm join ${cp_node_name}:6443 --token ${token} --discovery-token-ca-cert-hash ${cert_hash}
