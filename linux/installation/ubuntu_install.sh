#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

#### 1. system apps
apt install -y software-properties-common \
  apt-transport-https ca-certificates lsb-release gnupg duf \
  vim tree file pigz jq zip dos2unix gnome-shell-extension-manager \
  curl net-tools btop iftop nmap whois traceroute iotop socat

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

pipx install ipython runlike ansible jupyterlab

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
- dufs: cargo install dufs
- nushell: https://www.nushell.sh/book/installation.html
```bash
curl -fsSL https://apt.fury.io/nushell/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg
echo "deb https://apt.fury.io/nushell/ /" | sudo tee /etc/apt/sources.list.d/fury.list
sudo apt update
sudo apt install nushell

echo "https://alpine.fury.io/nushell/" | tee -a /etc/apk/repositories
apk update
apk add --allow-untrusted nushell
```
EOF

#### 3. desktop apps
cat <<EOF
apps:
- firefox, addons=[Orbit, Privacy Badger]
- librewolf
- codium, url=https://github.com/VSCodium/vscodium/releases
- LocalSend, urls=[https://localsend.org/, https://github.com/localsend/localsend/releases]
EOF

#### 3. alt
cat <<EOF
- protoc-gen-go
- htop
- glances
EOF
