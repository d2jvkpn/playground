#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

# echo "Hello, world!"

go install golang.org/x/tools/...@latest

go clean -testcache -modcache

cat <<EOF
goleak: https://github.com/uber-go/goleak
pgo:
- https://www.uber.com/blog/automating-efficiency-of-go-programs-with-pgo/
EOF
