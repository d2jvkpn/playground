#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})

hosts=$1
# host01,host02,host03

ansible $hosts -m shell --become -a 'export DEBIAN_FRONTEND=noninteractive; apt update && apt -y upgrade'

ansible $hosts -m shell --become -a 'apt remove && apt -y autoremove'

# ansible $hosts -m reboot

ansible $hosts -m shell --become -a "dpkg -l | awk '/^rc/{print \$2}' | xargs -i dpkg -P {}"
