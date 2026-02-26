#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
#### enable sshd
sudo systemsetup -setremotelogin on
sudo systemsetup -setremotelogin off
sudo systemsetup -getremotelogin

ps aux | grep sshd

exit
#### upgrade bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew resintall bash

eval "$(/opt/homebrew/bin/brew shellenv)"
bash --version

cat >> ~/.bashrc <<'EOF'
eval "$(/opt/homebrew/bin/brew shellenv)"
EOF

#### never alsleep
exit
# 关闭系统睡眠
sudo pmset -a sleep 0

# 关闭磁盘睡眠
sudo pmset -a disksleep 0

# 关闭显示器睡眠（如果你真的不想黑屏）
sudo pmset -a displaysleep 0

# 关闭待机（standby）
sudo pmset -a standby 0

# 关闭 powernap（防止“看起来睡了”）
sudo pmset -a powernap 0
pmset -g

#### avoid os asleep temporary
caffeinate -dimsu

#### wireguard
brew install wireguard-tools
brew uninstall wireguard-tools
brew autoremove

/usr/local/etc/wireguard/ /opt/homebrew/etc/wireguard/

#### app data
ls "~/Library/Application Support/"
