### MongoDB Sharded Cluster
---

#### chapter 1

#### chapter 2: ChatGPT 2023-06-30
以下是一些常用的 MongoDB 命令，用于管理和操作分片集群中的 mongos 服务和分片节点：

##### 连接和管理 mongos 服务：
- mongos：启动 mongos 服务。
- mongos --configdb <configdb connection string>：指定配置服务器的连接字符串来启动 mongos 服务。
- mongo --host <mongos host>:<port>：连接到运行中的 mongos 服务。

##### 分片相关操作：
- sh.status()：查看当前分片集群的状态，包括分片信息、配置服务器信息、分片键等。
- sh.addShard("<shard connection string>")：将一个分片添加到集群中。
- sh.removeShard("<shard name>")：从集群中移除指定名称的分片。
- sh.enableSharding("<database>")：启用指定数据库的分片功能。
- sh.shardCollection("<namespace>", <shard key>)：对指定命名空间的集合进行分片。

#####分片平衡和迁移：
- sh.startBalancer()：启动分片平衡过程。
- sh.stopBalancer()：停止分片平衡过程。
- sh.isBalancerRunning()：检查分片平衡器的运行状态。
- sh.moveChunk("<namespace>", <shard key>, "<target shard>")：手动将指定分片键的 chunk 迁移到目标分片。

##### 健康和状态：
- db.getSiblingDB("admin").runCommand({replSetGetStatus: 1})：获取副本集的状态。
- db.getSiblingDB("admin").runCommand({isMaster: 1})：检查节点是否为主节点。
- db.getSiblingDB("admin").runCommand({replSetStepDown: <seconds>})：使主节点放弃主导地位并触发选举。

这些命令提供了基本的功能和控制，用于管理和操作 MongoDB 分片集群中的 mongos 服务和分片节点。更多详细的命令和参数，请参考 MongoDB 官方文档。
