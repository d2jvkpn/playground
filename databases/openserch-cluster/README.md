# Opensearch
---
**version**: 0.1.0
**author**: [github.com/d2jvkpn]
**date**: 2025-01-13


#### C01. References
1. links
- https://github.com/opensearch-project/OpenSearch/tree/main
- https://opensearch.org/

#### C02. TODO
1. error01:
```text
[2025-01-13T02:01:43,299][INFO ][o.o.b.BootstrapChecks    ] [opensearch-node01] bound or publishing to a non-loopback address, enforcing bootstrap checks
ERROR: [1] bootstrap checks failed
[1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```

fix01
```
# sudo sysctl -w vm.max_map_count=262144
sudo cp /etc/sysctl.conf /etc/sysctl.conf.bk

sudo sysctl -a | grep vm.max_map_count

echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sudo sysctl --system
```

#### C03. Create a cluster
1. start

2. config opensearch-dashboards

3. add nodes

4. shutdown
