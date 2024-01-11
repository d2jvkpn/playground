http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
	go lb(w, r)
})

func lb(w http.ResponseWriter, r *http.Request) {
	peer := serverPool.NextBackend()
	if peer != nil {
		proxy := httputil.NewSingleHostReverseProxy(peer)
		proxy.ServeHTTP(w, r)
	} else {
		http.Error(w, "No servers available", http.StatusServiceUnavailable)
	}
}
