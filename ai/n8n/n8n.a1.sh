#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
# --separate
n8n export:workflow --all --output=/tmp/workflows.json
n8n import:workflow --input=workflows.json
