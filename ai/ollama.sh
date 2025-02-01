#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)


curl -fsSL https://ollama.com/install.sh | sh
