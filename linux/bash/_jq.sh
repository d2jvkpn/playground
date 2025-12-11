#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


# json fields to tsv

cat nginx.log |
  jq -r '[.time, .remote_addr] | @tsv'|
  awk -F "[T\t]" '{print $1"\t"$NF}' |
  sort | uniq -c

jq '.data.messages[3] |= . + {
      "date": "2010-01-07T19:55:99.999Z",
      "xml": "xml_samplesheet_2017_01_07_run_09.xml",
      "status": "OKKK",
      "message": "metadata loaded into iRODS successfullyyyyy"
}' input.json

jq -arg content "$(cat data/picture.base64)" ".pictures[0] |= . + $content" data/request.json

jq -r '.[].link' input.json | sort -u
