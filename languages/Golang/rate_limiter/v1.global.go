package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"golang.org/x/time/rate"
)

// 全局限速器：每秒 10 个请求，最多允许瞬间并发 20 个
var limiter = rate.NewLimiter(10, 20)

func limitMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// 尝试获取一个 token，不阻塞，拿不到直接拒绝
		if !limiter.Allow() {
			w.WriteHeader(http.StatusTooManyRequests)
			_, _ = w.Write([]byte("Too Many Requests\n"))
			return
		}
		next.ServeHTTP(w, r)
	})
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	_, _ = fmt.Fprintln(w, "hello")
}

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/hello", helloHandler)

	// 加一层限速中间件
	limited := limitMiddleware(mux)

	srv := &http.Server{
		Addr:         ":8080",
		Handler:      limited,
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 5 * time.Second,
	}

	log.Println("listening on :8080")
	log.Fatal(srv.ListenAndServe())
}
