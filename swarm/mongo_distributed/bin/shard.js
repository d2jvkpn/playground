// let shard = shard

rs.initiate({
  _id : shard,
  members: [
    { _id: 1, host: `mongo-${shard}a:27017` },
    { _id: 2, host: `mongo-${shard}b:27017` },
    { _id: 3, host: `mongo-${shard}c:27017` },
  ]
});
// { _id: 2, host: "mongo-shard-1c:27017", arbiterOnly: true },
