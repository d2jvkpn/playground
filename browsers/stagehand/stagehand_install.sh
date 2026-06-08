#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

# https://github.com/browserbase/stagehand-python


pip install stagehand --index-url https://pypi.org/simple
