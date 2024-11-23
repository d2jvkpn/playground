#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


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


exit
# aliyun: aegis, aliyun, AssistDaemon
# path: /usr/local/share/assist-daemon/assist_daemon
systemctl stop AssistDaemon
systemctl disable AssistDaemon

# /usr/local/share/aliyun-assist
systemctl stop aliyun
systemctl disable aliyun

# /usr/local/aegis
systemctl stop aegis
# !!! can't disable this service
systemctl disable aegis
mv /etc/systemd/system/aegis.service /etc/systemd/system/aegis.service.bk

for s in pmcd pmie pmie_farm pmlogger pmlogger_farm pmproxy; do
    systemctl stop $s
    systemctl disable $s
done


exit
# tencent cloud
# barad_agent YDLive
# systemctl stop cron
# systemctl disable cron

systemctl stop tat_agent
systemctl disable tat_agent
# /usr/local/qcloud/tat_agent/tat_agent
