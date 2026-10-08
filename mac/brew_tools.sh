#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


brew install macmon  # sudo macmon

brew install duf tmux iftop jq yq btop tree watch wget curl awk


exit

brew update

brew install zsh-completions

brew tap ddalcu/mlx-serve https://github.com/ddalcu/mlx-serve
brew trust ddalcu/mlx-serve
brew install mlx-serve         # CLI + server only, no GUI

brew trust --cask ddalcu/mlx-serve/mlx-serve
brew install --cask mlx-serve  # the app (recommended)

brew upgrade mlx-serve

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
