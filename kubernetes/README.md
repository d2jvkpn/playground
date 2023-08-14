### Kubernetes

#### 1. Prepare
```bash
# bash k8s_scripts/k8s_app_downloads.sh
# mkdir -p wk_data && mv k8s_apps wk_data/

ansible k8s_all --one-line -m ping
ansible k8s_all --one-line -m shell -a 'echo "Hello, world!"'

ansible k8s_all --one-line -m copy -a "src=wk_data/k8s_apps dest=./"

ansible k8s_all --one-line -m copy -a "src=k8s_scripts dest=./"

# ansible k8s_all --one-line -m file -a "path=./k8s_scripts state=directory"
```

#### 2. Installation
```bash
ansible k8s_all -m shell -a "sudo bash k8s_scripts/k8s_node_install.sh 1.27.4"
# ?? sysctl: setting key "net.ipv4.conf.all.accept_source_route": Invalid argument
# ?? sysctl: setting key "net.ipv4.conf.all.promote_secondaries": Invalid argument

ansible k8s_all -m shell -a "sudo bash k8s_scripts/k8s_app_containerd.sh"

ansible k8s_all -m shell -a "sudo bash k8s_scripts/k8s_apps_install.sh"

ansible k8s_all -m shell -a "sudo swapoff --all"
# ansible k8s_all -m shell -a "sudo sed -i '/swap/s/^/# /' /etc/fstab"
```

#### 3. Control Panel nodes
```bash
cp_node=node01

ansible $cp_node -m shell -a "sudo bash k8s_scripts/k8s_node_control-plane.sh k8scp01"
# ansible $cp_node -m shell -a "sudo kubeadm reset -f"

ansible $cp_node --one-line -m fetch -a "src=kubeadm-init.yaml dest=wk_data/"

cp wk_data/node01/kubeadm-init.yaml wk_data/k8s_control-plane_join.yaml
grep -v cert_key wk_data/node01/kubeadm-init.yaml wk_data/k8s_worker_join.yaml

ansible $cp_node -m shell -a 'sudo bash k8s_scripts/kube_copy_config.sh $USER'
# ansible node01 -m shell -a "cat kubeadm-init.out"

ansible $cp_node -m shell -a "bash k8s_scripts/kube_apply_flannel.sh"
ansible $cp_node -m shell -a "bash k8s_scripts/kube_apply_ingress-nginx.sh"
```

#### 4. Other nodes
```bash
ansible k8s_all --one-line -m copy -a "src=wk_data/k8s_worker_join.yaml dest=./"
ansible k8s_workers -m shell -a "bash k8s_scripts/k8s_node.sh worker"

ansible k8s_all --one-line -m copy -a "src=wk_data/k8s_control-plane_join.yaml dest=./"
ansible node02,node03 -m shell -a "sudo bash k8s_scripts/k8s_node_join.sh control-plane"
ansible node02,node03 -m shell -a 'sudo bash k8s_scripts/kube-copy.sh $USER'
```

#### 5. Storage
```bash
ansible node01 -m shell -a "bash k8s_scripts/kube_storage-nfs.sh k8scp01 10Gi"
```

#### 6. Config
```bash
ansible k8s_cp -m shell -a 'kubectl get pods --all-namespaces -o wide'
ansible k8s_cp -m shell -a 'kubectl get componentstatuses'
ansible k8s_cp -m shell -a 'kubectl get node'
ansible k8s_cp -m shell -a 'kubectl describe node/k8scp01'
```
