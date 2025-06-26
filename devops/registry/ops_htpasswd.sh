#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
# apt install apache2-utils
mkdir configs

# generate a account and output to stdout
htpasswd -Bn -C 10 account

# generate a account and output to stdout(password from commandline)
htpasswd -Bn -C 10 -b account password

# add(override) a account to the htpasswd file
htpasswd -B -C 10 -c configs/registry.htpasswd account

# add(override) a account to the htpasswd file(password from commandline)
htpasswd -B -C 10 -b -c configs/registry.htpasswd account password

# remove an account from the htpasswd file
htpasswd -D configs/registry.htpasswd registry
