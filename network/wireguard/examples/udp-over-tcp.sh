#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

exit

# server
udptunnel -s 9000 127.0.0.1 1194

#
udptunnel -c server.example.com 9000 1194

socat
udp2raw
ncat
