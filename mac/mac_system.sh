#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

exit
## never alsleep
pmset -g
pmset -g custom

sudo pmset -a sleep 0
#sudo pmset -a displaysleep 10
sudo pmset -a disksleep 0
sudo pmset -a displaysleep 0
sudo pmset -a standby 0
sudo pmset -a powernap 0

sudo pmset -a tcpkeepalive 1
#sudo pmset -a womp 1

# caffeinate -dimsu # avoid os asleep temporary

#sudo pmset -a autorestartatconnect 1
sudo pmset -a hibernatemode 0
sudo pmset -a disablesleep 1

sudo systemsetup -getrestartpowerfailure
sudo systemsetup -setrestartpowerfailure on

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

sudo launchctl kickstart -k system/com.openssh.sshd
sudo launchctl bootout system /System/Library/LaunchDaemons/ssh.plist
sudo launchctl bootstrap system /System/Library/LaunchDaemons/ssh.plist

ps aux | grep sshd

## upgrade bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew resintall bash

eval "$(/opt/homebrew/bin/brew shellenv)"
bash --version

cat >> ~/.bashrc <<'EOF'
eval "$(/opt/homebrew/bin/brew shellenv)"
EOF


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


# 1. 修改电脑名称 (ComputerName)
sudo scutil --set ComputerName "<computer_name>"

# 2. 修改本地主机名 (LocalHostName)
sudo scutil --set LocalHostName "<name>"

# 3. 修改系统主机名 (HostName)
sudo scutil --set HostName  "<name>"
