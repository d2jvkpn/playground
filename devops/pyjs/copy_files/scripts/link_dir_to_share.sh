#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


if [ $# -eq 0 ]; then
    echo "no app(s) provided!" >&2
    exit 1
fi

for app in $@; do
    app_dir="$HOME/.$app"

    if [ -d "$app_dir" ]; then
        echo "directory already exists: $app_dir" >&2
        exit 1
    fi
    #rm -rf "$app_dir"
fi

for app in $@; do
    mkdir -p "$HOME/.local/share/$app"
    ln -s "$HOME/.local/share/$app" "$app_dir"
done
