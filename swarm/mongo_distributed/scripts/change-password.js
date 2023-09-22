db = connect("admin");
db.auth("root", "root");

console.log(">>> Enter new password:");
db.changeUserPassword("root", passwordPrompt());
