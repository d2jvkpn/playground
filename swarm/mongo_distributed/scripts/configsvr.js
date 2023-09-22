// rs.status();
// var configsvr_id='configsvr-1';

rs.initiate({
  _id: configsvr_id,
  members: [
    { _id: 1, host: `mongo-${configsvr_id}a:27017` },
    { _id: 2, host: `mongo-${configsvr_id}b:27017` },
    { _id: 3, host: `mongo-${configsvr_id}c:27017` },
  ],
});
