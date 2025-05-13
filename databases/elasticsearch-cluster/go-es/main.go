package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"strings"

	"github.com/elastic/go-elasticsearch/v8"
	"github.com/elastic/go-elasticsearch/v8/esapi"
)

// Article 定义文档结构
type Article struct {
	ID      string `json:"id"`
	Title   string `json:"title"`
	Content string `json:"content"`
	Author  string `json:"author"`
}

func main() {
	var (
		esAddr    string
		indexName string
		err       error
		cfg       elasticsearch.Config
		es        *elasticsearch.Client
		res       *esapi.Response
		article   Article
	)

	flag.StringVar(&esAddr, "esAddr", "http://localhost:9200", "elastic address")
	flag.StringVar(&indexName, "indexName", "articles", "index name")
	flag.Parse()

	cfg = elasticsearch.Config{
		Addresses: []string{esAddr},
	}

	// 1. 检查ES连接
	if es, err = elasticsearch.NewClient(cfg); err != nil {
		log.Fatalf("!!! Error creating the client: %s", err)
	}

	if res, err = es.Info(); err != nil {
		log.Fatalf("!!! Error getting response: %s", err)
	}
	fmt.Printf("~~~ response: %s\n", res.String())
	res.Body.Close()

	// 2. 创建索引
	createIndex(es, indexName)

	// 3. 添加文档
	article = Article{
		ID:      "1",
		Title:   "Go 与 Elasticsearch 集成",
		Author:  "张三",
		Content: "这篇文章介绍了如何在 Go 中使用 Elasticsearch",
	}
	addDocument(es, indexName, article)

	// 4. 搜索文档
	searchDocuments(es, indexName, "Go")
}

// 创建索引
func createIndex(es *elasticsearch.Client, indexName string) {
	// 检查索引是否存在
	res, err := es.Indices.Exists([]string{indexName})
	if err != nil {
		log.Fatalf("!!! Error checking index existence: %s", err)
	}
	if res.StatusCode == 200 {
		fmt.Printf("--> Index %s already exists\n", indexName)
		return
	}

	// 创建索引
	mapping := `{
		"mappings": {
			"properties": {
				"title": {
					"type": "text",
					"analyzer": "ik_max_word",
					"search_analyzer": "ik_smart"
				},
				"author": {
					"type": "keyword"
				},
				"content": {
					"type": "text",
					"analyzer": "ik_max_word",
					"search_analyzer": "ik_smart"
				}
			}
		}
	}`

	req := esapi.IndicesCreateRequest{
		Index: indexName,
		Body:  strings.NewReader(mapping),
	}

	res, err = req.Do(context.Background(), es)
	if err != nil {
		log.Fatalf("!!! Error creating index: %s", err)
	}
	defer res.Body.Close()

	if res.IsError() {
		log.Printf("!!! Error response: %s", res.String())
	} else {
		fmt.Printf("--> Index %s created successfully\n", indexName)
	}
}

// 添加文档
func addDocument(es *elasticsearch.Client, indexName string, article Article) {
	data, err := json.Marshal(article)
	if err != nil {
		log.Fatalf("Error marshaling document: %s", err)
	}

	req := esapi.IndexRequest{
		Index:      indexName,
		DocumentID: article.ID,
		Body:       strings.NewReader(string(data)),
		Refresh:    "true",
	}

	res, err := req.Do(context.Background(), es)
	if err != nil {
		log.Fatalf("!!! Error indexing document: %s", err)
	}
	defer res.Body.Close()

	if res.IsError() {
		log.Printf("!!! Error indexing document: %s", res.String())
	} else {
		fmt.Printf("--> Document indexed successfully: %s\n", article.ID)
	}
}

// 搜索文档
func searchDocuments(es *elasticsearch.Client, indexName, searchTerm string) {
	query := fmt.Sprintf(`{
		"query": {
			"multi_match": {
				"query": "%s",
				"fields": ["title", "content"]
			}
		}
	}`, searchTerm)

	res, err := es.Search(
		es.Search.WithContext(context.Background()),
		es.Search.WithIndex(indexName),
		es.Search.WithBody(strings.NewReader(query)),
		es.Search.WithPretty(),
	)
	if err != nil {
		log.Fatalf("!!! Error searching documents: %s", err)
	}
	defer res.Body.Close()

	if res.IsError() {
		log.Printf("!!! Error searching documents: %s", res.String())
		return
	}

	var result map[string]interface{}
	if err := json.NewDecoder(res.Body).Decode(&result); err != nil {
		log.Fatalf("!!! Error parsing the response: %s", err)
	}

	fmt.Printf("\n==> Search results for '%s':\n", searchTerm)
	for _, hit := range result["hits"].(map[string]interface{})["hits"].([]interface{}) {
		source := hit.(map[string]interface{})["_source"]
		bytes, _ := json.MarshalIndent(source, "", "  ")
		fmt.Println(string(bytes))
	}
}
