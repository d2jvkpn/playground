#!/bin/sh
set -eu

project_dir=$(cd "$(dirname "$0")/.." && pwd)
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT
mkdir "$test_dir/bin"
cp "$project_dir/container/entrypoint.sh" "$test_dir/"
ln -s /bin/true "$test_dir/bin/mkdir"
ln -s /bin/true "$test_dir/bin/ssh-keygen"
cat > "$test_dir/bin/supervisord" <<'EOF'
#!/bin/sh
sleep 0.1
EOF
cat > "$test_dir/bin/supervisorctl" <<'EOF'
#!/bin/sh
case "$*" in
    *' pid') echo 1234 ;;
esac
EOF
chmod +x "$test_dir/bin/supervisord" "$test_dir/bin/supervisorctl"

cat > "$test_dir/bin/sudo" <<'EOF'
#!/bin/sh
printf '%s\n' "$*" >> "$SUDO_CALLS"
[ "$1" = -n ] || exit 2
shift
case "$1" in
    /opt/bin/prepare-container.sh) exit 0 ;;
    supervisord) sleep 0.1 ;;
    supervisorctl)
        case "$*" in
            *' pid') echo 1234 ;;
            *' start sshd') exit 0 ;;
            *' shutdown') exit 0 ;;
            *) exit 2 ;;
        esac ;;
    *) exit 2 ;;
esac
EOF
chmod +x "$test_dir/bin/sudo"

SUDO_CALLS="$test_dir/sudo-calls" PATH="$test_dir/bin:$PATH" sh "$test_dir/entrypoint.sh" >/dev/null 2>&1
if [ ! -e "$test_dir/sudo-calls" ]; then
    echo 'expected privileged startup steps to use sudo' >&2
    exit 1
fi
[ "$(wc -l < "$test_dir/sudo-calls")" -ge 3 ]

echo 'ubuntu startup delegation test passed'
