#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


openclaw browser profiles
openclaw browser status
openclaw browser --browser-profile remote-chromium tabs
openclaw browser --browser-profile remote-chromium open https://www.baidu.com
openclaw browser --browser-profile remote-chromium screenshot
