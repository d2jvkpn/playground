const fs = require('fs');
const password = fs.readFileSync("/app/configs/secret.txt", 'utf8').split(/\s+/g)[0].trim();

const db = connect("admin");
db.auth("root", password);

sh.addShard("shard-1/mongo-shard-1a:27017,mongo-shard-1b:27017,mongo-shard-1c:27017");
sh.addShard("shard-2/mongo-shard-2a:27017,mongo-shard-2b:27017,mongo-shard-2c:27017");
sh.addShard("shard-3/mongo-shard-3a:27017,mongo-shard-3b:27017,mongo-shard-3c:27017");
