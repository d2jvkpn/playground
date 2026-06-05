#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


for d in $@; do
    if [ -d "$HOME/.local/share/$d" ]; then
        continue
    fi

    mkdir -p "$HOME/.local/share/$d"
    ln -sf "$HOME/.local/share/$d" "$HOME/.$d"
done

exit
cd "$1"

find . -maxdepth 1 -type l | while read -r link; do
    target=$(readlink "$link")

    case "$target" in
        /*) target_path="$target" ;;
        *) target_path="$(dirname "$link")/$target" ;;
    esac

    if [ ! -e "$target_path" ]; then
        mkdir -p "$target_path"
        echo "created: $target_path"
    fi
done
