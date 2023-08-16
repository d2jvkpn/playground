### Ansible
---

#### 1. Installation
```bash
pip3 install ansible
```

#### 2. settings
- linux
  - using ssh key: machine  ansible_host=192.168.122.2  ansible_port=22 ansible_user=ubuntu
  - root with password: machine ansible_host=192.168.122.2 ansible_port=22 ansible_user=root ansible_password=world ansible_pass=world
  - sudo user with password: machine ansible_host=192.168.122.2  ansible_port=22  ansible_user=ubuntu ansible_pass=world ansible_sudo_pass=world
  - sudo user with private key file: machine ansible_host=192.168.122.2  ansible_port=22 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/kvm.pem
- windows
  - admin user: machine ansible_host=192.168.122.10 ansible_user=admin ansible_password=world ansible_port=5985 ansible_connection=winrm ansible_winrm_transport=ntlm ansible_winrm_server_cert_validation=ignore


#### 3. config files
- hosts (default ~/.ansible/hosts.ini)
```bash
mkdir -p configs

cat > configs/hosts.ini <<EOF
node01 ansible_host=192.168.122.11  ansible_port=22 ansible_user=hello ansible_ssh_private_key_file=~/.ssh/kvm.pem

[kvm]
node01 ansible_host=192.168.122.12 ansible_port=22 ansible_user=hello ansible_ssh_private_key_file=~/.ssh/kvm.pem
node02 ansible_host=192.168.122.13 ansible_port=22 ansible_user=hello ansible_ssh_private_key_file=~/.ssh/kvm.pem
node03 ansible_host=192.168.122.14 ansible_port=22 ansible_user=hello ansible_ssh_private_key_file=~/.ssh/kvm.pem

[windows]
machine ansible_host=192.168.122.10 ansible_user=admin ansible_password=world ansible_port=5985 ansible_connection=winrm ansible_winrm_transport=ntlm ansible_winrm_server_cert_validation=ignore
EOF
```

- ansible config(default ~/.ansible.cfg)
```bash
mkdir -p logs

cat > ansible.cfg <<EOF
inventory = ~/configs/hosts.ini
log_path = $PWD/logs/ansible.log
EOF
```
