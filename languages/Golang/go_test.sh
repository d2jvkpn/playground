#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

# go_test.yaml
# modules:
# - internal/modules/mod_01
# - internal/modules/mod_02

# bash scripts/go_test.sh -run Fake
# bash scripts/go_test.sh -cover

# echo "Hello, world!"
yaml=configs/go_test.yaml

dirs=$(yq '.modules | join " "' $yaml)

for d in $dirs; do
    cd ${_wd}/$d
    go test $@
done

cd ${_wd}

exit
# https://github.com/brianvoe/gofakeit/tree/master/cmd/gofakeit

go install -v github.com/brianvoe/gofakeit/v7/cmd/gofakeit@latest

gofakeit firstname
gofakeit sentence 5
gofakeit shufflestrings hello,world,whats,up
gofakeit lastname
gofakeit email

gofakeit sentence -loop=5
