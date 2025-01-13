#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

port=${port:-9201}

container=${container:-elastic01}
pass_file=configs/$container/elastic.pass
addr="https://localhost:$port"
echo "==> addr=$addr, container=$container"

####
[ ! -s $pass_file ] &&
  docker exec -it $container elasticsearch-reset-password --batch -u elastic |
  awk '/New value:/{print $NF}' |
  dos2unix > $pass_file

password=$(cat $pass_file)
[ -z "$password" ] && { >&2 echo "failed to run elasticsearch-reset-password "; exit 1; }

auth="--cacert configs/$container/certs/http_ca.crt -u elastic:$password"

####
case "$1" in
"check")
    curl $auth "$addr/_cluster/health" -f
    echo

    curl $auth "$addr/_cat/indices?v" -f
    echo

    curl $auth "$addr/_cat/nodes?v=true&format=yaml" -f
    echo
    ;;
"test")
    curl $auth -X PUT "$addr/idx-test"
    echo

    curl $auth -X POST "$addr/idx-test/_doc/1" \
      -H 'Content-Type: application/json' \
      -d'{"title":"Test Document","content":"This is a test document."}' \
      -f
    echo

    curl $auth "$addr/idx-test/_search?q=content:test" -f
    echo
    ;;
*)
    >&2 echo '!!! unknown command'
    exit 1;
esac
