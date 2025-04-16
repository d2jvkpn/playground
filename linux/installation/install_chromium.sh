#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname $0`)


sudo add-apt-repository ppa:xtradeb/apps -y
sudo apt update
sudo apt -y install chromium
