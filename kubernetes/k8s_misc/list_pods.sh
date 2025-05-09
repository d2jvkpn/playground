#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

namespace=$1


kubectl get pods -n "$namespace" -o json |
  jq -r '.items[] | "\(.metadata.name) \(.status.startTime)"' |
  sort -k2 -r |
  column -t
