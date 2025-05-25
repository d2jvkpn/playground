#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


bin/elasticsearch-plugin install analysis-icu

curl -X GET "http://localhost:9200/_cat/plugins?v"

PUT /your_index_name
{
  "settings": {
    "analysis": {
      "analyzer": {
        "multilingual_analyzer": {
          "tokenizer": "icu_tokenizer",
          "filter": [
            "icu_normalizer",
            "icu_folding",
            "english_stop",
            "cjk_width"
          ]
        }
      },
      "filter": {
        "english_stop": {
          "type": "stop",
          "stopwords": "_english_"
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "content": {
        "type": "text",
        "analyzer": "multilingual_analyzer",
        "search_analyzer": "multilingual_analyzer"
      }
    }
  }
}

GET /your_index_name/_search
{
  "query": {
    "multi_match": {
      "query": "搜索词",
      "fields": ["content", "content.chinese", "content.english"]
    }
  }
}
