#!//bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

image=${1:-""}

docker images --format "{{.Repository}} {{.Tag}} {{.ID}} {{.Size}}" $image |
  while read repository tag img_id img_size; do
      created_at=$(docker inspect --format='{{.Created}}' $img_id | sed 's/\.[0-9]*Z/Z/')
      rfc3339=$(date --date="$created_at" +%Y-%m-%dT%H:%M:%S%:z)
      timestamp=$(date --date="$created_at" +%s)
      echo "$repository $timestamp $tag $img_id $rfc3339 $img_size"
  done |
  sort -k1,1 -k2,2nr -k3,3 |
  awk '{print $1,$3,$4,$5,$6}' |
  sed '1i repository tag id created_at size' |
  column -t

exit
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedAt}}\t{{.Size}}"

docker images --format "{{.Repository}}:{{.Tag}}" | while read image; do
  created_at=$(docker inspect --format='{{.Created}}' $image | sed 's/\.[0-9]*Z/Z/')
  rfc3339_created_at=$(date --date="$created_at" --utc +%Y-%m-%dT%H:%M:%SZ)
  echo "$image $rfc3339_created_at"
done
