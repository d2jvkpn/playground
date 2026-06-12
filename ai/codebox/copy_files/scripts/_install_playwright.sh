#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


/opt/scripts/apt_install.sh \
  imagemagick ffmpeg net-tools xvfb fonts-noto-cjk

npm install -g playwright
playwright install --with-deps chromium

mv /root/.cache/ms-playwright /opt/ms-playwright
rm -rf ~/.cache ~/.npm
mkdir -p ~/.cache

export PLAYWRIGHT_BROWSERS_PATH=/opt/ms-playwright
