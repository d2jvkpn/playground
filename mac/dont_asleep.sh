#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)

## never alsleep
exit
pmset -g
pmset -g custom

sudo pmset -a sleep 0
#sudo pmset -a displaysleep 10
sudo pmset -a disksleep 0
sudo pmset -a displaysleep 0
sudo pmset -a standby 0
sudo pmset -a powernap 0

sudo pmset -a tcpkeepalive 1
#sudo pmset -a womp 1

# caffeinate -dimsu # avoid os asleep temporary

#sudo pmset -a autorestartatconnect 1
sudo pmset -a hibernatemode 0
sudo pmset -a disablesleep 1

sudo systemsetup -getrestartpowerfailure
sudo systemsetup -setrestartpowerfailure on
