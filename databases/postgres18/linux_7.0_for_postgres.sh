# https://thebuild.com/blog/huge-pages-end-to-end/

#### explore
#postgres postgres -D /var/lib/postgresql/data -C shared_memory_size_in_huge_pages
psql -U postgres -d postgres -Atc 'SHOW shared_memory_size_in_huge_pages;'
# mini available memory: output * 2MiB
# mini vm.nr_hugepages >= output
# sudo sysctl -w vm.nr_hugepages=nr_hugepages

grep -E 'HugePages_Total|HugePages_Free|HugePages_Rsvd|Hugepagesize' /proc/meminfo

psql -U postgres -d postgres -Atc \
  'SHOW huge_pages_status;'

docker compose run --rm --no-deps --entrypoint postgres postgres:18-trixie \
  -D /var/lib/postgresql/18/docker \
  -C shared_memory_size_in_huge_pages

psql -U postgres -d postgres -x -c "
SELECT name, setting, unit
FROM pg_settings
WHERE name IN (
  'shared_buffers',
  'shared_memory_size',
  'shared_memory_size_in_huge_pages',
  'huge_pages',
  'huge_page_size',
  'huge_pages_status'
)
ORDER BY name;
"

psql -U postgres -d postgres -x -c "
SHOW huge_pages;
SHOW huge_pages_status;
SHOW shared_memory_size_in_huge_pages;
"

# Runtime (may fail if memory is too fragmented):
sysctl -w vm.nr_hugepages=50000

# Persistent:
echo 'vm.nr_hugepages = 50000' > /etc/sysctl.d/10-postgres-hugepages.conf
sysctl --system

# echo "huge_pages = on" >> 


```yaml docker-compose
command:
  - postgres
  - -c
  - huge_pages=on

cap_add: ["IPC_LOCK"]
ulimits:
  memlock: { soft: -1, hard: -1 }
```
