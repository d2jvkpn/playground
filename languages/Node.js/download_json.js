function utf8ToBase64(str) {
  const chunk = 0x8000;

  const bytes = new TextEncoder().encode(str);
  let binary = "";

  for (let i = 0; i < bytes.length; i += chunk) {
    binary += String.fromCharCode.apply(null, bytes.subarray(i, i + chunk));
  }

  return btoa(binary);
}


function download_json(data, filname) {
  let jsonStr = JSON.stringify(data, null, 2);
  let b64 = utf8ToBase64(jsonStr); // btoa(jsonStr)

  const a = document.createElement('a');
  a.href = "data:application/json;base64," + b64;
  a.download = filname;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);

  return true;
}

function getTimestamp() {
  const d = new Date();
  const yyyy = d.getFullYear();
  const mm = String(d.getMonth() + 1).padStart(2, "0");
  const dd = String(d.getDate()).padStart(2, "0");
  const s = Math.floor(d.getTime() / 1000); // 秒级时间戳
  return `${yyyy}-${mm}-${dd}-${s}`;
}
