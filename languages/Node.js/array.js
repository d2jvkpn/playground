//
const a = [1, 2, 3, 4, 5];
const b = [2, 4];

const filteredArray = a.filter(element => !b.includes(element));

console.log(filteredArray);
