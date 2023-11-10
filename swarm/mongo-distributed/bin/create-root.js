const fs = require('fs');

const password = fs.readFileSync("/app/configs/mongo.secret", 'utf8').split(/\s+/g)[0].trim();
const db = connect('admin');

// db.getUsers({filter: {'user': 'root'}}).users.length == 0
try {
  db.createUser({user:"root", pwd: password, roles: [{role: "root", db: "admin"}]});
} catch (err) {
  print (`!!! can't create user: ${err.message}`);
}

// db = connect('admin');
// db.auth("root", "root");
