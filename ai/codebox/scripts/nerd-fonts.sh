#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


apt-get update && apt-get install -y \
    curl unzip fontconfig

mkdir -p /usr/local/share/fonts/nerd-fonts

curl -fL \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip \
  -o /tmp/JetBrainsMono.zip

unzip -o /tmp/JetBrainsMono.zip '*.ttf' -d /usr/local/share/fonts/nerd-fonts

fc-cache -fv

rm /tmp/JetBrainsMono.zip
