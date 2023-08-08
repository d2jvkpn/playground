### Ansible K8S

#### 1. Prepare
```bash
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
