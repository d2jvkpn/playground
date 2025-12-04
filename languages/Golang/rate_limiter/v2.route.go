package main

import (
	"fmt"
	"log"
	"net/http"

	"golang.org/x/time/rate"
)

type RouteLimiter struct {
	limiter *rate.Limiter
	handler http.Handler
}

func NewRouteLimiter(rps float64, burst int, handler http.Handler) *RouteLimiter {
	return &RouteLimiter{
		limiter: rate.NewLimiter(rate.Limit(rps), burst),
		handler: handler,
	}
}

func (rl *RouteLimiter) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if !rl.limiter.Allow() {
		w.WriteHeader(http.StatusTooManyRequests)
		_, _ = w.Write([]byte("Too Many Requests for this endpoint\n"))
		return
	}
	rl.handler.ServeHTTP(w, r)
}

func loginHandler(w http.ResponseWriter, r *http.Request) {
	_, _ = fmt.Fprintln(w, "login ok")
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	_, _ = fmt.Fprintln(w, "hello")
}

func main() {
	mux := http.NewServeMux()

	// /login 限制为 3 rps, 突发 5
	mux.Handle("/login",
		NewRouteLimiter(3, 5, http.HandlerFunc(loginHandler)))

	// /hello 限制为 20 rps, 突发 40
	mux.Handle("/hello",
		NewRouteLimiter(20, 40, http.HandlerFunc(helloHandler)))

	srv := &http.Server{
		Addr:    ":8080",
		Handler: mux,
	}

	log.Println("listening on :8080")
	log.Fatal(srv.ListenAndServe())
}
