#!/bin/sh
set -eu

project_dir=$(cd "$(dirname "$0")/.." && pwd)
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT
mkdir "$test_dir/bin"
ln -s /bin/true "$test_dir/bin/mkdir"
ln -s /bin/true "$test_dir/bin/cp"
ln -s /bin/true "$test_dir/bin/ssh-keygen"
cat > "$test_dir/bin/usermod" <<'EOF'
#!/bin/sh
printf '%s\n' "$*" > "$TEST_CALLS"
EOF
cat > "$test_dir/bin/chpasswd" <<'EOF'
#!/bin/sh
printf '%s\n' "$*" > "$TEST_CALLS"
cat >> "$TEST_CALLS"
EOF
chmod +x "$test_dir/bin/usermod" "$test_dir/bin/chpasswd"

UBUNTU_AUTH_HASH_FILE="$test_dir/missing.hash" TEST_CALLS="$test_dir/calls" PATH="$test_dir/bin:$PATH" sh "$project_dir/container/prepare-container.sh"
[ "$(cat "$test_dir/calls")" = '-p ! ubuntu' ]

printf '%s\n' '$6$salt$hash' > "$test_dir/ubuntu.hash"
UBUNTU_AUTH_HASH_FILE="$test_dir/ubuntu.hash" TEST_CALLS="$test_dir/calls" PATH="$test_dir/bin:$PATH" sh "$project_dir/container/prepare-container.sh"
[ "$(cat "$test_dir/calls")" = '-e
ubuntu:$6$salt$hash' ]

echo 'auth preparation test passed'
