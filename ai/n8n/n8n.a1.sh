#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


n8n export:workflow --all --output=workflows.json

n8n import:workflow --input=workflows.json
