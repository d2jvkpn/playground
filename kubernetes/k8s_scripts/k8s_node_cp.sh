#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### control-plane
pod_subnet=${pod_subnet:-10.244.0.0/16}

# cp_endpoint=$(hostname -I | awk '{print $1}'):6443
cp_endpoint=$1

# version=1.28.0
version=$(kubeadm version --output=json 2> /dev/null | jq -r .clientVersion.gitVersion)
version=${version#v}

mkdir -p k8s_apps/data

####
echo "==> cp_endpoint: $cp_endpoint, pod_subnet: $pod_subnet, version: $version"

cat > k8s_apps/data/kubeadm-config.yaml << EOF
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: $version
controlPlaneEndpoint: "$cp_endpoint"
kubeletConfiguration:
  allowSwap: false
networking:
  podSubnet: ${pod_subnet}
EOF

sudo kubeadm init --config=k8s_apps/data/kubeadm-config.yaml --upload-certs -v 5 |
  sudo tee k8s_apps/data/kubeadm-init.out

####
token=$(grep -o "\-\-token [^ ]*" k8s_apps/data/kubeadm-init.out | awk '{print $2; exit}')
cert_hash=$(grep -o "\-\-discovery-token-ca-cert-hash [^ ]*" k8s_apps/data/kubeadm-init.out | awk '{print $2; exit}')
cert_key=$(grep -o "\-\-certificate-key [^ ]*" k8s_apps/data/kubeadm-init.out | awk '{print $2; exit}')

cat > k8s_apps/data/kubeadm-init.yaml <<EOF
datetime: $(date +'%FT%T.%N%:z')
pod_subnet: $pod_subnet
cp_endpoint: $cp_endpoint
version: $version
token: $token
cert_hash: $cert_hash
cert_key: $cert_key
EOF

exit
kubeadm token create --print-join-command
kubeadm token list
