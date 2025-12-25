"use strict";

// database contacts
show dbs;
use home;
db;
db.createCollection("contacts");
show collections;
db.getCollectionNames();

db.users.find().pretty();

db.contacts.insert({
  "name": "Jon Wexler",
  "email": "jon@jonwexler.com",
  "note": "Decent guy.",
});


var coll = db.getCollection("contacts");

coll.findOne();
coll.find().pretty();

db.contacts.find({"_id": ObjectId("604afd43241818278390169b")}).limit(1);

db.contacts.updateOne({"name": "Jon Wexler"}, {"name": "Jon_Wexler"});

// change user password
db = db.getSiblingDB('admin');
db.changeUserPassword("root", passwordPrompt());

use products;
db.changeUserPassword("hello", passwordPrompt());


db.tasks.findOne({ status: "success" });

db.tasks.find(
  { status: "success" },
  {}, // { title: 1, status: 1, create_time: 1, _id: 0 }
).sort({ create_time: -1 }).skip(10).limit(2);
