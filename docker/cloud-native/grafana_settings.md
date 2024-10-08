# Grafana Settings
---

#### C01. Containers
1. container's cpu(ms/min)
- sum by(name) (rate(container_cpu_system_seconds_total{job="otel-node-cadvisor", name=~"joyn-.*"}[1m]))*1000

2. container's memory(mb)
- sum by(name) (container_memory_usage_bytes-container_memory_cache{job="otel-node-cadvisor", name=~"joyn-.*"})/1024/1024

3. container's network transmit(kb/min)
- sum by(name) (rate(container_network_transmit_bytes_total{job="otel-node-cadvisor", name=~"joyn-.*"}[1m])) /1024

4. container's network receive(kb/min)
- sum by(name) (rate(container_network_receive_bytes_total{job="otel-node-cadvisor", name=~"joyn-.*"}[1m])) /1024

#### C02. Jaeger
1. app-name
- Service Name: app-name
- Operation Name: All

#### C03. aliyun-a01
1. CPU(ms/min)
sum by (cpu) (rate(node_cpu_seconds_total{job="otel-node-metrics", mode="system"}[1m]))*1000

2. Disk I/O(mb/min)
- sum by (__name__) (rate (node_disk_read_bytes_total{job="otel-node-metrics", device="vda"}[1m])/1024/1024)
- sum by (__name__) (rate (node_disk_written_bytes_total{job="otel-node-metrics", device="vda"}[1m])/1024/1024)

3. Memory(mb)
- (node_memory_MemTotal_bytes{job="otel-node-metrics"} / 1024 / 1024) - (node_memory_MemAvailable_bytes{job="otel-node-metrics"} / 1024 / 1024)

4. Networks(kb/min): Receive vs Transmit
- rate(node_network_receive_bytes_total{job="otel-node-metrics",device="eth0"}[1m]) / 1024
- rate(node_network_transmit_bytes_total{job="otel-node-metrics", device="eth0"}[1m]) / 1024

#### C04. app-name
1. rps_codes(1min)
- sum by(code) (rate(http_code_total{exported_job="app-name"}[1m]))

2. rps_errors(1m)
- sum by(code, kind) (rate(http_code_total{code!="OK", exported_job="app-name"}[1m]))

3. rps_api(1m)
- sum by(api) (rate(http_code_total{exported_job="app-name"}[1m]))

4. http_latency(ms)
- sum by (api) (rate(http_latency_sum{exported_job="app-name"}[5m]) / rate(http_latency_count[5m]))

5. http_latency p99
- histogram_quantile(0.99, sum by(le) (rate(http_latency_bucket{exported_job="app-name"}[5m])))

6. database_connections
- sum by (type) (db_conns{exported_job="app-name"})

7. go_gc_duration(ms)
- go_gc_duration_seconds{job="app-name"}*1000

8. go_memstats(mb): alloc vs sys
- sum by (__name__) (go_memstats_alloc_bytes{job="app-name"}/1024/1024)
- sum by (__name__) (go_memstats_sys_bytes{job="app-name"}/1024/1024)

9. goruntines vs go-threads
- sum by (__name__) (go_goroutines{job="app-name"})
- sum by (__name__) (go_threads{job="app-name"})
