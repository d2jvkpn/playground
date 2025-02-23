#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

#### 1. system apps
apt install -y software-properties-common \
  apt-transport-https ca-certificates lsb-release gnupg duf \
  vim tree file pigz jq zip dos2unix gnome-shell-extension-manager \
  curl net-tools btop iftop nmap

apt install -y \
  make expect git  lm-sensors  \
  python3-venv pipx \
  docker.io ansible-core openvpn \
  postgresql-client-common postgresql-client-16

apt install  fcitx5 fcitx5-pinyin ibus-pinyin \
  mpv qbittorrent libreoffice \
  remmina remmina-plugin-vnc

pipx install ipython runlike ansible

# sydo apt install python3-pip python3-ipython ipython3
# python3 -m venv ~/apps/pyvenv
# source ~/apps/pyvenv/bin/activate
# pip install requests numpy pandas polar scikit-learn pyyaml

#### 2. commandlines
cat <<EOF
apps:
- docker-compose: https://github.com/docker/compose/releases
- yq: https://github.com/mikefarah/yq/releases
- tokei: cargo install tokei
- bat: cargo install bat
- eza: cargo install eza
- rg: cargo install ripgrep
- xsv: cargo install xsv
EOF

#### 3. desktop apps
cat <<EOF
apps:
- firefox, addons=[Orbit, Privacy Badger]
- librewolf
- chrome/chromium, url=https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
- codium
EOF
