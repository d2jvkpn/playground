#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


/opt/scripts/apt.sh update
/opt/scripts/apt.sh install imagemagick ffmpeg net-tools xvfb fonts-noto-cjk
/opt/scripts/apt.sh clean

export PLAYWRIGHT_BROWSERS_PATH=/opt/ms-playwright

npm install -g playwright@latest @playwright/cli@latest \
  @playwright/mcp@latest chrome-devtools-mcp@latest

# @appuser $ npx -y @playwright/mcp@latest

mkdir -p "${PLAYWRIGHT_BROWSERS_PATH}"
playwright install --with-deps chromium
chmod -R a+rX "${PLAYWRIGHT_BROWSERS_PATH}"

playwright install --with-deps chromium
#playwright install --with-deps chrome
#mv /root/.cache/ms-playwright /opt/ms-playwright

rm -rf ~/.cache/* ~/.npm /var/lib/apt/lists/*
npm cache clean --force

playwright --version
playwright install --list

#@appuser
#playwright-cli install --skills

exit
case "$TARGETARCH" in
amd64) LP_ARCH="x86_64" ;;
arm64) LP_ARCH="aarch64" ;;
*) echo "Unsupported arch: $TARGETARCH" && exit 1 ;;
esac

curl -L \
  -o /usr/local/bin/lightpanda \
  "https://github.com/lightpanda-io/browser/releases/download/nightly/lightpanda-${LP_ARCH}-linux"

chmod 0755 /usr/local/bin/lightpanda
lightpanda version

exit
curl -fsSL https://pkg.lightpanda.io/install.sh | bash
