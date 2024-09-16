#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

username=${1:-ubuntu}
time_zone=${time_zone:-Asia/Shanghai}

export DEBIAN_FRONTEND=noninteractive
[ $(id -u) -ne 0 ] && { >&2 echo "Please run as root"; exit 1; }

#### 1. sudoers.d/$username
# hostnamectl hostname node
# sed -i '/127.0.1.1/s/ .*/ node/' /etc/hosts

mkdir -p /home/$username/Apps/bin

cat >> /home/$username/.bash_aliases <<'EOF'
export HISTTIMEFORMAT="%Y-%m-%dT%H:%M:%S%z "
# %Y-%m-%dT%H:%M:%S%:z doesn't work
export PROMPT_DIRTRIM=2
# export PATH=~/.local/bin:$PATH

for d in $(ls -d ~/Apps/*/ /opt/*/ 2>/dev/null); do
    d=${d%/}
    [ -d $d/bin ] && d=$d/bin
    export PATH=$d:$PATH
done
EOF

chown -R $username:$username /home/$username/.bash_aliases /home/$username/Apps

echo "$username ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/$username
# echo -e "\n\n\nPermitRootLogin yes" >> /etc/ssh/sshd_config

#### 2. disable ubuntu ads
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

[ -s /etc/default/motd-news ] && sed -i '/ENABLED/s/1/0/' /etc/default/motd-news
#- sudo sed -i '/=motd.dynamic/s/^/#-- /' /etc/pam.d/sshd

#### 3. setup
timedatectl set-timezone $time_zone
systemctl enable serial-getty@ttyS0.service
systemctl start serial-getty@ttyS0.service
# allow longin "virsh console target" from host machine

#### 4. apt update
# update /etc/apt/sources.list
apt update
apt -y upgrade

apt install -y software-properties-common apt-transport-https ca-certificates \
  lsb-release gnupg net-tools vim tree file pigz curl jq zip duf
# landscape-common

# wget -O Apps/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
# chmod a+x Apps/bin/yq

apt remove -y --autoremove snapd
dpkg -P snapd
