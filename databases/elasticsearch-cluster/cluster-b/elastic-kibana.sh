#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(dirname $0)

cat <<EOF
#### Open kibana
1. Run commandline: make kibana
2. Open http://localhost:5601, title="Configure Elastic to get started"
3. Click "Configure manually"
4. Enter Address: https://es-node01:9200, click "Check address"
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

es_node=${es_node:-es-node01}
kibana=${kibana:-es-kibana}

password=$(yq .kibana.password configs/elastic.yaml)

if [[ -z "$password" || "$password" == "null" ]]; then
    password=$(
     docker exec -it $es_node \
       elasticsearch-reset-password -u kibana_system --batch --url https://localhost:9200 |
       awk '/New value/{print $NF}' |
       dos2unix
   )
fi

if [[ -z "$password" || "$password" == "null" ]]; then
    >&2 echo '!!! Failed to get password of kibana_system'
    exit 1
fi

yq -i '.kibana.account = "kibana_system"' configs/elastic.yaml
yq -i e '.kibana.password = "'$password'"' configs/elastic.yaml

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


exit

####
docker exec -it es-node01 \
  elasticsearch-reset-password -u elastic --url https://localhost:9200 |
  awk '/New value/{print $NF}' |
  dos2unix

docker exec -it es-node01 \
  elasticsearch-reset-password -u kibana_system --batch |
  awk '/New value/{print $NF}' |
  dos2unix

docker exec $kibana cat data/verification_code | dos2unix

####
docker exec -it es-node01 \
  elasticsearch-create-enrollment-token -s kibana --url https://localhost:9200 |
  dos2unix

docker exec -it es-node01 \
  elasticsearch-create-enrollment-token -s node --url https://localhost:9200 |
  dos2unix

####
curl -s -X POST --cacert configs/certs/ca.crt \
  -u "elastic:$(cat configs/certs/elastic.pass)" \
  -H "Content-Type: application/json" \
  https://localhost:9200/_security/user/kibana_system/_password -d '{"password":"foobar"}'
