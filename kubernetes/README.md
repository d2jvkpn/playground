### Kubernetes

#### 1. Prepare
```bash
# bash k8s_scripts/k8s_apps_downloads.sh

ansible k8s_all --list-hosts | awk 'NR>1' | xargs -i virsh start {}

while ! ansible k8s_all --one-line -m shell -a 'echo "Hello, world!"'; do
    echo -e "." && sleep 1
done
echo ""

# ansible k8s_all --one-line -m ping
# ansible k8s_all[0] --one-line -m ping
# ansible k8s_all[1:] --one-line -m ping
# ansible k8s_all --one-line -m debug
# ansible k8s_all[0] --list-hosts

ansible k8s_all --one-line -m copy -a "src=k8s_scripts dest=./"
ansible k8s_all --forks 2 -m copy -a "src=./k8s_apps dest=./"

ansible k8s_all -m shell --become \
  -a "swapoff --all && sed -i '/swap/d' /etc/fstab && rm -f /swap.img"
```

#### 2. Installation
```bash
version=1.28.1
ansible k8s_all -m shell -a "sudo bash k8s_scripts/k8s_node_install.sh $version"
# ?? sysctl: setting key "net.ipv4.conf.all.accept_source_route": Invalid argument
# ?? sysctl: setting key "net.ipv4.conf.all.promote_secondaries": Invalid argument

ansible k8s_all -m shell -a "sudo bash k8s_scripts/k8s_apps_containerd.sh"

ansible k8s_all --forks 4 -m shell \
  -a "sudo import_local_image=true bash k8s_scripts/k8s_apps_install.sh"
```

#### 3. Control Panel nodes
```bash
# cp_node=k8s-cp01
# cp_node=$(ansible k8s_cps[0] --list-hosts | awk 'NR==2{print $1; exit}')
cp_node=$(ansible-inventory --list --yaml | yq '.all.children.k8s_cps.hosts | keys | .[0]')
cp_ip=$(ansible-inventory --list --yaml | yq ".all.children.k8s_all.hosts.$cp_node.ansible_host")

sed "1i \\\n$cp_ip k8s-control-plane" configs/hosts.txt > ./k8s_data/hosts.txt
ansible k8s_all -m file -a "path=./k8s_data state=directory"
ansible k8s_all -m copy --become -a "src=./k8s_data/hosts.txt dest=./k8s_data/"
ansible k8s_all -m shell --become -a "cat ./k8s_data/hosts.txt >> /etc/hosts"

ansible $cp_node -m shell -a "sudo bash k8s_scripts/k8s_node_cp.sh k8s-control-plane:6443"
# ansible $cp_node -m shell -a "sudo kubeadm reset -f"

ansible $cp_node --one-line -m fetch -a "flat=true src=k8s_data/kubeadm-init.yaml dest=k8s_data/"

sed -i "1i cp_ip: $cp_ip" k8s_data/kubeadm-init.yaml

ansible $cp_node -m shell -a 'sudo bash k8s_scripts/kube_copy_config.sh root $USER'
```

#### 4. Worker nodes
```bash
# worker nodes
ansible k8s_workers -m shell -a "sudo $(bash k8s_scripts/k8s_join_command.sh worker)"

# other control-plane nodes
ansible k8s_cps[1:] -m shell -a "sudo $(bash k8s_scripts/k8s_join_command.sh control-plane)"
ansible k8s_cps[1:] -m shell -a 'sudo bash k8s_scripts/kube_copy_config.sh root $USER'
```

#### 5. Apply flannel and ingress-nginx
```bash
ingress_node=k8s-ingress01

ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_apply_flannel.sh"
ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_apply_ingress-nginx.sh $ingress_node"
```

#### 6. Storage
```bash
ansible $cp_node -m shell -a "sudo bash k8s_scripts/kube_storage_nfs.sh $cp_node 10Gi"
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
    ansible $node -m shell -a "sudo bash k8s_scripts/k8s_upgrade_cp.sh $version $node"
done

# workers
for node in $(ansible workers --list-hosts | sed '1d'); do
    ansible k8s_cps[0] -m shell -a "sudo bash k8s_scripts/k8s_upgrade_worker.sh $version $node 1"
    ansible $node -m shell -a "sudo bash k8s_scripts/k8s_upgrade_worker.sh $version $node 2"
    ansible k8s_cps[0] -m shell -a "sudo bash k8s_scripts/k8s_upgrade_worker.sh $version $node 3"
done
```
