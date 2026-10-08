#!/usr/bin/env bash
set -euo pipefail

# Usage: ./touch_dir_time.sh [directory]
if [ "$#" -ge 1 ]; then
  dir=$1
else
  read -r -p "Enter directory: " dir
fi

if [ ! -d "$dir" ]; then
  echo "Error: '$dir' is not a directory" >&2
  exit 1
fi

# Convert to absolute path to avoid option-like filenames
dir=$(cd "$dir" && pwd)

# Update access and modification time of all regular files to now
find "$dir" -type f -exec touch -c {} +

echo "Done: updated files under '$dir' to current time"
