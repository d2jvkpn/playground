#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit

#### 1. 停止并删除 snapd 服务
sudo systemctl stop snapd
sudo systemctl disable snapd
sudo systemctl mask snapd


#### 2. 删除所有 snap 包, 删除 snapd 本体
snap list
sudo snap remove <package>
sudo apt purge snapd


#### 3. 删除残留目录（loop 挂载点、缓存）
sudo rm -rf ~/snap /snap /var/snap /var/lib/snapd

#### 4. alternatives
sudo add-apt-repository ppa:mozillateam/ppa
sudo apt install firefox

# 并阻止 Ubuntu 自己偷偷装回 snap 版：
echo '
Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozillateam

sudo apt install flatpak
flatpak install flathub org.chromium.Chromium

sudo apt install flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
