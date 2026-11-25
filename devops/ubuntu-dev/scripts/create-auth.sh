#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 0 ]]; then
    echo 'Usage: create-auth.sh' >&2
    exit 2
fi

project_dir=$(cd "$(dirname "$0")/.." && pwd)
auth_dir="$project_dir/data/ubuntu-auth"
hash_file="$auth_dir/ubuntu.hash"

if [[ -e $hash_file || -L $hash_file ]]; then
    echo "$hash_file already exists" >&2
    exit 1
fi

printf 'Password: ' >&2
if ! IFS= read -r -s password; then
    printf '\nCould not read password\n' >&2
    exit 1
fi
printf '\nConfirm password: ' >&2
if ! IFS= read -r -s confirmation; then
    printf '\nCould not read confirmation\n' >&2
    exit 1
fi
printf '\n' >&2

if [[ -z $password || $password != "$confirmation" ]]; then
    unset password confirmation
    echo 'Passwords are empty or do not match' >&2
    exit 1
fi

hash=$(printf '%s\n' "$password" | openssl passwd -6 -stdin)
unset password confirmation
if [[ $hash != \$6\$* ]]; then
    echo 'OpenSSL did not generate a valid password hash' >&2
    exit 1
fi

umask 077
mkdir -p "$auth_dir"
chmod 700 "$auth_dir"
temp_file=$(mktemp "$auth_dir/.ubuntu.hash.XXXXXX")
trap 'rm -f "$temp_file"' EXIT
printf '%s\n' "$hash" > "$temp_file"
chmod 600 "$temp_file"
ln "$temp_file" "$hash_file"
printf 'Created %s\n' "$hash_file"
