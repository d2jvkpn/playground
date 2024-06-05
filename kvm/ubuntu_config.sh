#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

username=$1

export DEBIAN_FRONTEND=noninteractive
[ $(id -u) -ne 0 ] && { >&2 echo "Please run as root"; exit 1; }

#### 1. disable ads
systemctl disable ubuntu-advantage
pro config set apt_news=false

fp=/usr/lib/update-notifier/apt_check.py
if [[ -s $fp && ! -s $fp.bk ]]; then
    cp $fp $fp.bk

    sed -Ezi.orig \
      -e 's/(def _output_esm_service_status.outstream, have_esm_service, service_type.:\n)/\1    return\n/' \
      -e 's/(def _output_esm_package_alert.*?\n.*?\n.:\n)/\1    return\n/' \
      $fp
fi

/usr/lib/update-notifier/update-motd-updates-available --force

fp=/var/lib/ubuntu-advantage/apt-esm/etc/apt/sources.list.d/ubuntu-esm-apps.list
[ -s $fp ] && sed -i '/^deb/s/^/#-- /' $fp

sed -i '/ENABLED/s/1/0/' /etc/default/motd-news
#- sudo sed -i '/=motd.dynamic/s/^/#-- /' /etc/pam.d/sshd

#### 2. setup
timedatectl set-timezone Asia/Shanghai
systemctl enable serial-getty@ttyS0.service
systemctl start serial-getty@ttyS0.service
# allow longin "virsh console target" from host machine

#### 3. apt update
# update /etc/apt/sources.list
apt update && apt -y upgrade

apt install -y software-properties-common apt-transport-https ca-certificates \
  lsb-release gnupg net-tools vim tree file pigz curl jq zip duf
# landscape-common

apt clean
apt autoclean
apt remove
apt autoremove
dpkg -l | awk '/^rc/{print $2}' | xargs -i sudo dpkg -P {}

apt remove --autoremove snapd
dpkg -P snapd
# reboot now

#### 4. config
# hostnamectl hostname node
# sed -i '/127.0.1.1/s/ .*/ node/' /etc/hosts
mkdir -p /home/$username/Apps/bin /home/$username/.local/bin

# path: ~/.bash_aliases
cat >> /home/$username/.bash_aliases <<'EOF'

export HISTTIMEFORMAT="%Y-%m-%dT%H:%M:%S%z "
# %Y-%m-%dT%H:%M:%S%:z doesn't work
export PROMPT_DIRTRIM=2
export PATH=~/.local/bin:$PATH

for d in $(ls -d ~/Apps/*/ /opt/*/ 2>/dev/null); do
    d=${d%/}
    [ -d $d/bin ] && d=$d/bin
    export PATH=$d:$PATH
done
EOF

chown -R $username:$username /home/$username

echo "$username ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/$username
# echo -e "\n\n\nPermitRootLogin yes" >> /etc/ssh/sshd_config

exit 0
snap list
sudo snap remomve --purge core22
sudo snap remove --purge snapd
