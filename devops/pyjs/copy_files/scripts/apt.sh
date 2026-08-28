#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)

export DEBIAN_FRONTEND=noninteractive

usage() {
    echo "Usage: $(basename "$0") <update|upgrade|clean>" >&2
    echo "       $(basename "$0") install [-f file] [packages...]" >&2
    exit 1
}

#### print one package name per line from a file, '#' comments and blank lines skipped
read_pkg_file() {
    local file="$1" line
    while IFS= read -r line || [ -n "$line" ]; do
        line="${line%%#*}"
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"
        [ -n "$line" ] || continue
        set -f
        local -a toks=($line)
        set +f
        printf '%s\n' "${toks[@]}"
    done < "$file"
}

#### packages may come from -f <file> (one or more per line) and/or
#### trailing command-line arguments, mixed freely
cmd_install() {
    local pkgs=() pkg
    while [ $# -gt 0 ]; do
        case "$1" in
            -f)
                shift
                [ $# -ge 1 ] || usage
                while IFS= read -r pkg; do
                    pkgs+=("$pkg")
                done < <(read_pkg_file "$1")
                shift
                ;;
            *)
                pkgs+=("$1")
                shift
                ;;
        esac
    done
    [ ${#pkgs[@]} -ge 1 ] || usage
    apt-get install -y --no-install-recommends "${pkgs[@]}"
}

[ $# -ge 1 ] || usage
cmd="$1"; shift

case "$cmd" in
    update)
        #### apt-get index update
        apt-get -qq update > /dev/null 2>&1
        ;;
    upgrade)
        #### upgrade already-installed packages, no new dependencies pulled in
        apt-get upgrade -qq -y --no-install-recommends --allow-change-held-packages
        ;;
    install)
        cmd_install "$@"
        ;;
    clean)
        #### remove unused packages and shrink image
        apt-get autoremove -y
        apt-get clean
        apt-get autoclean
        dpkg -l | awk '/^rc/{print $2}' | xargs -r dpkg -P
        rm -rf /var/lib/apt/lists/*
        ;;
    *)
        usage
        ;;
esac
