#!/bin/sh
set -eu

project_dir=$(cd "$(dirname "$0")/.." && pwd)
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT
mkdir "$test_dir/scripts"
cp "$project_dir/scripts/create-auth.sh" "$test_dir/scripts/"
mkdir "$test_dir/bin"
cat > "$test_dir/bin/openssl" <<'EOF'
#!/bin/sh
[ "$1" = passwd ] && [ "$2" = -6 ] && [ "$3" = -stdin ] || exit 2
IFS= read -r password
[ "$password" = valid-secret ] || exit 3
case ${FAKE_OPENSSL_MODE:-success} in
    success) printf '%s\n' '$6$salt$hash' ;;
    failure) exit 7 ;;
esac
EOF
chmod +x "$test_dir/bin/openssl"

printf 'valid-secret\nwrong-secret\n' > "$test_dir/input"
if PATH="$test_dir/bin:$PATH" bash "$test_dir/scripts/create-auth.sh" < "$test_dir/input" >/dev/null 2>&1; then
    echo 'expected mismatched passwords to be rejected' >&2
    exit 1
fi
[ ! -e "$test_dir/data/ubuntu-auth" ]

printf 'valid-secret\nvalid-secret\n' > "$test_dir/input"
if FAKE_OPENSSL_MODE=failure PATH="$test_dir/bin:$PATH" bash "$test_dir/scripts/create-auth.sh" < "$test_dir/input" >/dev/null 2>&1; then
    echo 'expected hash generation failure to stop the script' >&2
    exit 1
fi
[ ! -e "$test_dir/data/ubuntu-auth" ]

PATH="$test_dir/bin:$PATH" bash "$test_dir/scripts/create-auth.sh" < "$test_dir/input" >/dev/null 2>&1
[ "$(stat -c %a "$test_dir/data/ubuntu-auth")" = 700 ]
[ "$(cat "$test_dir/data/ubuntu-auth/ubuntu.hash")" = '$6$salt$hash' ]
[ "$(stat -c %a "$test_dir/data/ubuntu-auth/ubuntu.hash")" = 600 ]

if PATH="$test_dir/bin:$PATH" bash "$test_dir/scripts/create-auth.sh" < "$test_dir/input" >/dev/null 2>&1; then
    echo 'expected an existing hash to be preserved' >&2
    exit 1
fi
[ "$(cat "$test_dir/data/ubuntu-auth/ubuntu.hash")" = '$6$salt$hash' ]

echo 'auth creation tests passed'
