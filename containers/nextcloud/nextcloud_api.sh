#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

curl -k -u "USERNAME:P4s5word" -T "path-to-source_file" \
  "https://your.cloud.tld/remote.php/webdav/path-on-your-server/source_file"
