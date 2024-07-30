# Prometheus Pushgateway
---
**date**: 2024-07-25

#### C01. PromSQL
``` promsql
sum by (code) (rate(http_response[1m]))
sum by (code, kind) (rate(http_response{code!="OK"}[1m]))

go_goroutines{job="app_dev"}
go_threads

go_memstats_alloc_bytes{job="app_dev"}/1024/1024
go_memstats_sys_bytes{job="app_dev"}/1024/1024

go_gc_duration_seconds{job="app_dev"}

rate(node_network_receive_bytes_total{device="eth0"}[1m])
rate(node_network_transmit_bytes_total{device="eth0"}[1m])

rate(node_cpu_seconds_total{mode="system"}[1m])
```
