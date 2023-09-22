### Title
---

#### tutorials
- https://www.youtube.com/watch?v=J0ErkLo2b1E
- https://www.youtube.com/watch?v=GIsD1BgFnWc
- https://blog.digitalis.io/using-hashicorp-consul-with-postgresql-for-high-availability-with-no-load-balancers-needed-ed89dbafe693
- https://dba.stackexchange.com/questions/302263/converting-master-node-to-slave-node-in-postgresql-streaming-replication-scenari
  - set primary_conninfo correctly in postgresql.conf
  - create the standby.signal file in the data directory
  - start the server

#### common issues with automatic replica promotion
- Split-brain
- Automatic configuration updates
- Service discovery
- How to failback/failover
