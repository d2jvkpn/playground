#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


status=0
ls $0 || status=$? || true
echo "--> 1. status: $status"

status=0
ls not_exists_file || status=$? || true
echo "--> 2. status: $status"
