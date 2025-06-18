package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strings"
	"time"
)

type LLMRequest struct {
	Prompt string `json:"prompt"`
}

type LLMResponse struct {
	Token string `json:"token"`
}

func main() {
	http.HandleFunc("/llm-stream", llmStreamHandler)
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, "index.html")
	})

	log.Println("LLM SSE server running on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func llmStreamHandler(w http.ResponseWriter, r *http.Request) {
	// 只接受POST请求
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// 解析请求体
	var req LLMRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Bad request", http.StatusBadRequest)
		return
	}

	// 设置SSE头
	w.Header().Set("Content-Type", "text/event-stream")
	w.Header().Set("Cache-Control", "no-cache")
	w.Header().Set("Connection", "keep-alive")
	w.Header().Set("Access-Control-Allow-Origin", "*")

	// 获取flusher
	flusher, ok := w.(http.Flusher)
	if !ok {
		http.Error(w, "Streaming unsupported", http.StatusInternalServerError)
		return
	}

	// 模拟LLM生成token流
	words := strings.Fields(req.Prompt)
	for i, word := range words {
		// 模拟处理延迟
		time.Sleep(300 * time.Millisecond)

		// 创建响应
		resp := LLMResponse{
			Token: word,
		}

		// 转换为JSON
		jsonResp, err := json.Marshal(resp)
		if err != nil {
			log.Printf("Error marshaling response: %v", err)
			continue
		}

		// 写入SSE格式的数据
		fmt.Fprintf(w, "data: %s\n\n", jsonResp)
		flusher.Flush()

		// 模拟生成额外内容
		if i == len(words)-1 {
			additionalText := " 这是LLM生成的额外内容。"
			for _, char := range additionalText {
				time.Sleep(150 * time.Millisecond)
				fmt.Fprintf(w, "data: {\"token\":\"%s\"}\n\n", string(char))
				flusher.Flush()
			}
		}
	}

	// 发送结束事件
	fmt.Fprintf(w, "event: end\ndata: {\"status\":\"completed\"}\n\n")
	flusher.Flush()
}
