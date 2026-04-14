#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


uvicorn app:app --reload --host 0.0.0.0 --port 8000
