#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

case $# in
0)
    :
    ;;
1)
    cd "$1"
    ;;
*)
    for d in "$@";
        do bash "$0" "$d"
    done

    exit 0
    ;;
esac

date +'==> %FT%T.%N%:z Hello, world!'
pwd

exit
#### examples
mkdir -p wk_tests/{a..c}

bash test_a03.sh

bash test_a03.sh wk_tests/a

bash test_a03.sh wk_tests/a wk_tests/b wk_tests/c
