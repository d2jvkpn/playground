#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
echo url=https://github.com/VSCodium/vscodium/releases

#### replace code with codium
sudo ln -sf /usr/bin/codium /usr/local/bin/code

xdg-mime query default x-scheme-handler/vscode

ls /usr/share/applications | grep codium

xdg-mime default codium.desktop x-scheme-handler/vscode

####
codium --list-extensions --show-versions

exit
#### extensions
# opencode
# dev container
