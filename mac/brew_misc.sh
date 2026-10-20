#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)

brew update

exit

brew version-install <app>@<version>

brew link --overwrite <app>

brew cleanup

#Untap them with:
brew untap evol/versions

# Trust specific formulae, casks and commands with:
brew trust --formula <user>/<tap>/<formula>
brew trust --cask <user>/<tap>/<cask>
brew trust --command <user>/<tap>/<command>

