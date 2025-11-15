#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname $0`)


#### 1. system apps
apt remove -y snapd orca

apt install -y software-properties-common apt-transport-https ca-certificates \
  lsb-release lm-sensors \
  gnupg duf vim tree file pigz jq zip dos2unix  \
  curl net-tools btop iftop nmap whois traceroute iotop socat inotify-tools

apt install -y \
  make expect git git-lfs python3-venv  \
  docker.io openvpn wireguard wireguard-tools \
  tldr-hs sqlite3 uuid

git lfs install

# gnome-shell-extension-manager
# imagemagick pipx ansible-core

apt install  fcitx5 fcitx5-pinyin ibus-pinyin \
  mpv vlc qbittorrent libreoffice gparted \
  remmina remmina-plugin-vnc fbreader okular \
  gedit gedit-plugins

exit 0
apt install smbclient cifs-utils \
  postgresql-client-common postgresql-client-16 \
  ibus ibus-pinyin ibus-libpinyin ibus-setup

# https://extensions.gnome.org/extension/261/kimpanel/
# Input Method Panel using KDE's kimpanel protocol for Gnome-Shell
