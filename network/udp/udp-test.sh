#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
#### udp server with socat
socat UDP-RECVFROM:443,fork EXEC:'echo OK'

#### udp server with nc(busybox)
while true; do echo "OK" | nc -u -l -w 0 -p 443; done

#### udp client with nc
echo "Hello" | nc -u -w 1 127.0.0.1 443
