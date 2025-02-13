#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


#### 1. system apps
apt install -y software-properties-common \
  apt-transport-https ca-certificates lsb-release gnupg duf \
  vim tree file pigz jq zip dos2unix gnome-shell-extension-manager \
  curl net-tools btop iftop nmap

apt install -y \
  make  expect git  lm-sensors \
  python3-venv python3-ipython ipython3 pipx \
  docker.io ansible-core openvpn \
  postgresql-client-common postgresql-client-16

apt install  fcitx5 fcitx5-pinyin mpv \
  qbittorrent remmina remmina-plugin-vnc  libreoffice

# python3-pip
# python3 -m venv ~/apps/pyvenv
# pip install requests numpy pandas polar

#### 2. desktop apps
cat <<EOF
apps:
- firefox
- librewolf
- chrome/chromium
  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
EOF

#### 3. commandlines
cat <<EOF
apps:
- docker-compose
- yq
EOF
