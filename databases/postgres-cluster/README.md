### PostgreSQL Classic Cluster: Replication
---

#### Ch01.

#### Ch02. TODO
1. 
```
postgres:
  read:
  - r01
  - r02
  write:
  - w01
  - w02
```

2. Postgres 17
-  pg_basebackup, pg_combinebackup
- ALTER TABLE [ IF EXISTS ] name SPLIT PARTITION partition_name INTO
  (PARTITION partition_name1 { FOR VALUES partition_bound_spec | DEFAULT },
    PARTITION partition_name2 { FOR VALUES partition_bound_spec | DEFAULT } [, ...])
- json_table, JSON、JSON_SCALAR、JSON_SERIALIZE, JSON_EXISTS、JSON_QUERY、JSON_VALUE
- MERGE INTO ... WHEN MATCHED THEN ... WHEN NOT MATCHED THEN ... RETURNING merge_action(), *;
WHEN NOT MATCHED BY SOURCE
