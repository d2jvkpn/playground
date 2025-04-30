#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
#### udp server with socat
socat UDP-RECVFROM:443,fork EXEC:'echo OK'

#### udp server with nc
while true; do 
    echo "OK" | nc -u -l -p 443
done

#### udp client with nc
echo "Hello" | nc -u 127.0.0.1 443
