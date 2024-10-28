#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

#### control-plane
cp_endpoint=$1
cp_ip=$(hostname -I | awk '{print $1}')
pod_subnet=${pod_subnet:-10.244.0.0/16}

# version=1.30.0
version=$(kubeadm version --output=json 2> /dev/null | jq -r .clientVersion.gitVersion)
version=${version#v}

mkdir -p k8s.local/data

####
echo "==> cp_endpoint: $cp_endpoint, pod_subnet: $pod_subnet, version: $version"

cat > k8s.local/data/kubeadm-config.yaml << EOF
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: $version
controlPlaneEndpoint: "$cp_endpoint"
kubeletConfiguration:
  allowSwap: false
networking:
  podSubnet: ${pod_subnet}
EOF

sudo kubeadm init --config=k8s.local/data/kubeadm-config.yaml \
  --upload-certs -v 5 &> k8s.local/data/kubeadm-init.out

# kubeadm config print init-defaults

####
token=$(grep -o "\-\-token [^ ]*" k8s.local/data/kubeadm-init.out | awk '{print $2; exit}')

cert_hash=$(
  grep -o "\-\-discovery-token-ca-cert-hash [^ ]*" k8s.local/data/kubeadm-init.out |
  awk '{print $2; exit}'
)

cert_key=$(
  grep -o "\-\-certificate-key [^ ]*" k8s.local/data/kubeadm-init.out |
  awk '{print $2; exit}'
)

cat > k8s.local/data/kubeadm-init.yaml <<EOF
version: $version
datetime: $(date +'%FT%T.%N%:z')
pod_subnet: $pod_subnet
cp_ip: $cp_ip
cp_endpoint: $cp_endpoint
token: $token
cert_hash: $cert_hash
cert_key: $cert_key
EOF
