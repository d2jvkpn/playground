#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


exit
mkdir -p ~/apps/firefox

firefox -P 
firefox -ProfileManager

firefox --no-remote --profile ~/apps/firefox/fws01.profile
firefox --no-remote -P fws01

alises FirefoxWS01='firefox --no-remote -P fws01 >/dev/null 2>&1 & disown'

exit
url: about:profiles
