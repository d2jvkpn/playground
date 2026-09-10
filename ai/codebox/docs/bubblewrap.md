# Title
---
```meta
date: 1970-01-01
authors: []
version: 0.1.0
description: 
```


## Installation
```
sudo apt install bubblewrap
```

## Setup
```
if [ "$(id -u)" -ne 0 ]; then
    echo "must run as root (sudo sh scripts/setup-bwrap-apparmor.sh)" >&2
    exit 1
fi

if ! command -v bwrap >/dev/null 2>&1; then
    echo "bwrap not found on PATH; install the bubblewrap package first" >&2
    exit 1
fi

BWRAP_PATH=$(command -v bwrap)

cat >/etc/apparmor.d/bwrap <<EOF
abi <abi/4.0>,
include <tunables/global>

profile bwrap $BWRAP_PATH flags=(unconfined) {
  userns,
}
EOF

apparmor_parser -r /etc/apparmor.d/bwrap

echo "=== verifying ==="
if "$BWRAP_PATH" --unshare-user --unshare-pid --ro-bind / / -- true; then
    echo "bwrap can now create unprivileged user namespaces"
else
    echo "bwrap probe still failing; see docs/adk/exec-code.md" >&2
    exit 1
fi
```

## Tests
```
bwrap \
  --unshare-user --unshare-pid --unshare-ipc --unshare-uts \
  --die-with-parent --new-session \
  --ro-bind / / \
  --tmpfs /tmp \
  --proc /proc \
  --dev /dev \
  pwd

bwrap \
  --unshare-user \
  --unshare-pid \
  --unshare-ipc \
  --unshare-uts \
  --die-with-parent \
  --new-session \
  \
  --ro-bind /usr /usr \
  --ro-bind /bin /bin \
  --ro-bind /lib /lib \
  --ro-bind /lib64 /lib64 \
  \
  --dir /workspace \
  --bind "$PWD" /workspace \
  \
  --tmpfs /tmp \
  --proc /proc \
  --dev /dev \
  --chdir /workspace \
  /bin/bash
```

## docker compose
```
services:
  app:
    cap_add: ["SYS_ADMIN"]
    security_opt: ["apparmor:unconfined", "systempaths=unconfined", "seccomp=unconfined"]
    pids_limit: 512
```
