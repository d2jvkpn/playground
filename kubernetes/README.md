# Kubernetes

#### P01. K8s Cluster
```bash
# bash k8s_scripts/k8s_downloads.sh 1.30.2
# ansible k8s_all --list-hosts | awk 'NR>1' | xargs -i virsh start {}

bash step01_base_node.sh k8s-cp{01..03} k8s-node{01..04}

bash step02_cluster_up.sh
```

#### P02. Explore
```bash
ansible k8s_all -m shell -a 'top -n 1'

ansible k8s_cps[0] -m shell -a 'kubectl get node -o wide'
ansible k8s_cps[0] -m shell -a 'kubectl get ep --all-namespaces'

ansible k8s_cps[0] -m shell -a 'kubectl get pods --all-namespaces -o wide'
ansible k8s_cps[0] -m shell -a 'kubectl describe node/k8s-cp01'
```

#### P03. Upgrade nodes
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

#### P04. TODO
- 2024-01-01 StatefulSet
- 2024-12-24 Traefik Ingress
- 2025-01-01 Helm
