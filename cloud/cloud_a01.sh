#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


host=$1

lsb_release -a

sudo ls /etc/sudoers /etc/sudoers.d
# /etc/sudoers.d/90-cloud-init-users
# ubuntu ALL=(ALL) NOPASSWD:ALL

sudo hostnamectl set-hostname --static $host
# edit /etc/hosts

sudo apt remove -y snapd
sudo apt install -y duf docker.io nginx

sudo apt -y autoremove
dpkg -l | grep ^rc | awk '{print $2}' | xargs -i sudo dpkg -P {}

exit

tag=$(tr -dc 'a-z1-9A-Z' </dev/random | fold -w 8 | head -n1)

useradd -m -s /bin/bash ubuntu-$tag
# chsh -s /bin/bash username
usermod -aG sudo ubuntu-$tag
echo "ubuntu-$tag ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/custom

echo -e "Port 2222\nPermitRootLogin no" > /etc/ssh/sshd_config.d/custom.conf
systemctl restart ssh
