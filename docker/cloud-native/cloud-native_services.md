# Prometheus Pushgateway
---
**date**: 2024-07-25

#### C01. Prometheus Pushgateway
```bash
docker pull prom/pushgateway:latest

docker run --name prom-pushgateway -d -p 9091:9091 prom/pushgateway:latest

echo "some_metric 3.14" | curl http://localhost:9091/metrics/job/some_job --data-binary @- 
```

```yaml
scrape_configs:
- job_name: 'pushgateway'
  static_configs:
  - targets: ['prom-pushgateway:9091']
```

#### C02. Postgres Exporter
```yaml
version: "3"

services:
  postgres-exporter:
    image: quay.io/prometheuscommunity/postgres-exporter
    networks: [net]
    ports: ["9187:9187"]
    # environment:
    #   DATA_SOURCE_NAME: postgresql://account:password@127.0.0.1:5432/database?sslmode=disable
    #   DATA_SOURCE_URI="localhost:5432/postgres?sslmode=disable" \
    #   DATA_SOURCE_USER=postgres \
    #   DATA_SOURCE_PASS=password \
    volumes:
    - ./configs/postgres_exporter.yaml:/app/configs/postgres_exporter.yaml
    command: --config.file=/app/configs/postgres_exporter.yaml

networks:
  net: { name: net, driver: bridge, external: false }
```

#### C03.
``` promsql
rate(node_network_receive_bytes_total{device="eth0"}[1m])
rate(node_network_transmit_bytes_total{device="eth0"}[1m])

rate(node_cpu_seconds_total{mode="system"}[1m])

sum by (code) (rate(http_response[1m]))
sum by (code, kind) (rate(http_response{code!="OK"}[1m]))

go_goroutines{job="app_dev"}
go_threads

go_memstats_alloc_bytes{job="app_dev"}/1024/1024
go_memstats_sys_bytes{job="app_dev"}/1024/1024
go_gc_duration_seconds{job="app_dev"}
```
