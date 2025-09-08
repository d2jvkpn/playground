// 1.
const path = require("path");

const express = require("express");

// 2.
function toRFC3339Local(date = new Date()) {
  const pad = (n) => String(n).padStart(2, "0");

  const day = `${date.getFullYear()}-${pad(date.getMonth()+1)}-${pad(date.getDate())}`;
  const time = `${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`;

  const offset = -date.getTimezoneOffset();
  const sign = offset >= 0 ? "+" : "-";
  const absOffset = Math.abs(offset);
  const tzOffset = `${sign}${pad(Math.floor(absOffset / 60))}:${pad(absOffset % 60)}`;

  return `${day}T${time}${tzOffset}`;
}

// 3.
const app = express();
const host = process.argv[2] || "127.0.0.1";
const port = parseInt(process.argv[3], 10) || 3000;

// 4.
app.use("/assets", express.static(path.join(__dirname, "assets")));

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "index.html"));
});

// 5.
app.listen(port, host, () => {
  // const timestamp = new Date().toISOString(); 
  console.log(`[${toRFC3339Local()}] Server running at http://${host}:${port}`);
});
