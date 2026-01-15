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

let created_at = new Date().toISOString();

let input = $items('FindScript')[0]?.json;
let input = $input.first()?.json?.scene;

return [{
  json: {
    ...input,
  }
}];
