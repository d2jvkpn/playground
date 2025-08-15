#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

# site: https://pushover.net/

user_key=$(yq '.pushover.user_key' configs/local.yaml)
app_token=$(yq '.pushover.apps.test01.app_token' configs/local.yaml)

title="$1"
shift
message="$*"

curl -s \
  --form-string "user=$user_key" \
  --form-string "token=$app_token" \
  --form-string "title=$title" \
  --form-string "message=$message" \
  https://api.pushover.net/1/messages.json

exit
-F "attachment=@image.jpg"
--form-string device="droid4"
