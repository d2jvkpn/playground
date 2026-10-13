#!/usr/bin/env bash
set -euo pipefail

config_dir="$HOME/.omp/agent"
target="$config_dir/models.yml"

if [[ ! -L "$target" ]]; then
    echo "Error: $target is not a symlink." >&2
    exit 1
fi

if [[ $# -eq 0 ]]; then
    current=$(readlink "$target")
    profile="${current#models.}"
    profile="${profile%.yml}"
    echo "Current OMP profile: $profile"
    exit 0
fi

profile="$1"

case "$profile" in
    home|office) ;;
    *)
        echo "Usage: $(basename "$0") [home|office]" >&2
        exit 1
        ;;
esac

source_file="models.${profile}.yml"

if [[ ! -f "$config_dir/$source_file" ]]; then
    echo "Error: $config_dir/$source_file not found" >&2
    exit 1
fi

ln -sfn "$source_file" "$target"

echo "OMP model profile: $profile"

shift
sleep 0.5
omp "$@"
