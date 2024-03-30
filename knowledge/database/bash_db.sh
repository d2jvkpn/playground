#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


####
function db_set() {
    [[ -z "$1" || -z "$2" ]] && return
    echo "$1,$2" >> data/bash.db
}

function db_get () {
    [ -z "$1" ] && return
    # grep -m 1 "^$1," data/bash.db | sed -e "s/^$1,//" # first match
    # grep "^$1," data/bash.db | sed -e "s/^$1,//" | tail -n 1
    tac data/bash.db | grep -m 1 "^$1," | sed -e "s/^$1,//"
}

function db_get_all () {
    [ -z "$1" ] && return
    grep "^$1," data/bash.db | sed -e "s/^$1,//"
}

####
mkdir -p data
echo -n > data/bash.db

db_set 123456 '{"name":"London","attractions":["Big Ben","London Eye"]}'

db_set 42 '{"name":"San Francisco","attractions":["Golden Gate Bridge"]}'

db_get 42
# {"name":"San Francisco","attractions":["Golden Gate Bridge"]}

db_set 42 '{"name":"San Francisco","attractions":["Exploratorium"]}'

db_get 42
# {"name":"San Francisco","attractions":["Exploratorium"]}

cat data/bash.db
