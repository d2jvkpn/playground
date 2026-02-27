#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit

# Check if the system supports MULTICAST
ip addr | grep MULTICAST

# Check if network card eth0 supports MULTICAST
ip link show eth0 | grep MULTICAST

# Enable MULTICAST if it's disbaled on the network card
ip link set eth0 multicast on

# Check 5333/udp
netstat -ulnp | grep 5353
# -u UDP
# -l listening
# -n numeric, don't resolve names
# -p program, display PID/Program name for sockets

sudo netstat -ulp
