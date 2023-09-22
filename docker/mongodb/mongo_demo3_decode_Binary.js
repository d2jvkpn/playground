"use strict";

use products;
show collections;

db.getCollection("goods").find();

// Binary(Buffer.from("7b226f6b223a747275652c22726571...", "hex"), 0)
db.getCollection("goods").find().forEach((d) => print(d.data.toString()));

// d.toExtendedJSON()
// { '$binary': { base64: 'ey...' }}
