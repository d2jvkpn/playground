//
const a = [1, 2, 3, 4, 5];
const b = [2, 4];

const filteredArray = a.filter(element => !b.includes(element));

console.log(filteredArray);


const products = [
  { name: 'Laptop', price: 1000 },
  { name: 'Phone', price: 500 },
  { name: 'Tablet', price: 700 }
];

products.sort((a, b) => a.price <= b.price ? -1 : 1);
