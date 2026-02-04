#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


target_dir=$1
APPUSER_UID=$2
APPUSER_GID=${3:-$APPUSER_UID}

chown "$APPUSER_UID:$APPUSER_GID" "$target_dir"

find "$target_dir" -mindepth 1 -maxdepth 1 -fstype overlay \
  -exec chown -R "$APPUSER_UID:$APPUSER_GID" {} +
