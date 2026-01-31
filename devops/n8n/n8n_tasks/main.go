package main

import (
	"bytes"
	"context"
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"math"
	mrand "math/rand"
	"net"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type SubmitRequest struct {
	JobID       string `json:"job_id"`
	CallbackURL string `json:"callback_url"`
	Payload     any    `json:"payload,omitempty"`

	SimulateSeconds int     `json:"simulate_seconds,omitempty"`
	FailProb        float64 `json:"fail_prob,omitempty"`
}

type SubmitResponse struct {
	JobID  string `json:"job_id"`
	TaskID string `json:"task_id"`
	Status string `json:"status"`
}

type CallbackPayload struct {
	Code      string    `json:"code"` // ok | failed
	Reason    string    `json:"reason,omitempty"`
	JobID     string    `json:"job_id"`
	TaskID    string    `json:"task_id"`
	StartedAt time.Time `json:"started_at"`
	EndedAt   time.Time `json:"ended_at"`
	Result    any       `json:"result,omitempty"`
}

func main() {
	var (
		listenAddr = flag.String("listen", ":8080", "listen address, e.g. :8080 or 0.0.0.0:8080")
		simSeconds = flag.Int("simulate", 3, "default simulated processing seconds")
		failProb   = flag.Float64("failProb", 0.0, "default failure probability in [0,1]")
		timeout    = flag.Duration("timeout", 10*time.Second, "callback http client timeout, e.g. 5s")
		retries    = flag.Int("retries", 3, "callback retries (0 means no retry)")
		token      = flag.String("token", "", "optional X-Callback-Token header value for callbacks")
	)
	flag.Parse()

	if *failProb < 0 || *failProb > 1 {
		log.Fatalf("invalid -failProb: %.3f (must be within [0,1])", *failProb)
	}

	mrand.Seed(time.Now().UnixNano())

	r := gin.New()
	r.Use(gin.Logger(), gin.Recovery())

	r.GET("/healthz", func(c *gin.Context) {
		c.String(http.StatusOK, "ok")
	})

	r.POST("/submit", func(c *gin.Context) {
		var req SubmitRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{
				"code":   "bad_request",
				"reason": "invalid json: " + err.Error(),
			})
			return
		}
		if req.CallbackURL == "" {
			c.JSON(http.StatusBadRequest, gin.H{
				"code":   "bad_request",
				"reason": "missing callback_url",
			})
			return
		}

		taskID := newID(12)
		if req.JobID == "" {
			req.JobID = taskID
		}

		taskSim := *simSeconds
		if req.SimulateSeconds >= 0 {
			taskSim = req.SimulateSeconds
		}
		taskFail := *failProb
		if req.FailProb >= 0 && req.FailProb <= 1 {
			taskFail = req.FailProb
		}

		var data = SubmitResponse{
			JobID:  req.JobID,
			TaskID: taskID,
			Status: "queued",
		}

		c.JSON(http.StatusAccepted, gin.H{
			"code": "ok",
			"data": data,
		})

		go func(jobID, taskID, callback string, payload any, sim int, fp float64) {
			start := time.Now()
			log.Printf("[task=%s job=%s] accepted simulate=%ds failProb=%.2f callback=%s",
				taskID, jobID, sim, fp, callback)

			time.Sleep(time.Duration(sim) * time.Second)

			ok := mrand.Float64() >= fp
			end := time.Now()

			cb := CallbackPayload{
				TaskID:    taskID,
				JobID:     jobID,
				StartedAt: start,
				EndedAt:   end,
			}

			if ok {
				cb.Code = "ok"
				cb.Result = gin.H{
					"score":   mrand.Intn(100),
					"payload": payload,
				}
			} else {
				cb.Code = "failed"
				cb.Reason = "simulated failure"
			}

			if err := postCallbackWithRetry(callback, cb, *timeout, *retries, *token); err != nil {
				log.Printf("[task=%s job=%s] callback FAILED: %v", taskID, jobID, err)
				return
			}
			log.Printf("[task=%s job=%s] callback delivered", taskID, jobID)
		}(req.JobID, taskID, req.CallbackURL, req.Payload, taskSim, taskFail)
	})

	log.Printf("mock gin service listening on %s", *listenAddr)
	if err := r.Run(*listenAddr); err != nil {
		log.Fatal(err)
	}
}

func postCallbackWithRetry(url string, payload CallbackPayload, timeout time.Duration, retries int, token string) error {
	body, _ := json.Marshal(payload)

	client := &http.Client{
		Timeout: timeout,
		Transport: &http.Transport{
			Proxy: http.ProxyFromEnvironment,
			DialContext: (&net.Dialer{
				Timeout:   5 * time.Second,
				KeepAlive: 30 * time.Second,
			}).DialContext,
			MaxIdleConns:        50,
			IdleConnTimeout:     90 * time.Second,
			TLSHandshakeTimeout: 5 * time.Second,
		},
	}

	var lastErr error
	for attempt := 0; attempt <= retries; attempt++ {
		if attempt > 0 {
			backoff := time.Duration(500*math.Pow(2, float64(attempt-1))) * time.Millisecond
			time.Sleep(backoff)
		}

		req, _ := http.NewRequestWithContext(context.Background(), http.MethodPost, url, bytes.NewReader(body))
		req.Header.Set("Content-Type", "application/json")
		if token != "" {
			req.Header.Set("x-callback-token", token)
		}

		resp, err := client.Do(req)
		if err != nil {
			lastErr = err
			continue
		}
		_ = resp.Body.Close()

		if resp.StatusCode >= 200 && resp.StatusCode < 300 {
			return nil
		}
		lastErr = fmt.Errorf("non-2xx status: %d", resp.StatusCode)
	}
	return lastErr
}

func newID(nBytes int) string {
	b := make([]byte, nBytes)
	_, _ = rand.Read(b)
	return hex.EncodeToString(b)
}
