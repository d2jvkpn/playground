#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


/opt/scripts/apt_install.sh \
  imagemagick ffmpeg net-tools xvfb fonts-noto-cjk

export PLAYWRIGHT_BROWSERS_PATH=/opt/ms-playwright

npm install -g playwright@latest "@playwright/cli@latest" \
  "@playwright/mcp@latest" chrome-devtools-mcp@latest

mkdir -p "${PLAYWRIGHT_BROWSERS_PATH}"
playwright install --with-deps chromium
chmod -R a+rX "${PLAYWRIGHT_BROWSERS_PATH}"

playwright install --with-deps chromium
#playwright install --with-deps chrome
#mv /root/.cache/ms-playwright /opt/ms-playwright

rm -rf ~/.cache ~/.npm /var/lib/apt/lists/*
npm cache clean --force
mkdir -p ~/.cache

playwright --version
playwright install --list

#@appuser
#playwright-cli install --skills
