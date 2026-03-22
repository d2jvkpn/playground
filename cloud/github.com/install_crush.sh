#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#https://github.com/charmbracelet/crush/releases/download/v0.51.1/crush_0.51.1_Linux_x86_64.tar.gz

tgz=$(
  curl -fsSL "https://github.com/charmbracelet/crush/releases/latest/download/checksums.txt" |
  awk '/Linux_x86_64.tar.gz$/{print $2}'
)

version=$(echo $tgz | awk -F "_" '{print $2}')

wget https://github.com/charmbracelet/crush/releases/download/v${version}/$tgz
tar -xf $tgz -C ~/.local
