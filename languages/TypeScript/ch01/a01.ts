interface Person {
  name: string;
  age: number;
}

function isEligible(personObj: Person) {
  return personObj.age;
}

let john = {
  name: "Josh",
  age: 23
};

console.log("~~~", isEligible(john));
