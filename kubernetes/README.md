### Kubernetes

#### 1. Prepare
```bash
# bash k8s_scripts/k8s_apps_downloads.sh
# ansible k8s_all --list-hosts | awk 'NR>1' | xargs -i virsh start {}

ansible k8s_all --one-line -m shell -a 'echo "Hello, world!"'
# ansible k8s_all --one-line -m ping
# ansible k8s_all[0] --one-line -m ping
# ansible k8s_all[1:] --one-line -m ping
# ansible k8s_all --one-line -m debug
# ansible k8s_all[0] --list-hosts

ansible k8s_all --one-line -m copy -a "src=k8s_scripts dest=./"
ansible k8s_all --forks 4 --one-line -m copy -a "src=./k8s_apps dest=./"

ansible k8s_all -m file -a "path=./k8s_data state=directory"
ansible k8s_all -m copy --become -a "src=./configs/hosts.txt dest=./k8s_data/"
ansible k8s_all -m shell --become -a "sed '1i \\n# kvm nodes' ./k8s_data/hosts.txt >> /etc/hosts"

# free -m
# ls /swap.img
ansible k8s_all -m shell -a "sudo swapoff --all && sudo sed -i '/swap/s/^/# /' /etc/fstab"
```

#### 2. Installation
```bash
version=1.28.1
ansible k8s_all --forks 4 -m shell -a "sudo bash k8s_scripts/k8s_node_install.sh $version"

# ?? sysctl: setting key "net.ipv4.conf.all.accept_source_route": Invalid argument
# ?? sysctl: setting key "net.ipv4.conf.all.promote_secondaries": Invalid argument

ansible k8s_all --forks 4 -m shell -a "sudo bash k8s_scripts/k8s_apps_containerd.sh"

ansible k8s_all --forks 4 -m shell -a "sudo bash k8s_scripts/k8s_apps_install.sh"
```

#### 3. Control Panel nodes
```bash
# node=k8s-cp01
node=$(ansible-inventory --list --yaml | yq '.all.children.k8s_cps.hosts | keys | .[0]')
# node=$(ansible k8s_cps[0] --list-hosts | awk 'NR==2{print $1; exit}')
# cp_node=$(echo $node | sed 's/[a-z]*/k8s/')
cp_node=${node#k8s-}
cp_ip=$(ansible-inventory --list --yaml | yq ".all.children.k8s_all.hosts.$node.ansible_host")

ansible $node -m shell -a "sudo bash k8s_scripts/k8s_node_control-plane.sh $cp_node $cp_ip"
# ansible $node -m shell -a "sudo kubeadm reset -f"

ansible $node --one-line -m fetch -a "flat=true src=k8s_data/kubeadm-init.yaml dest=k8s_data/"

ansible $node -m shell -a 'sudo bash k8s_scripts/kube_copy_config.sh root $USER'
# ansible node01 -m shell -a "cat kubeadm-init.out"
```

#### 4. Worker nodes
```bash
# worker nodes
ansible k8s_workers --one-line -m copy -a "src=k8s_data/kubeadm-init.yaml dest=./"
ansible k8s_workers -m shell -a "sudo bash k8s_scripts/k8s_node_join.sh worker"
ansible k8s_workers -m file -a "path=kubeadm-init.yaml state=absent"

# other control-plane nodes
ansible k8s_cps[1:] --one-line -m copy -a "src=k8s_data/kubeadm-init.yaml dest=./"
ansible k8s_cps[1:] -m shell -a "sudo bash k8s_scripts/k8s_node_join.sh control-plane"
ansible k8s_cps[1:] -m shell -a 'sudo bash k8s_scripts/kube_copy_config.sh root $USER'
ansible k8s_cps[1:] -m file -a "path=kubeadm-init.yaml state=absent"

# remove kubeadm-init.yaml
# ansible k8s_workers,k8s_cps[1:] -m shell -a "rm -f kubeadm-init.yaml"
```

#### 5. Apply flannel and ingress-nginx
```bash
node=$(ansible-inventory --list --yaml | yq '.all.children.k8s_cps.hosts | keys | .[0]')

# ingress_node=$(ansible k8s_workers[0] --list-hosts | awk 'NR==2{print $1}')
ingress_node=k8s-ingress01

ansible $node -m shell -a "sudo bash k8s_scripts/kube_apply_flannel.sh"
ansible $node -m shell -a "sudo bash k8s_scripts/kube_apply_ingress-nginx.sh $ingress_node"
```

#### 6. Storage
```bash
node=$(ansible k8s_cps[0] --list-hosts | awk 'NR==2{print $1; exit}')
cp_node=${node#k8s-}

ansible $node -m shell -a "sudo bash k8s_scripts/kube_storage_nfs.sh $cp_node 10Gi"
```

#### 7. Explore
```bash
ansible k8s_all -m shell -a 'top -n 1'

ansible k8s_cps[0] -m shell -a 'kubectl get node -o wide'
ansible k8s_cps[0] -m shell -a 'kubectl get ep --all-namespaces'

ansible k8s_cps[0] -m shell -a 'kubectl get pods --all-namespaces -o wide'
ansible k8s_cps[0] -m shell -a 'kubectl get componentstatuses'
ansible k8s_cps[0] -m shell -a 'kubectl describe node/k8s-cp01'
```

#### 8. Upgrade nodes
```bash
version=1.28.x

# control-plane
for node in $(ansible k8s_cps --list-hosts | sed '1d'); do
    ansible $node -m shell -a "sudo bash k8s_scripts/k8s_upgrade_control-plane.sh $version $node"
done

# workers
for node in $(ansible workers --list-hosts | sed '1d'); do
    ansible k8s_cps[0] -m shell -a "sudo bash k8s_scripts/k8s_upgrade_workers.sh $version $node 1"
    ansible $node -m shell -a "sudo bash k8s_scripts/k8s_upgrade_workers.sh $version $node 2"
    ansible k8s_cps[0] -m shell -a "sudo bash k8s_scripts/k8s_upgrade_workers.sh $version $node 3"
done
```
