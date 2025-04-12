#!/usr/bin/env bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})


#### 1.
USAGE=$(cat <<-END
    This is line one.
    This is line two.
    This is line three.
END
)

echo "$USAGE"

#### 2.
name="d2jvkpn"

USAGE="""---
    This is line one.
    This is line two.
    This is line three.
    name: "$name"
----"""

echo "$USAGE"

#### 3.
cat << EOF
Hello, $name!
EOF

cat << 'EOF'
Hello, $name!
EOF
