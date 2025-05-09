#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname $0`)


#### 1. system apps
apt remove -y snapd orca

apt install -y software-properties-common apt-transport-https ca-certificates \
  lsb-release gnome-shell-extension-manager lm-sensors \
  gnupg duf vim tree file pigz jq zip dos2unix  \
  curl net-tools btop iftop nmap whois traceroute iotop socat inotify-tools

apt install -y \
  make expect git\
  python3-venv pipx \
  docker.io ansible-core openvpn wireguard wireguard-tools \
  imagemagick tldr-hs

apt install  fcitx5 fcitx5-pinyin ibus-pinyin \
  mpv vlc qbittorrent libreoffice gparted \
  remmina remmina-plugin-vnc fbreader okular \
  gedit gedit-plugins

apt install smbclient cifs-utils \
  postgresql-client-common postgresql-client-16

# https://extensions.gnome.org/extension/261/kimpanel/
# Input Method Panel using KDE's kimpanel protocol for Gnome-Shell
