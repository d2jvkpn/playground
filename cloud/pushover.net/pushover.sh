#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

# site: https://pushover.net/

user_key=$(yq '.pushover.user_key' configs/local.yaml)
#app_token=$(yq '.pushover.apps.test01.app_token' configs/local.yaml)
app_token=$(yq '.pushover.app_token' configs/local.yaml)

device=${1}
title=$2
message=$3

form_args="""
  --form-string "user=$user_key" \
  --form-string "token=$app_token" \
  --form-string "title=$title" \
  --form-string "message=$message" \
"""

if [ ! -z "$device" ]; then
    form_args="$form_args --form-string 'device=$device'"
fi

# -i
curl -fsS -m 10 --retry 5 $form_args https://api.pushover.net/1/messages.json

exit
-F "attachment=@image.jpg"
--form-string device="droid4"
