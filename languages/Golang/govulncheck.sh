#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

go get golang.org/x/vulndb/cmd/govulncheck
go install golang.org/x/vulndb/cmd/govulncheck

govulncheck ./...

go list -m -json all
