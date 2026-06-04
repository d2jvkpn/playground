#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


cat | yq eval "explode(.) | .hello" <<EOF
containers: &containers
- { hello: world }
- { hello: 42 }

hello:
  world: 42
  containers: *containers
EOF


exit
cat > a.json <<EOF
{
  "name": "openclaw",
  "version": "1.0",
  "author": {
    "name": "Hello"
  }
}
EOF

cat > b.json <<EOF
{
  "service": "rag",
  "config": {}
}
EOF

yq -o=json '.config.name = load("a.json").name' b.json

{
  "service": "rag",
  "config": {
    "name": "openclaw"
  }
}
