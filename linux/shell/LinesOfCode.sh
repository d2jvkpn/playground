#! /usr/bin/env bash
set -eu -o pipefail # -x

# Count Lines of Code

suffix=${1:-go}

find -type f -name "*.${suffix}"  |
  sed '/^[[:space:]]*$/d' | xargs -i cat {} | strings | wc -l
