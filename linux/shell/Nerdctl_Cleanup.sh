#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname "$0"`)

## crontab -e
# @reboot bash -c /opt/bin/Nerdctl_Cleanup.sh

nerdctl -n k8s.io ps --format=json -a |
  jq -rs '.[] | select( .Status == "Created").ID' |
  xargs -i nerdctl -n k8s.io rm {}
