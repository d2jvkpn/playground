# Kubernetes


#### ch01. K8s Cluster
1. 
```bash
# bash k8s_scripts/k8s_downloads.sh 1.30.2
# ansible k8s_all --list-hosts | awk 'NR>1' | xargs -i virsh start {}

bash step01_base_node.sh k8s-cp01

bash step02_clone_nodes.sh k8s-cp01 k8s-node{01..02}

bash step03_cluster_up.sh
```

2. k8s_tools
- k9s: https://github.com/derailed/k9s

#### ch02. Explore
```bash
ansible k8s_all -m shell -a 'top -n 1'

ansible k8s_cps[0] -m shell -a 'kubectl get node -o wide'
ansible k8s_cps[0] -m shell -a 'kubectl get ep --all-namespaces'

ansible k8s_cps[0] -m shell -a 'kubectl get pods --all-namespaces -o wide'
ansible k8s_cps[0] -m shell -a 'kubectl describe node/k8s-cp01'
```

#### ch03. Upgrade nodes
```bash
version=1.28.x

# control-plane
ansible k8s_cps -m shell \
  -a "sudo bash k8s_scripts/k8s_upgrade_cp.ubuntu.sh $version"

# workers
for node in $(ansible k8s_workers --list-hosts | sed '1d'); do
    ansible k8s_cps[0] -m shell \
      -a "sudo bash k8s_scripts/k8s_upgrade_worker.ubuntu.sh $version $node 1"

    ansible $node -m shell \
      -a "sudo bash k8s_scripts/k8s_upgrade_worker.ubuntu.sh $version $node 2"

    ansible k8s_cps[0] -m shell \
      -a "sudo bash k8s_scripts/k8s_upgrade_worker.ubuntu.sh $version $node 3"
done
```

#### ch04. TODO
- 2024-01-01 StatefulSet
- 2024-12-24 Traefik Ingress
- 2025-01-01 Helm

#### ch05. News
- HAMi
- SkyPilot
- Trainer
- Envoy AI Gateway
- k0s
