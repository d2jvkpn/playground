#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

# https://github.com/browserbase/stagehand-python


pip install stagehand --index-url https://pypi.org/simple

playwright install chromium
# playwright install # install all: chromium, firefox, webkit, ffmpeg


exit
https://cdn.playwright.dev/dbazure/download/playwright/builds/chromium/1179/chromium-linux.zip
https://cdn.playwright.dev/dbazure/download/playwright/builds/chromium/1179/chromium-headless-shell-linux.zip
https://playwright.download.prss.microsoft.com/dbazure/download/playwright/builds/firefox/1488/firefox-ubuntu-24.04.zip
https://playwright.download.prss.microsoft.com/dbazure/download/playwright/builds/webkit/2182/webkit-ubuntu-24.04.zip

ls ~/.cache/ms-playwright/
