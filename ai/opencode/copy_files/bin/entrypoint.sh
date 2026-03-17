#!/bin/bash
set -eu


if [[ $# -eq 0 || ( $# -eq 1 && "$1" == "bash" ) ]]; then
    exec /bin/bash
else
    # echo TODO...

    exec "$@"
fi
