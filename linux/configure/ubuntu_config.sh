#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

#### config files
# [ -f ~/.ssh/id_rsa ] || ssh-keygen -P "" -f ~/.ssh/id_rsa
# chmod 400 ~/.ssh/id_rsa

# ssh-keygen -t rsa -b 2048 -m PEM -P "" -C "ubuntu@localhost" -f ~/.ss/kvm.pem
# chmod 0400 ~/.ss/kvm.pem

####
mkdir -p ~/apps/bin ~/.local/bin
cp ./bash_aliases.sh ~/.bash_aliases

####
mkdir -p ~/.config/pip
cp ./pip.conf ~/.config/pip/pip.conf
# python3 -m site

####
mkdir -p ~/.cargo
cp ./cargo.toml ~/.cargo/config.toml

####
mkdir -p ~/.ansible
cp ./ansible_home.cfg ~/.ansible.cfg

####
mkdir -p ~/.julia/config
cp ./julia.jl ~/.julia/config/startup.jl

####
mkdir -p ~/.go ~/.config/go
envsubst > ~/.config/go/env < ./go.env

####
mkdir -p ~/.config/mpv
cp ./mpv.conf ~/.config/mpv/

####
# mkdir -p ~/.config/rustfmt
# cp ./rustfmt.toml ~/.config/rustfmt/

####
cp ./VSCodium.json ~/.config/VSCodium/User/settings.json

####
cp templates/* ~/Templates/

####
mkdir -p ~/apps/npm
cp ./npmrc.conf ~/.npmrc

####
mkdir -p ~/.vim
cp ./vimrc.conf ~/.vimrc

####
cat >> ~/.profile <<'EOF'
echo "==> Welcome $(date +%FT%T.%N:%:z)"
EOF

exit
#### disable ads
sudo systemctl disable ubuntu-advantage
sudo pro config set apt_news=false

####
sudo cp /usr/lib/update-notifier/apt_check.py /usr/lib/update-notifier/apt_check.py.bk

sudo sed -Ezi.orig \
  -e 's/(def _output_esm_service_status.outstream, have_esm_service, service_type.:\n)/\1    return\n/' \
  -e 's/(def _output_esm_package_alert.*?\n.*?\n.:\n)/\1    return\n/' \
  /usr/lib/update-notifier/apt_check.py

sudo /usr/lib/update-notifier/update-motd-updates-available --force

p=/var/lib/ubuntu-advantage/apt-esm/etc/apt/sources.list.d/ubuntu-esm-apps.list
[ -s "$p" ] && sudo sed -i '/^deb/s/^/#-- /' $p

sudo sed -i '/ENABLED/s/1/0/' /etc/default/motd-news
#- sudo sed -i '/=motd.dynamic/s/^/#-- /' /etc/pam.d/sshd

# sudo apt install landscape-common
# landscape-sysinfo

#### install
exit

pip3 install requests pandas toml ansible polars

go install github.com/rs/curlie@latest

cargo install cargo-edit cargo-expand dufs tokei delta ripgrep lsd procs fd-find just

npm install --global gtop serve yarn

# gedit plugins: Code Comment, Embedded Terminal, File Browser Panel
# gedit settings: click View->enable Bottom Panel
# gedit preferences: Disply line numbers, Display right margin at column: 100, Display statusbar,
#   Disaply overview map, Display grid pattern
