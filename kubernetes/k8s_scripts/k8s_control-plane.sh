#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

# node_name=k8scp01
node_name=$1
pod_subnet=${pod_subnet:-10.244.0.0/16}

# version=1.27.4
version=$(kubeadm version  --output=json 2> /dev/null | jq -r .clientVersion.gitVersion | sed 's/^v//')

ip=$(hostname -I | awk '{print $1}')
echo "==> ip: $ip"

if [[ -z "$(grep "$ip $node_name" /etc/hosts)" ]]; then
    echo -e "\n\n$ip $node_name" | sudo tee -a /etc/hosts
fi

# kubeadm config print init-defaults

cat > kubeadm-config.yaml << EOF
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: $version
controlPlaneEndpoint: "$node_name:6443"
kubeletConfiguration:
  allowSwap: false
networking:
  podSubnet: ${pod_subnet}
EOF

sudo kubeadm init --config=kubeadm-config.yaml --upload-certs -v 5 | tee kubeadm-init.out

token=$(grep -o "\-\-token [^ ]*" kubeadm-init.out | awk '{print $2; exit}')
cert_hash=$(grep -o "\-\-discovery-token-ca-cert-hash [^ ]*" kubeadm-init.out | awk '{print $2; exit}')
cert_key=$(grep -o "\-\-certificate-key [^ ]*" kubeadm-init.out | awk '{print $2; exit}')

cat > kubeadm-init.yaml <<EOF
cp_node_ip: $ip
cp_node_name: $node_name
token: $token
cert_hash: $cert_hash
cert_key: $cert_key
EOF

exit

kubeadm reset -f

systemctl status containerd
systemctl status kubelet

journalctl -fxeu containerd
journalctl -fxeu kubelet

nerdctl -n k8s.io ps

# kubeadm token list
# kubeadm token create --print-join-command

# kubectl -n kube-system describe pod/kube-scheduler-vm2

## Turning off auto-approval of node client certificates
## https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/
# kubectl delete clusterrolebinding kubeadm:node-autoapprove-bootstrap
# kubectl get csr
# kubectl certificate approve node-csr-c69HXe7aYcqkS1bKmH4faEnHAWxn6i2bHZ2mD04jZyQ

# curl -k https://localhost:6443
