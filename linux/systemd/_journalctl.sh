#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)


exit
journalctl -efx -u app
sudo journalctl --vacuum-time=7d

journalctl -fxe -u kubelet
journalctl -fxe -u containerd

journalctl -u nginx.service --since "2023-10-01" --until "2023-10-02"

journalctl -u nginx.service --since today

journalctl -u nginx.service --reverse

journalctl -u nginx.service -n 100

journalctl -u wg-quick@wg0

journalctl -l --no-pager -u ssh -u sshd --since "7 days ago"
