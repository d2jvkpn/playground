# Prometheus Pushgateway
---
**date**: 2024-07-25

#### C01. chapter1
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
