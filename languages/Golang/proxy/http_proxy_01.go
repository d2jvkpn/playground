package main

import (
    "io"
    "net/http"
    "log"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        resp, err := http.DefaultClient.Do(r)
        if err != nil {
            http.Error(w, "Error making request", http.StatusInternalServerError)
            return
        }
        defer resp.Body.Close()

        for name, values := range resp.Header {
            for _, value := range values {
                w.Header().Add(name, value)
            }
        }

        _, err = io.Copy(w, resp.Body)
        if err != nil {
            http.Error(w, "Error copying body", http.StatusInternalServerError)
            return
        }
    })

    log.Fatal(http.ListenAndServe(":8080", nil))
}

