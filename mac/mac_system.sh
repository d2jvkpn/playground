#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit

## enable sshd
sudo systemsetup -setremotelogin on
sudo systemsetup -setremotelogin off
sudo systemsetup -getremotelogin

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bk

sudo sh -c "cat <<'EOF' >> /etc/ssh/sshd_config

PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
EOF"

sudo systemsetup -setremotelogin off
sudo systemsetup -setremotelogin on

ps aux | grep sshd

## upgrade bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew resintall bash

eval "$(/opt/homebrew/bin/brew shellenv)"
bash --version

cat >> ~/.bashrc <<'EOF'
eval "$(/opt/homebrew/bin/brew shellenv)"
EOF

## wireguard
brew install wireguard-tools
brew uninstall wireguard-tools
brew autoremove

ls /usr/local/etc/wireguard/ /opt/homebrew/etc/wireguard/

## app data
ls "~/Library/Application Support/"

##
softwareupdate --help

softwareupdate --list

sudo softwareupdate --install --all

sudo softwareupdate --install --all --restart

sudo softwareupdate -ia --restart

sudo reboot now

sudo powermetrics --samplers cpu_power,gpu_power -i 1000
