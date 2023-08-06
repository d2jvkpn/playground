#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### apt update
# update /etc/apt/sources.list
apt update && apt -y upgrade

apt install -y software-properties-common apt-transport-https ca-certificates \
  vim iftop net-tools gnupg-agent gnupg2 tree pigz curl file
# iotop jq at autossh iputils-ping

apt clean && sudo apt autoclean
apt remove && sudo apt autoremove

# reboot now
# dpkg -l | awk '/^rc/{print $2}' | xargs -i dpkg -P {}

#### 
# hostnamectl hostname kvm
# sed -i '/127.0.1.1/s/ .*/ kvm/' /etc/hosts

timedatectl set-timezone Asia/Shanghai

echo "hello ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/hello 
# echo -e "\n\n\nPermitRootLogin yes" >> /etc/ssh/sshd_config

#### enable virsh Console access, 
systemctl enable serial-getty@ttyS0.service
systemctl start serial-getty@ttyS0.service
# allow longin "virsh console target" from host machine

#### reset machine-id and ssh
# rm /etc/machine-id
# dbus-uuidgen --ensure=/etc/machine-id

# rm -v /etc/ssh/ssh_host_*
# dpkg-reconfigure openssh-server --default-priority

# systemctl restart sshd
