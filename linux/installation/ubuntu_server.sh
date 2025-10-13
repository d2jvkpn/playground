#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

#### 1. 
export DEBIAN_FRONTEND=nointeractive

sudo apt udpate
sudo apt -y upgrade

sudo apt install -y apt-transport-https ca-certificates \
    iftop net-tools zip tree duf pigz uuid make nmap \
    docker.io docker-compose-v2

timedatectl set-timezone Asia/Shanghai

#### 2. wifi
sudo apt install network-manager

sudo nmtui

sudo nmcli dev wifi list
nmcli con show
nmcli connection show --active

sudo nmcli dev wifi connect "SSID" password "PASSWORD"
sudo nmcli connection modify "SSID" connection.autoconnect yes

#### 3. misc
exit
dd if=/dev/zero of=./test.tmp bs=1G count=1 oflag=direct
