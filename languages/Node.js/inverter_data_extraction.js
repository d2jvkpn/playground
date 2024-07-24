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
/* ==> Result:
[
  { name: '组串1', current: '11.3', voltage: '753.8' },
  { name: '组串2', current: '10.6', voltage: '761.8' },
  { name: '组串3', current: '11.0', voltage: '796.6' },
  { name: '组串4', current: '21.9', voltage: '753.1' },
  { name: '组串5', current: '0.0', voltage: '0.0' }
]
*/
