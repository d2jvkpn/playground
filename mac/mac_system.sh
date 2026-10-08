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

## gpu memory
sysctl -n iogpu.wired_limit_mb

python3 - <<'PY'
import json
import mlx.core as mx

print(json.dumps(mx.device_info(), ensure_ascii=False, indent=2))

print("active:", mx.get_active_memory() / 1024**3, "GiB")
print("peak:", mx.get_peak_memory() / 1024**3, "GiB")
print("cache:", mx.get_cache_memory() / 1024**3, "GiB")
PY

sysctl -n iogpu.wired_limit_mb=53084 # default_bytes: 55662788608
sysctl -n iogpu.wired_limit_mb=57344

## hostname

sudo scutil --set HostName new-hostname
sudo scutil --set LocalHostName new-hostname
sudo scutil --set ComputerName "New Hostname"

scutil --get HostName
scutil --get LocalHostName
scutil --get ComputerName
hostname
