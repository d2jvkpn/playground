#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


exit

curl -X GET $auth "$addr/_cat/plugins?v" | grep analysis-ik

curl -X PUT $auth "$addr/idx-test" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "analysis": {
      "analyzer": {
        "default": {
          "type": "ik_max_word"
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "content": {
        "type": "text",
        "analyzer": "ik_max_word",
        "search_analyzer": "ik_smart"
      }
    }
  }
}'

curl -X POST $auth "$addr/idx-test/_bulk" -H "Content-Type: application/x-ndjson" \
  --data-binary @- <<EOF
{"index":{}}
{"name":"张三","age":28,"job":"工程师","join_date":"2023-01-15"}
{"index":{}}
{"name":"李四","age":32,"job":"设计师","join_date":"2022-11-03"}
{"index":{}}
{"name":"王五","age":25,"job":"分析师","join_date":"2023-03-22"}
EOF


curl -X GET $auth "$addr/idx-test/_settings?pretty"

curl -X GET $auth "$addr/idx-test/_mapping"

curl -X GET $auth "$addr/idx-test/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match": {
      "content": "设计师"
    }
  }
}'


curl -X GET $auth "$addr/idx-test/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "wildcard": { "name.keyword": "*张*" }
  }
}'


curl -X GET $auth "$addr/idx-test/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "prefix": {
      "name.keyword": { "value": "张" }
    }
  }
}'


curl -X POST $auth "$addr/idx-test/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "range": {
      "age": { "gte": 20, "lte": 30 }
    }
  }
}'


curl -X POST $auth "$addr/idx-test/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must": [
        { "term": { "name": "李四" } }
      ]
    }
  }
}'
