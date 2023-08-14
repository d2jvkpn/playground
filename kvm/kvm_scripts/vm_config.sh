#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

export DEBIAN_FRONTEND=noninteractive

#### config
# hostnamectl hostname node
# sed -i '/127.0.1.1/s/ .*/ node/' /etc/hosts

# root: bash vm_config.sh ubuntu
username=$1

# mkdir -p /home/$username/Apps/bin

mkdir -p ~/Apps/bin

cat > ~/.bash_aliases <<'EOF'
for d in $(ls -d ~/Apps/*/ 2>/dev/null); do
    d=${d%/}
    [ -d $d/bin ] && d=$d/bin
    export PATH=$d:$PATH
done

for d in $(ls -d /opt/*/ 2> /dev/null); do
    d=${d%/}
    [[ -d $d/bin ]] && d=$d/bin
    export PATH=$d:$PATH
done
EOF

chown -R $username:$username /home/$username

timedatectl set-timezone Asia/Shanghai

echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu
# echo -e "\n\n\nPermitRootLogin yes" >> /etc/ssh/sshd_config

#### apt update
# update /etc/apt/sources.list

apt update && apt -y upgrade

apt install -y software-properties-common apt-transport-https ca-certificates \
  vim net-tools tree pigz curl file
# iftop iotop jq at autossh iputils-ping gnupg-agent gnupg2

apt clean && apt autoclean
apt remove && apt autoremove

# reboot now
# dpkg -l | awk '/^rc/{print $2}' | xargs -i dpkg -P {}

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
