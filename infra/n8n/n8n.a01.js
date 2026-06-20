/*
let created_at = new Date().toISOString();

let input = $items('FindScript')[0]?.json;
let input = $input.first()?.json?.scene;

return [{
  json: {
    ...input,
  }
}];
*/

function genKey() {
  const date = new Date();
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');
  const milliseconds = String(date.getMilliseconds()).padStart(3, '0');

  const timestamp = `${year}${month}${day}${hours}${minutes}${seconds}${milliseconds}`;
  const random = String(Math.floor(Math.random() * 1000)).padStart(3, '0');

  return timestamp + random;
}

function checkArrary(v) {
  return Array.isArray(v) && v.length > 0;
}

function calcResolution(height, aspect_ratio) {
  let [w, h] = aspect_ratio.split(":").map(e => Number(e));
  let width = Math.round(height * w / h / 2) * 2;

  return { width, height };
}

function toResolution(aspectRatio, resolutionP, mode = "industry") {
  const [wR, hR] = aspectRatio.split(":").map(Number);
  if (!wR || !hR) {
    throw new Error("Invalid aspectRatio");
  }

  let width, height;

  if (mode === "industry" && aspectRatio === "9:16") {
    width = resolutionP;
    height = Math.round((resolutionP * hR) / wR);
  } else {
    height = resolutionP;
    width = Math.round((height * wR) / hR);
  }

  width = Math.floor(width / 2) * 2;
  height = Math.floor(height / 2) * 2;

  return { width, height };
}

function parseJson(text) {
  const cleaned = text
    .trim()
    .replace(/^```(?:json)?\s*/i, '')
    .replace(/```$/i, '')
    .trim();

  try {
    return JSON.parse(cleaned);
  } catch (e) {
    throw new Error(`JSON parse failed: ${e.message}`);
  }
}
