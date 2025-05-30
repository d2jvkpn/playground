#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


addr=http://localhost:5000

curl -X POST "$addr/echo?name=Hello" -H "Content-Type: application/json" -d '{"msg": "hello"}'

curl -X POST "$addr/upload" -F "file=@requirements.txt"
