rs.initiate({
  _id : "shard-2",
  members: [
    { _id: 1, host: "mongo-shard-2a:27017" },
    { _id: 2, host: "mongo-shard-2b:27017" },
    { _id: 3, host: "mongo-shard-2c:27017" },
  ]
});
// { _id: 2, host: "mongo-shard-2c:27017", arbiterOnly: true },
