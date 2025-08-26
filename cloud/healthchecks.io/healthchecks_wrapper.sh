#!/usr/bin/env bash
set -eu -o pipefail
# healthchecks_wrapper.sh
# Usage: healthchecks_wrapper.sh <script_path> [args...]
#   <script_path> should include a comment line  # HEALTHCHECKS_UUID=12345678-1234-1234-1234-1234567890ab


#### 1. init
if [ $# -lt 1 ]; then
    echo "Usage: $0 <script_path> [args...]"
    exit 1
fi

hc_url="https://hc-ping.com"

script=$1
shift
hc_uuid=$(grep -Eo 'HEALTHCHECKS_UUID=[0-9a-f-]+' "$script" | cut -d= -f2 || true)

if [ -z "$hc_uuid" ]; then
    echo "Can't find HEALTHCHECKS_UUID in $script"
    exit 2
fi

#### 2. start
curl -fsS -m 10 --retry 5 "$hc_url/$hc_uuid/start" >/dev/null

#### 3. execute
status=0
"$script" "$@" || status=$? || true
status=$?

#### 4. report
if [ $status -eq 0 ]; then
    #curl -fsS --retry 3 "$hc_url" >/dev/null
    curl -fsS -m 10 --retry 5 "$hc_url/$hc_uuid" >/dev/null
else
    curl -fsS -m 10 --retry 5 "$hc_url/$hc_uuid/fail" >/dev/null
fi

exit $status
