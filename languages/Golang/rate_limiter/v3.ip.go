package main

import (
	"fmt"
	"log"
	"net"
	"net/http"
	"sync"
	"time"

	"golang.org/x/time/rate"
)

type IPRateLimiter struct {
	mu       sync.Mutex
	limiters map[string]*rate.Limiter
	rps      float64
	burst    int
}

func NewIPRateLimiter(rps float64, burst int) *IPRateLimiter {
	return &IPRateLimiter{
		limiters: make(map[string]*rate.Limiter),
		rps:      rps,
		burst:    burst,
	}
}

func (i *IPRateLimiter) getLimiter(ip string) *rate.Limiter {
	i.mu.Lock()
	defer i.mu.Unlock()

	limiter, exists := i.limiters[ip]
	if !exists {
		limiter = rate.NewLimiter(rate.Limit(i.rps), i.burst)
		i.limiters[ip] = limiter
	}
	return limiter
}

func (i *IPRateLimiter) Middleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		ip, _, err := net.SplitHostPort(r.RemoteAddr)
		if err != nil {
			// 获取不到 IP，就当成一个特殊 key
			ip = "unknown"
		}

		limiter := i.getLimiter(ip)
		if !limiter.Allow() {
			w.WriteHeader(http.StatusTooManyRequests)
			_, _ = w.Write([]byte("Too Many Requests from this IP\n"))
			return
		}

		next.ServeHTTP(w, r)
	})
}

func loginHandler(w http.ResponseWriter, r *http.Request) {
	_, _ = fmt.Fprintln(w, "login ok")
}

func main() {
	ipLimiter := NewIPRateLimiter(
		10.0/60.0, // 10 req/min ≈ 0.1667 rps
		5,         // 突发 5 次
	)

	mux := http.NewServeMux()
	mux.HandleFunc("/login", loginHandler)

	limited := ipLimiter.Middleware(mux)

	srv := &http.Server{
		Addr:         ":8080",
		Handler:      limited,
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 5 * time.Second,
	}

	log.Println("listening on :8080")
	log.Fatal(srv.ListenAndServe())
}
