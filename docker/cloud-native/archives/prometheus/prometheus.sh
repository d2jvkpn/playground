#! /usr/bin/env bash
set -eu -o pipefail
_wd=$(pwd)
_path=$(dirname $0 | xargs -i readlink -f {})


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
