#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
#### enable sshd
sudo systemsetup -setremotelogin on
sudo systemsetup -setremotelogin off
sudo systemsetup -getremotelogin

ps aux | grep sshd

#### upgrade bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew resintall bash

eval "$(/opt/homebrew/bin/brew shellenv)"
bash --version

cat >> ~/.bashrc <<'EOF'
eval "$(/opt/homebrew/bin/brew shellenv)"
EOF
