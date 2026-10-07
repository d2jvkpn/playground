#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


brew install macmon  # sudo macmon

brew install duf tmux iftop jq yq btop tree watch wget curl awk


exit

brew install zsh-completions

print -l $fpath

mkdir -p ~/.zsh/completions
docker completion zsh > ~/.zsh/completions/_docker

cat <<EOF
eval "$(/opt/homebrew/bin/brew shellenv)"

fpath=(
  "$HOME/.zsh/completions"
  "$(brew --prefix)/share/zsh-completions"
  $fpath
)

autoload -Uz compinit
compinit
EOF


chmod -R go-w \
  ~/.zsh/completions \
  /opt/homebrew/share/zsh \
  /opt/homebrew/share/zsh/site-functions \
  /opt/homebrew/share/zsh-completions \
  /usr/share/zsh/site-functions
