#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit 0

POST /_aliases
{
  "actions": [
    {
      "add": {
        "index": "crm-accounts-v1",
        "alias": "crm-accounts"
      }
    }
  ]
}
