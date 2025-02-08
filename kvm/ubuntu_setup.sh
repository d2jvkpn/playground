#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

username=${1:-ubuntu}
time_zone=${time_zone:-Asia/Shanghai}
home_dir=/home/$username

export DEBIAN_FRONTEND=noninteractive
[ $(id -u) -ne 0 ] && { >&2 echo "Please run as root"; exit 1; }

#### 1. sudoers.d/$username
# hostnamectl hostname node
# sed -i '/127.0.1.1/s/ .*/ node/' /etc/hosts

mkdir -p $home_dir/apps/bin $home_dir/apps/exports

if [ ! -f $home_dir/.bash_aliases ]; then

cat > $home_dir/apps/bash_aliases <<'EOF'
export HISTTIMEFORMAT="%Y-%m-%dT%H:%M:%S%z "
# %Y-%m-%dT%H:%M:%S%:z doesn't work
export PROMPT_DIRTRIM=2
# export PATH=~/.local/bin:$PATH

export PATH=~/apps/bin:$PATH

for d in $(ls -d ~/apps/exports/*/ 2> /dev/null); do
    d=${d%/}
    b=$(basename $d)
    #[ "${b:0:1}" == "_" ] && continue
    [ -d $d/bin ] && d=$d/bin
    [ -r $d ] || continue
    export PATH=$d:$PATH
done
EOF

    ln -sr $home_dir/apps/bash_aliases $home_dir/.bash_aliases
    chown -R $username:$username $home_dir/apps $home_dir/.bash_aliases
fi

echo "$username ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/$username
# echo -e "\n\n\nPermitRootLogin yes" >> /etc/ssh/sshd_config

#### 2. disable ads
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

#### reset machine-id and ssh
# rm /etc/machine-id
# dbus-uuidgen --ensure=/etc/machine-id

# rm -v /etc/ssh/ssh_host_*
# dpkg-reconfigure openssh-server --default-priority

# systemctl restart sshd

#### 4. apt install
# update /etc/apt/sources.list
apt update && apt -y upgrade

apt install -y software-properties-common \
  apt-transport-https ca-certificates lsb-release gnupg duf \
  vim tree file pigz jq zip dos2unix \
  curl openvpn net-tools
# landscape-common
# yq, docker-compose

# wget -O Apps/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
# chmod a+x Apps/bin/yq


#### 5. apt remove
apt clean && apt autoclean
apt remove && apt autoremove
dpkg -l | awk '/^rc/{print $2}' | xargs -i sudo dpkg -P {}

apt remove -y --autoremove snapd
dpkg -P snapd
# sudo snap remomve --purge core22
# sudo snap remove --purge snapd
