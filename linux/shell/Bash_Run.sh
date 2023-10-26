#! /usr/bin/env bash
# set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

[ $# -eq 0 ] && { >&2 echo "no args"; exit 1; } 

name=${name:-$(basename $1)}
log_dir=${log_dir:-${_wd}}
log_prefix=$log_dir/$name
code=0

{
    echo $(date +'==> %FT%T.%N%:z') $@

    if [ -z "$timeout" ]; then
        echo ""
        "$@"
    else
        echo "~~~ timeout: $timeout"
        echo ""
        timeout $timeout "$@"
    fi
    code=$?

    echo ""
    date +'==> %FT%T.%N%:z end'
} &> $log_prefix.logging

if [ $code -eq 0 ]; then
    mv $log_prefix.logging $log_prefix.log
else
    mv $log_prefix.logging $log_prefix.err
fi

exit $code
