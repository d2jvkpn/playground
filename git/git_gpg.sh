#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

key_name=${1:-"git-johndoe"}
password=$(tr -dc "0-9a-zA-Z" < /dev/urandom | fold -w 32 | head -n 1 || true)

gpg --list-keys --keyid-format=long
gpg --list-secret-keys --keyid-format=long

ls ~/.gnupg/pubring.kbx ~/.gnupg/trustdb.gpg
mkdir -p ~/.gnupg/private-keys-v1.d ./data

# gpg --full-generate-key
# ~/.gnupg/openpgp-revocs.d

cat > data/${key_name}.conf <<EOF
%echo ==> Generating a basic OpenPGP key
Key-Type: RSA
Key-Length: 3072
Subkey-Type: RSA
Subkey-Length: 3072
Name-Real: John Doe
Name-Comment: This is a test.
Name-Email: johndoe@noreply.local
Expire-Date: 0
Passphrase: $password
%pubring data/${key_name}.gpg
%commit
%echo ==> Done
EOF

gpg --batch --gen-key data/${key_name}.conf
ls ~/.gnupg/private-keys-v1.d data/${key_name}.gpg

gpg --list-secret-keys --keyid-format=long
gpg --import data/${key_name}.gpg
gpg --list-secret-keys --keyid-format=long

exit

gpg --export --armor --output data/${key_name}.key $key_id
gpg --export-secret-keys --armor --output data/${key_name}.key $key_id
