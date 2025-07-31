#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


curl -k -u "USERNAME:P4s5word" -T "path-to-source_file" \
  "https://your.cloud.tld/remote.php/webdav/path-on-your-server/source_file"
