#!/bin/bash
set -eu -o pipefail # -x
_wd=$(pwd); _path=$(dirname $0)

exit

mkdir -p configs

# export GNUPGHOME=~/.gnupg
gpg --homedir ./configs --full-generate-key

ls ./configs/openpgp-revocs.d/

gpg --homedir ./configs --list-secret-keys --keyid-format LONG
# sec: primary secret key, "algolength/key_id created_date [type_codes]\nfingerprint"
# uid: owner info,         ""
# ssb: secondary secret key

gpg --homedir ./configs --export --armor $key_id > configs/$key_id.asc

# --global
git config user.signingkey $key_id
git config commit.gpgSign true
