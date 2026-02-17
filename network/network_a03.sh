#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit
sudo socat -v TCP-LISTEN:443,reuseaddr,fork SYSTEM:'cat'

exit
nc -zv $remote_ip 442

exit
iperf3 -R
iperf3 -u
