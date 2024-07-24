const fs = require('node:fs');

let bts = fs.readFileSync("inverter_data_extraction_a01.json", 'utf8');
let data = JSON.parse(bts);

let currents = [], voltages = [];

data["list"].forEach(e => {
  if (/^ipv\d+$/i.test(e.key)) {
    e._order = Number(e.key.match(/\d+$/)[0]);
    currents.push(e);
  } else if (/^vpv\d+$/i.test(e.key)) {
    e._order = Number(e.key.match(/\d+$/)[0]);
    voltages.push(e);
  }
});

currents.sort((a, b) => (a._order > b._order) ? 1 : ((b._order > a._order) ? -1 : 0));
voltages.sort((a, b) => (a._order > b._order) ? 1 : ((b._order > a._order) ? -1 : 0));

let size = Math.min(currents.length, voltages.length);

let result = Array.from({ length: size }, (_, i) => {
  return {name: "组串" + (i+1), current: currents[i].value, voltage: voltages[i].value};
});

console.log("==> Currents:", currents);
console.log("==> Voltages:", voltages);
console.log("==> Result:", result);
