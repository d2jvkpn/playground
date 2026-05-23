#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


docker run --rm authelia/authelia:latest \
  authelia crypto hash generate argon2 --password 'your_password'
