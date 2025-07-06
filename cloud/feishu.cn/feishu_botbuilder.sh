#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


config=${config:-configs/feishu.yaml}
key=${key:-feishu}

id=$(yq ".$key.id" $config)

if [ $# -eq 0 ]; then
    vars=$(yq -o=json ".$key.vars" $config)

    if [[ "$vars" == "null" || "$vars" == "" ]]; then
        vars=""
    else
        vars=$(echo $vars | jq -r 'to_entries | map("\(.key)=\(.value|tostring)") | join("&")')
    fi
else
    vars=$1
fi

set -x
curl --fail "https://www.feishu.cn/flow/api/trigger-webhook/$id?$vars"

exit
#### 1. feishu
variables:
{
  "id": "x01",
  "target": "Tom"
}

title=feishu_msg01
template="Something happened, id=﻿{{id}} , target=﻿{{target}}, ﻿{{today}}."

#### 2. feishu.yaml
feishu:
  id: x01
  vars:
    id: event01
    target: Tom
