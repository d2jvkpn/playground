// mongosh mongodb://root@127.0.0.1:27017/admin
// db = connect("admin");
// db.auth("root", "root");
// show dbs;

let userExists = db.system.users.find({user: "hello" }).count() > 0;

// can't be executed by mongosh script.js: use backend;
// connect doesn't work for auth: db = connect("backend");
console.log("~~~ connect to backend");
db = db.getSiblingDB('backend');

if (!userExists) {
  console.log("~~~ create user hello");

  db.createUser(
    {
      user: "hello",
      pwd: "world", // passwordPrompt(),
      // customData: { employeeId: 12345 },
      roles: [{ role: "readWrite", db: "backend" }],
    },
    { w: "majority" , wtimeout: 5000 },
  );
}
// db.changeUserPassword("hello", passwordPrompt());
// db.dropUser("hello", {w: "majority", wtimeout: 5000});

db.auth("hello", "world");
// db.dropDatabase();
// db.getUser("hello");

// mongosh mongodb://hello@127.0.0.1:27017/backend
db.runCommand({connectionStatus: 1});

if (!db.getCollectionNames().find(v => v === "accounts")) {
  console.log("~~~ create collection accounts");
  db.createCollection("accounts");
}

console.log("~~~ insert into accounts");
db.getCollection("accounts").insertOne({username: "rover", age: 32});
db.getCollection("accounts").insertOne({username: "alice", age: 27});
// db.getCollection("accounts").find();
