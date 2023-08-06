### Install Virtual Machines
---

#### 1. install kvm
```bash
grep -Eoc '(vmx|svm)' /proc/cpuinfo
sudo apt install cpu-checker

sudo apt install qemu-system-x86 libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager

systemctl is-active libvirtd
usermod -aG libvirt $USER
usermod -aG kvm $USER
brctl show
```

#### 2. create virtual machine
```bash
name=ubuntu

virt-install --name=$name \
  --os-variant=generic --vcpus=2 --memory=2048 \
  --disk path=/var/lib/libvirt/images/$name.qcow2,size=30 \
  --cdrom=~/kvm/ubuntu-22.04.1-live-server-amd64.iso
```

#### 3. ubuntu installation UI
...username: hello
```bash
hostnamectl hostname kvm
sed -i '/127.0.1.1/s/ .*/ kvm/' /etc/hosts
```

#### 4. ssh virtual machine
```bash
virsh start $name
virsh net-list
virsh net-dhcp-leases default
# rm /var/lib/libvirt/dnsmasq/virbr0.*

addr=$(virsh domifaddr $name | awk '$1!=""{split($NF, a, "/"); addr=a[1]} END{print addr}')
ssh hello@$addr

# update /etc/apt/sources.list
sudo apt update && apt -y upgrade

sudo apt install -y software-properties-common apt-transport-https ca-certificates \
  vim iftop net-tools gnupg-agent gnupg2 tree pigz curl file

# iotop jq at autossh iputils-ping

sudo timedatectl set-timezone Asia/Shanghai

sudo apt clean && sudo apt autoclean
sudo apt remove && sudo apt autoremove

sudo echo "hello ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/hello 
# echo -e "\n\n\nPermitRootLogin yes" >> /etc/ssh/sshd_config

# systemctl restart ssh
# passwd
```

#### 5. fix ip of virtual machine
```bash
bash scripts/virsh_fix_ip.sh $name
```

#### 6. ssh virtal machine from host without password
```bash
name=ubuntu; user=hello

ssh-keygen -t rsa -m PEM -b 2048 -P "" -f ~/.ssh/kvm.pem -C 'ubuntu'
chmod 0600 ~/.ssh/kvm.pem

addr=$(virsh domifaddr $name | awk '$1!=""{split($NF, a, "/"); addr=a[1]} END{print addr}')
ssh-keyscan -H $addr >> ~/.ssh/known_hosts

cat >> ~/.ssh/config << EOF
Host $name
    HostName      $addr
    User          hello
    Port          22
    LogLevel      INFO
    Compression   yes
    IdentityFile  ~/.ssh/kvm.pem
EOF

ssh-copy-id -i ~/.ssh/kvm.pem $name
# ssh $name
```

#### 7. clone ubuntu
```bash
bash scripts/virsh_clone.sh ubuntu node01 hello

bash scripts/virsh_clone.sh ubuntu node02 hello

bash scripts/virsh_clone.sh ubuntu node03 hello
```
