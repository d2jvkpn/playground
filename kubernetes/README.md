### Kubernetes

#### 1. Prepare
```bash
# bash k8s_scripts/k8s_apps_downloads.sh
# mkdir -p wk_data && mv k8s_apps wk_data/
# ansible k8s_all --list-hosts | awk 'NR>1' | xargs -i virsh start {}

ansible k8s_all --one-line -m ping
# ansible k8s_all[0] --one-line -m ping
# ansible k8s_all[1:] --one-line -m ping
# ansible k8s_all --one-line -m debug
# ansible k8s_all[0] --list-hosts

ansible k8s_all --one-line -m shell -a 'echo "Hello, world!"'

ansible k8s_all --one-line -m copy -a "src=k8s_scripts dest=./"

ansible k8s_all --forks 2 --one-line -m copy -a "src=wk_data/k8s_apps dest=./"

# ansible k8s_all --one-line -m file -a "path=./k8s_scripts state=directory"
```

#### 2. Installation
```bash
ansible k8s_all -m shell -a "sudo swapoff --all && sudo rm -f /swap.img"
ansible k8s_all -m shell -a "sudo sed -i '/swap/s/^/# /' /etc/fstab"

ansible k8s_all --forks 2 -m shell -a "sudo bash k8s_scripts/k8s_node_install.sh 1.28.0"
# ?? sysctl: setting key "net.ipv4.conf.all.accept_source_route": Invalid argument
# ?? sysctl: setting key "net.ipv4.conf.all.promote_secondaries": Invalid argument

ansible k8s_all --forks 2 -m shell -a "sudo bash k8s_scripts/k8s_apps_containerd.sh"

ansible k8s_all --forks 2 -m shell -a "sudo bash k8s_scripts/k8s_apps_install.sh"
```

#### 3. Control Panel nodes
```bash
node=$(ansible-inventory --list --yaml | yq '.all.children.k8s_cps.hosts | keys | .[0]')
# node=$(ansible k8s_cps[0] --list-hosts | awk 'NR==2{print $1; exit}')
# cp_node=$(echo $node | sed 's/[a-z]*/k8s/')
cp_node=k8s$node
cp_ip=$(ansible-inventory --list --yaml | yq ".all.children.k8s_all.hosts.$node.ansible_host")

ansible $node -m shell -a "sudo bash k8s_scripts/k8s_node_control-plane.sh $cp_node"
# ansible $node -m shell -a "sudo kubeadm reset -f"

ansible $node --one-line -m fetch -a "flat=true src=kubeadm-init.yaml dest=wk_data/"

ansible $node -m shell -a 'sudo bash k8s_scripts/kube_copy_config.sh $USER'
# ansible node01 -m shell -a "cat kubeadm-init.out"

ansible $node -m shell -a "bash k8s_scripts/kube_apply_flannel.sh"
ansible $node -m shell -a "bash k8s_scripts/kube_apply_ingress-nginx.sh"
```

#### 4. Other nodes
```bash
# worker nodes
ansible k8s_workers --one-line -m copy -a "src=wk_data/kubeadm-init.yaml dest=./"
ansible k8s_workers -m shell -a "sudo bash k8s_scripts/k8s_node_join.sh worker"

# other control-plane nodes
ansible k8s_cps[1:] --one-line -m copy -a "src=wk_data/kubeadm-init.yaml dest=./"
ansible k8s_cps[1:] -m shell -a "sudo bash k8s_scripts/k8s_node_join.sh control-plane"
ansible k8s_cps[1:] -m shell -a 'sudo bash k8s_scripts/kube_copy_config.sh $USER'

# remove kubeadm-init.yaml
ansible k8s_workers,k8s_cps[1:] -m shell -a "rm -f kubeadm-init.yaml"
```

#### 5. Storage
```bash
node=$(ansible k8s_cps[0] --list-hosts | awk 'NR==2{print $1; exit}')
cp_node=k8s$node

ansible $node -m shell -a "bash k8s_scripts/kube_storage-nfs.sh $cp_node 10Gi"
```

#### 6. Config
```bash
ansible k8s_cp -m shell -a 'kubectl get pods --all-namespaces -o wide'
ansible k8s_cp -m shell -a 'kubectl get componentstatuses'
ansible k8s_cp -m shell -a 'kubectl get node'
ansible k8s_cp -m shell -a 'kubectl describe node/k8scp01'
```
