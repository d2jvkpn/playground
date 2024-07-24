const fs = require('node:fs');

var bts = fs.readFileSync("inverter_data_extraction_a01.json", 'utf8');
var data = JSON.parse(bts);

var currents = [], voltages = [];

data["list"].forEach(e => {
  if (/^ipv\d+/i.test(e.key)) {
    currents.push(e.value);
  } else if (/^vpv\d+/i.test(e.key)) {
    voltages.push(e.value);
  }
});

let size = Math.min(currents.length, voltages.length);

let result = Array.from({ length: size }, (_, i) => {
  return {name: "组串" + (i+1), current: currents[i], voltage: voltages[i]}
});

/* ==> Output:
[
  { name: '组串1', current: '11.3', voltage: '753.8' },
  { name: '组串2', current: '10.6', voltage: '761.8' },
  { name: '组串3', current: '11.0', voltage: '796.6' },
  { name: '组串4', current: '21.9', voltage: '753.1' },
  { name: '组串5', current: '0.0', voltage: '0.0' }
]
*/
