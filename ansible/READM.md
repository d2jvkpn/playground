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
- cat ~/.ansible/hosts.ini
```ini
node01 ansible_host=192.168.122.2  ansible_port=22 ansible_user=hello

[kvm]
node01 ansible_host=192.168.122.2 ansible_port=22 ansible_user=hello
node02 ansible_host=192.168.122.3 ansible_port=22 ansible_user=hello
node03 ansible_host=192.168.122.4 ansible_port=22 ansible_user=hello

[windows]
machine ansible_host=192.168.122.10 ansible_user=admin ansible_password=world ansible_port=5985 ansible_connection=winrm ansible_winrm_transport=ntlm ansible_winrm_server_cert_validation=ignore
```

- cat ~/.ansible.cfg
```ini
inventory = ~/.ansible/hosts.ini
log_path = $PWD/ansible.log
```
