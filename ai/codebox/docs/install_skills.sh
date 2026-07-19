#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


npx skills@latest add mattpocock/skills

echo "command /grill-me"
