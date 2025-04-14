function datetime(at=null) {
  if (!at) { at = new Date(); }

  function padZeros (value, len=2) { return value.toString().padStart(len, '0')}

  function timezoneOffset(offset) {
    if (offset === 0) { return "Z"; }

    let hour = padZeros(Math.floor(Math.abs(offset) / 60));
    let minute = padZeros(Math.abs(offset) % 60);
    return `${(offset < 0) ? "+" : "-"}${hour}:${minute}`;
  }

  at.date = `${at.getFullYear()}-${padZeros(at.getMonth() + 1)}-${padZeros(at.getDate())}`;
  at.time = `${padZeros(at.getHours())}:${padZeros(at.getMinutes())}:${padZeros(at.getSeconds())}`;
  at.ms = padZeros(at.getMilliseconds(), 3);
  at.tz = timezoneOffset(at.getTimezoneOffset());

  at.datetime = `${at.date}T${at.time}`;
  at.rfc3339 = at.datetime + `${at.tz}`;
  at.rfc3339ms = at.datetime + `.${at.ms}${at.tz}`;

  return at;
  // ts = new Date(at.rfc3339).getTime()
}
