#!/usr/bin/env bash
set -eu; _wd=$(pwd); _dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
_self="$(basename -- "$0")"


if [[ $# -eq 0 ]]; then
    exec bash
elif [[ "$1" == "bash" || "$1" == "sh" ]]; then
    exec "$@"
else
    for script in "${_dir}"/[0-9][0-9][0-9][0-9].*.sh; do
        [ -e "$script" ] || continue
        [ "$(basename -- "$script")" = "$_self" ] && continue

        # printf '==> running: %s\n' "$script"
        "$script"
    done

    #if [ -n "$BASH_ENV" ]; then . "$BASH_ENV"; fi
    exec "$@"
    #exec bash -lc 'exec "$@"' bash "$@" # using login shell
fi
