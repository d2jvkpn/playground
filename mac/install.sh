#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit

#### enable sshd
sudo systemsetup -setremotelogin on
sudo systemsetup -setremotelogin off
sudo systemsetup -getremotelogin

ps aux | grep sshd

#### uprade bash
brew resintall bash

eval "$(/opt/homebrew/bin/brew shellenv)"

bash --version
