#! /usr/bin/env bash
# set -x
set -eu -o pipefail

# Count Lines of Code

suffix=${1:-go}

find -type f -name "*.${suffix}"  |
  sed '/^[[:space:]]*$/d' | xargs -i cat {} | strings | wc -l
