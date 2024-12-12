#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0)

function display_usage() {
>&2 cat <<'EOF'
Usage of pem_extract.sh:

help:
  pem_extract.sh [help | -h | --help]

extract private key:
  pem_extract.sh private site.pem

extract public keys:
  pem_extract.sh public site.pem
EOF
}

if [ $# -lt 2 ]; then
    display_usage
    exit 0
fi

action=$1
filepath=$2

case "$action" in
"private")
    awk 'BEGIN{k=0} /-----BEGIN PRIVATE KEY-----/{k=1} k==1{print} /-----END PRIVATE KEY-----/{exit}' $filepath
    ;;
"public")
    awk 'BEGIN{k=0} /-----BEGIN CERTIFICATE-----/{k=1} k==1{print} /-----END CERTIFICATE-----/{k=0}' $filepath
    ;;
"help" | "-h" | "--help")
    display_usage
    exit 0
    ;;
*)
    display_usage
    exit 1
    ;;
esac
