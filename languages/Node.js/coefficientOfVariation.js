const fs = require('node:fs');

//
const dataKeys = {
  stringVoltage: {type: "re", key: /^vpv+\d$/, name: "组串电压"},
  stringCurrent: {type: "re", key: /^ipv+\d$/, name: "组串电流"},
  // 交流电电流
  acVoltage: {type: "list", key: ["iac1", "iac2", "iac3"], name: "A相电流, B相电流, C相电流"},
  // 交流电电压
  acCurrent: {type: "list", key: ["vac1", "vac2", "vac3"], name: "A相电压, B相电压, C相电压"},
};

function coefficientOfVariation(data) {
  if (data.length == 0) {
    // throw new Error("Data array cannot be empty");
    return NaN;
  }

  // Calculate the mean
  const mean = data.reduce((sum, value) => sum + value, 0) / data.length;

  // Calculate the standard deviation
  const variance = data.reduce((sum, value) => sum + Math.pow(value - mean, 2), 0) / data.length;
  const standardDeviation = Math.sqrt(variance);

  // Calculate the coefficient of variation
  const cv = (standardDeviation / mean);

  return cv;
}

function getStringVC(data) {
  if (!data["list"]) { // not data.list
    console.log("~~~", data)
    return [];
  }

  const sortBy = (a, b) => Number(a.key.match(/\d+$/)[0]) < Number(b.key.match(/\d+$/)[0]);
  // 组串电压
  var vpvs = data.list.filter(e => dataKeys.stringVoltage.key.test(e.key)).sort(sortBy);
  // 组串电流
  var ipvs = data.list.filter(e => dataKeys.stringCurrent.key.test(e.key)).sort(sortBy);
  // vpvs.length === ipvs.length

  return vpvs.map(function(e, i) {
    return {
      key: Number(e.key.match(/\d+$/)[0]),
      voltage: Number(e.value),
      current: Number(ipvs[i].value),
    };
  });
}

// #### c01
var arr = [10, 12, 23, 23, 16, 23, 21, 16];
var cv = coefficientOfVariation(arr);
console.log("==> Coefficient of Variation:", (cv*100).toFixed(2) + "%");

// #### c02
fs.readFile("coefficientOfVariation.data.json", 'utf8', (err, bts) => {
  if (err) {
    console.error("!!! error:", err);
    return;
  }

  data = JSON.parse(bts);
  // console.log("==> data:", data);
  
  var stringVC = getStringVC(data);
  console.log("==> stringVC:", stringVC);

  var cv = coefficientOfVariation(stringVC.map(e => e.voltage * e.current));
  console.log("==> cv:", cv);
});

// #### c03
var bts = fs.readFileSync("coefficientOfVariation.data.json", 'utf8');
var data = JSON.parse(bts); // console.log("==>", data);

var stringVC = getStringVC(data);
console.log("==> stringVC:", stringVC);

var cv = coefficientOfVariation(stringVC.map(e => e.voltage * e.current));
console.log("==> cv:", cv);
