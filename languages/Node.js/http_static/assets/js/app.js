function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

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

document.addEventListener("DOMContentLoaded", async () => {
  const msg = document.getElementById("message");

  await sleep(3000);

  msg.textContent = `[${toRFC3339Local()}] JS has been loaded successfully!`; // ✅
});
