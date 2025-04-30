#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

port=${1:-7700}
MEILI_ENV=${MEILI_ENV:-development} # production

mkdir -p configs data/meilisearch

[ ! -s configs/meilisearch.default.toml ] &&
  curl https://raw.githubusercontent.com/meilisearch/meilisearch/latest/config.toml \
    > configs/meilisearch.default.toml

if [ ! -s configs/meilisearch.toml ]; then
    password=$(tr -dc '0-9a-zA-Z' < /dev/urandom | fold -w 32 | head -n1 || true)
    echo "$password" > configs/meilisearch.pass

    {
        cat configs/meilisearch.default.toml
        echo -e "\n\n### custom ####\nmaster_key = \"$password\"\n"
    } > configs/meilisearch.toml
fi

password=$(yq -oy .master_key configs/meilisearch.toml)

export USER_UID=$(id -u) USER_GID=$(id -g) \
  MEILI_ENV=${MEILI_ENV} HTTP_Port=$port

envsubst < compose.meilisearch.yaml > compose.yaml

exit
docker-compose up -d

curl -i \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $password" \
  -X POST 'http://localhost:7700/indexes/movies/documents?primaryKey=id' \
  --data-binary @examples/movies.json
