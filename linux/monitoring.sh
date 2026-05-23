#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
####
htop

ps aux --sort=-%mem | head -20

####
df -h

sudo du -xh / --max-depth=1 2>/dev/null | sort -h

docker system df
docker system prune

####
sudo iotop

sudo apt install smartmontools
sudo smartctl -a /dev/sda

####
top -p $(pidof gnome-shell)

####
systemd-analyze blame | head -30

systemctl --user list-units --type=service --state=running
systemctl list-units --type=service --state=running

tracker3 status
#systemctl --user mask tracker-miner-fs-3.service
