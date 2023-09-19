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
cp configs/bash.sh ~/.bash_aliases

####
mkdir -p ~/.config/pip
cp configs/pip.conf ~/.config/pip/pip.conf
# python3 -m site

####
mkdir -p ~/.cargo
cp configs/cargo.conf ~/.cargo/config

####
mkdir -p ~/.ansible
cp configs/ansible_home.cfg ~/.ansible.cfg

####
mkdir -p ~/.julia/config
cp configs/julia.jl ~/.julia/config/startup.jl

####
mkdir -p ~/.go ~/.config/go
envsubst > ~/.config/go/env < configs/go.env

####
cp templates/* ~/Templates/

####
mkdir -p ~/Apps/npm
cp configs/npm.conf ~/.npmrc

#### install
exit

pip3 install requests pandas toml ansible polars

go install github.com/rs/curlie@latest

cargo install cargo-edit cargo-expand dufs tokei delta ripgrep lsd procs fd-find just

npm install --global gtop serve yarn
