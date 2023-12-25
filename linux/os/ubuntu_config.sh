#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

#### config files
# [ -f ~/.ssh/id_rsa ] || ssh-keygen -P "" -f ~/.ssh/id_rsa
# chmod 400 ~/.ssh/id_rsa

# ssh-keygen -t rsa -b 2048 -m PEM -P "" -C "ubuntu@localhost" -f ~/.ss/kvm.pem
# chmod 0400 ~/.ss/kvm.pem

####
mkdir -p ~/Apps/bin ~/.local/bin
cp user_configs/bash_aliases.sh ~/.bash_aliases

####
mkdir -p ~/.config/pip
cp user_configs/pip.conf ~/.config/pip/pip.conf
# python3 -m site

####
mkdir -p ~/.cargo
cp user_configs/cargo.conf ~/.cargo/config

####
mkdir -p ~/.ansible
cp user_configs/ansible_home.cfg ~/.ansible.cfg

####
mkdir -p ~/.julia/config
cp user_configs/julia.jl ~/.julia/config/startup.jl

####
mkdir -p ~/.go ~/.config/go
envsubst > ~/.config/go/env < user_configs/go.env

####
mkdir -p ~/.config/mpv
cp user_configs/mpv.conf ~/.config/mpv/

####
cp templates/* ~/Templates/

####
mkdir -p ~/Apps/npm
cp user_configs/npm.conf ~/.npmrc

####
mkdir -p ~/.vim
cp user_configs/vimrc.conf ~/.vimrc

####
cat >> ~/.profile <<'EOF'
echo "==> Welcome $(date +%FT%T.%N:%:z)"
EOF

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
