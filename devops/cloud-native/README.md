### Cloud Native
---


#### ch01. References
- https://github.com/open-telemetry/opentelemetry-collector/blob/main/docs/design.md
- https://www.jaegertracing.io/docs/1.45/getting-started/
- https://www.jaegertracing.io/docs/1.45/deployment/
- https://prometheus.io/docs/prometheus/latest/configuration/configuration/
- https://prometheus.io/docs/practices/remote_write/
- https://opentelemetry.io/docs/collector/configuration/
- https://gabrieltanner.org/blog/collecting-prometheus-metrics-in-golang/
- https://prometheus.io/docs/prometheus/latest/getting_started/
- https://hub.docker.com/r/prom/prometheus
- https://hub.docker.com/r/grafana/grafana/tags
- https://povilasv.me/prometheus-go-metrics/
- https://prometheus.io/docs/guides/basic-auth/


#### ch02. Prometheus & Grafana
```bash
docker pull prom/prometheus:main
docker pull grafana/grafana:main
docker-compose up -d

#### reset grafana password
docker exec -it grafana grafana-cli admin reset-admin-password admin

ls -alh /var/lib/docker/volumes/go-web_grafana-storage/_data

grafana_url=http://192.168.1.1:3022 # username: admin, password: admin
# add prometheus data source: $prom_url/metrics
prom_url=http://192.168.1.1:3023

curl $prom_url/metrics

exit

# promhttp_metric_handler_requests_total{code="200"}
# promhttp_metric_handler_requests_total{code="200", instance="192.168.0.8:3023", job="prometheus"}

process_cpu_seconds_total
# process_cpu_seconds_total{instance="192.168.0.8:3023", job="prometheus"}
go_goroutines
# go_goroutines{instance="192.168.0.8:3023", job="prometheus"}
go_gc_duration_seconds{quantile="0.75"}
go_threads
go_memstats_sys_bytes
# process_resident_memory_bytes
go_memstats_alloc_bytes

go tool pprof -svg $prom_url/debug/pprof/heap > heap.svg.out

$prom_url/graph?g0.expr=go_goroutines&g0.tab=0&g0.stacked=0&g0.show_exemplars=0&g0.range_input=1h&g0.step_input=5&g1.expr=go_gc_duration_seconds%7Bquantile%3D%220.75%22%7D&g1.tab=0&g1.stacked=0&g1.show_exemplars=0&g1.range_input=1h&g1.step_input=5&g2.expr=go_threads&g2.tab=0&g2.stacked=0&g2.show_exemplars=0&g2.range_input=1h&g2.step_input=5&g3.expr=go_memstats_sys_bytes&g3.tab=0&g3.stacked=0&g3.show_exemplars=0&g3.range_input=1h&g3.step_input=5&g4.expr=go_memstats_alloc_bytes&g4.tab=0&g4.stacked=0&g4.show_exemplars=0&g4.range_input=1h&g4.step_input=5
```

#### ch03. Prometheus Pushgateway PromSQL
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
