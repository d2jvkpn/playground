#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname $0`)


#### 1. system apps
apt install -y software-properties-common \
  apt-transport-https ca-certificates lsb-release gnupg duf \
  vim tree file pigz jq zip dos2unix gnome-shell-extension-manager \
  curl net-tools btop iftop nmap whois traceroute iotop socat inotify-tools

apt install -y \
  make expect git lm-sensors \
  python3-venv pipx \
  docker.io ansible-core openvpn \
  imagemagick tldr-hs

apt install  fcitx5 fcitx5-pinyin ibus-pinyin \
  mpv vlc qbittorrent libreoffice gparted \
  remmina remmina-plugin-vnc fbreader okular \
  gedit gedit-plugins

apt install smbclient cifs-utils \
  postgresql-client-common postgresql-client-16

# https://extensions.gnome.org/extension/261/kimpanel/
# Input Method Panel using KDE's kimpanel protocol for Gnome-Shell
