#!/usr/bin/env bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0 | xargs -i readlink -f {})

gpg --list-secret-keys --keyid-format=long

# gpg --full-generate-key
# ~/.gnupg/openpgp-revocs.d
# ~/.gnupg/
# gpg --armor --export KEY_Id

mkdir -p data

cat > data/gpg.conf <<EOF
%echo ==> Generating a basic OpenPGP key
Key-Type: RSA
Key-Length: 3072
Subkey-Type: RSA
Subkey-Length: 3072
Name-Real: John Doe
Name-Comment: My comment
Name-Email: johndoe@noreply.local
Expire-Date: 0
Passphrase: secret
%pubring data/git-johndoe.gpg
%commit
%echo ==> Done
EOF

gpg --batch --gen-key data/gpg.conf
ls ~/.gnupg/ data/git-johndoe.gpg

gpg --import data/git-johndoe.gpg

gpg --list-secret-keys --keyid-format=long

exit
gpg --armor --export KEY_Id
