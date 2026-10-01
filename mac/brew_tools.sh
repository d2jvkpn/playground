#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)

brew install macmon  # sudo macmon

brew install duf tmux iftop jq yq btop tree watch
