#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


target_dir=$1
USER_UID=$2
USER_GID=${3:-$USER_UID}

chown "$USER_UID:$USER_GID" "$target_dir"

find "$target_dir" -mindepth 1 -maxdepth 1 -fstype overlay \
  -exec chown -R "$USER_UID:$USER_GID" {} +
