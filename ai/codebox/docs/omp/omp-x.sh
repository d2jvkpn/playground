#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/.omp/agent"
PROFILE="${1:-}"

case "$PROFILE" in
    home|office) ;;
    *)
        echo "Usage: $(basename "$0") {home|office} [omp args...]" >&2
        exit 1
        ;;
esac

SOURCE="models.${PROFILE}.yml"
TARGET="$DIR/models.yml"

if [[ ! -f "$DIR/$SOURCE" ]]; then
    echo "Error: $DIR/$SOURCE not found" >&2
    exit 1
fi

if [[ -e "$TARGET" && ! -L "$TARGET" ]]; then
    echo "Error: $TARGET is a regular file. Back it up first." >&2
    exit 1
fi

ln -sfn "$SOURCE" "$TARGET"

echo "OMP model profile: $PROFILE"

shift
exec omp "$@"
