rs.initiate({
  _id : "shard-3",
  members: [
    { _id: 1, host: "mongo-shard-3a:27017" },
    { _id: 2, host: "mongo-shard-3b:27017" },
    { _id: 3, host: "mongo-shard-3c:27017" },
  ]
});
// { _id: 2, host: "mongo-shard-3c:27017", arbiterOnly: true },
