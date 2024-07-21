//
var dataKeys = {
  stringCurrent: {type: "re", value: /^vpv+\d$/, name: "组串电压"},
  stringVoltage: {type: "re", value: /^ipv+\d$/, name: "组串电流"},
  // 交流电电流
  acVoltage: {type: "list", value: ["iac1", "iac2", "iac3"], name: "A相电流, B相电流, C相电流"},
  // 交流电电压
  acCurrent: {type: "list", value: ["vac1", "vac2", "vac3"], name: "A相电压, B相电压, C相电压"},
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

var data = [10, 12, 23, 23, 16, 23, 21, 16];
var cv = coefficientOfVariation(data);
console.log("Coefficient of Variation:", (cv*100).toFixed(2) + "%");
