function isEligible(personObj) {
    return personObj.age;
}
var john = {
    name: "Josh",
    age: 23
};
console.log("~~~", isEligible(john));
