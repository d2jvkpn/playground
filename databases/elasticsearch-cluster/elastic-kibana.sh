#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


cat <<EOF
#### Open kibana
1. Run commandline: make kibana
2. Open http://localhost:5601, title="Configure Elastic to get started"
3. Click "Configure manually"
4. Enter Address: https://elastic-node01:9200, click "Check address"
5. Enter account(output of step1):
- username=kibana_system,
- password: XX01
- select "I recognize and trust this certificate:"
- click
6. Enter verification code: XX02
7. Waitting: "Saving settings" -> "Starting Elastic" -> "Completing setup"
8. Refresh webpage
9. Enter account(output of step1): username=elastic, password=XX03

EOF

elastic_node=${elastic_node:-elastic-node01}
kibana=${kibana:-elastic-kibana}

password=$(yq .kibana.password configs/elastic.yaml)

if [[ -z "$password" || "$password" == "null" ]]; then
    password=$(
     docker exec -it $elastic_node \
       elasticsearch-reset-password -u kibana_system --batch --url https://localhost:9200 |
       awk '/New value/{print $NF}' |
       dos2unix
   )
fi

if [[ -z "$password" || "$password" == "null" ]]; then
    >&2 echo '!!! Failed to get password of kibana_system'
    exit 1
fi

yq -i '.kibana.account = "kibana_system" | .kibana.password = "'$password'"' configs/elastic.yaml

# 5.
verification_code=$(docker exec $kibana cat data/verification_code | dos2unix)

cat <<EOF

# kibana account
kibana:
  account: kibana_system
  password: $(yq .kibana.password configs/elastic.yaml)
  verification_code: $verification_code

elastic:
  account: elastic
  password: $(yq .password configs/elastic.yaml)
EOF
