# Prometheus Pushgateway
---
**date**: 2024-07-25

#### C01. PromSQL
``` promsql
sum by (code) (rate(http_response[1m]))
sum by (code, kind) (rate(http_response{code!="OK"}[1m]))

sum(rate(http_latency_bucket{job="app_dev",le="+Inf"}[5m])) - sum(rate(http_latency_bucket{job="app_dev",le="10"}[5m]))
histogram_quantile(0.95, sum by(le) (rate(http_latency_bucket{job="app_dev"}[5m])))

rate(http_latency_sum[5m]) / rate(http_latency_count[5m])

go_goroutines{job="app_dev"}
go_threads

go_memstats_alloc_bytes{job="app_dev"}/1024/1024
go_memstats_sys_bytes{job="app_dev"}/1024/1024

go_gc_duration_seconds{job="app_dev"}

rate(node_network_receive_bytes_total{device="eth0"}[1m])
rate(node_network_transmit_bytes_total{device="eth0"}[1m])

rate(node_cpu_seconds_total{mode="system"}[1m])

(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes)/1024/1024
(node_memory_SwapTotal_bytes - node_memory_SwapFree_bytes)/1024/1024
```
