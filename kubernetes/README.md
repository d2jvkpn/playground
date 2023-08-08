### Kubernetes

#### 1. Prepare
```bash
# bash k8s_scripts/k8s_downloads.sh
# mkdir -p wk_data && mv k8s_apps wk_data/

ansible kvm --one-line -m copy -a "src=wk_data/k8s_apps dest=./"

# ansible kvm --one-line -m file -a "path=./k8s_scripts state=directory"
ansible kvm --one-line -m copy -a "src=k8s_scripts dest=./"
```

#### 2. Installation
```bash
# ansible node01,node02 -m shell -a "sudo bash k8s_scripts/k8s_install.sh 1.27.4"
ansible kvm -m shell -a "sudo bash k8s_scripts/k8s_install.sh 1.27.4"

ansible kvm -m shell -a "sudo bash k8s_scripts/containerd_install.sh"

ansible kvm -m shell -a "sudo bash k8s_scripts/k8s_apps.sh"
```

#### 3. Control Panel nodes
```bash
ansible node01 -m shell -a "sudo bash k8s_scripts/k8s_control-plane.sh k8scp01"
```

#### 4. Worker nodes
```bash
export cp_node_name=k8scp01 cp_node_ip=192.168.122.55 token=tx1h53.b1ghhx5u1b95il13
export cert_hash=sha256:854edd3408cbe0018aba72b772da1f5fe2bd4413a0375f35e59763ecdde91e8c

envsubst > wk_data/00_k8s_worker-node.sh < k8s_scripts/k8s_worker-node.sh
ansible kvm --one-line -m copy -a "src=wk_data/00_k8s_worker-node.sh dest=k8s_scripts/"
ansible node02,node03 -m shell -a "sudo bash k8s_scripts/00_k8s_worker-node.sh"
```

#### 5. Config
```
ansible node01 -m shell -a 'sudo bash k8s_scripts/kube-config.sh $USER'

ansible node01 -m shell -a 'kubectl get componentstatuses'
ansible node01 -m shell -a 'kubectl get node'
ansible node01 -m shell -a 'kubectl get pods --all-namespaces -o wide'

ansible node01 -m shell -a "sudo bash k8s_scripts/kube-flannel.sh"
```
