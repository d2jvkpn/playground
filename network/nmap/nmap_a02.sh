#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


#### 1. basic scanning
nmap $target_ip

#### 2. scan all ports
nmap -Pn -p- $target_ip

#### 3. check service and version
nmap -sV $target_ip

#### 4. check os
nmap -O $target_ip

#### 5. verbosity
nmap -v $target_ip

#### 6.
nmap -A -T4 $target_ip
nmape -Pn $target_ip

nmap -sn 192.168.0.0/24
nmap -sP 192.168.0.0/24
nmap -PR 192.168.0.0/24

nmap -p 22 --open 192.168.0.0/24
