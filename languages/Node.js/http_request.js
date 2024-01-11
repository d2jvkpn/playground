function http(url, method, data=null) {
  let req = new XMLHttpRequest();
  // let url = new URL(window.location.href);
  // url = `${url.protocol}//${url.host}`;

  req.onload = (event) => {
    let res = null;

    if (req.status != 200) {
       console.log(`!!! status: ${req.status}`);
    }

    try {
      res = JSON.parse(req.responseText);
    } catch (e) {
      console.log(`!!! failed parse json:: ${e}`)
      return
    }

    if (res.code > 0) {
      console.log(`!!! response: code=${res.code}, msg=${res.msg}`);
      alert(`code=${res.code}, ${res.msg}`);
    }
  }

  req.open(method, url); // `${url}/api/post?id=${id}`

  if (data) {
    req.setRequestHeader("Content-Type", "application/json");
    req.send(JSON.stringify(data));
  }

  req.send();
}
