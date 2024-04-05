rs.initiate({
  _id : "shard-1",
  members: [
    { _id: 1, host: "mongo-shard-1a:27017" },
    { _id: 2, host: "mongo-shard-1b:27017" },
    { _id: 3, host: "mongo-shard-1c:27017" },
  ]
});
// { _id: 2, host: "mongo-shard-2c:27017", arbiterOnly: true },
