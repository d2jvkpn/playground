#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

####
pod_subnet=${pod_subnet:-10.244.0.0/16}
# cp_node=k8scp01
cp_node=$1

cp_ip=$(hostname -I | awk '{print $1}')
cp_endpoint=$cp_node:6443
# version=1.28.0
version=$(kubeadm version --output=json 2> /dev/null | jq -r .clientVersion.gitVersion)
version=${version#v}

mkdir -p k8s_data

####
echo "==> cp_ip: $cp_ip, cp_node: $cp_node, cp_endpoint: $cp_endpoint, pod_subnet: $pod_subnet"

record="$cp_ip $cp_node"
if [[ -z "$(grep "^$record$" /etc/hosts)" ]]; then
    echo -e "\n\n$record" | sudo tee -a /etc/hosts
fi

####
cat > k8s_data/kubeadm-config.yaml << EOF
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: $version
controlPlaneEndpoint: "$cp_endpoint"
kubeletConfiguration:
  allowSwap: false
networking:
  podSubnet: ${pod_subnet}
EOF

sudo kubeadm init --config=k8s_data/kubeadm-config.yaml --upload-certs -v 5 |
  sudo tee k8s_data/kubeadm-init.out

####
token=$(grep -o "\-\-token [^ ]*" k8s_data/kubeadm-init.out | awk '{print $2; exit}')
cert_hash=$(grep -o "\-\-discovery-token-ca-cert-hash [^ ]*" k8s_data/kubeadm-init.out | awk '{print $2; exit}')
cert_key=$(grep -o "\-\-certificate-key [^ ]*" k8s_data/kubeadm-init.out | awk '{print $2; exit}')

cat > k8s_data/kubeadm-init.yaml <<EOF
cp_ip: $cp_ip
cp_node: $cp_node
cp_endpoint: $cp_endpoint
token: $token
cert_hash: $cert_hash
cert_key: $cert_key
EOF
