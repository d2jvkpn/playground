/*
- firefox: about:config, devtools.selfxss.count = 100
- chromium/chrome: TODO
*/

function parseComment(item) {
  // var item = comments[0];
  var user = item.querySelector("div.user-info");

  var comment = {
    user_avatar: user.firstChild.src,
    user_name: user.children[1].innerText,
    user_level: user.children[2].src.split('/').slice(-1)[0].replace(/\..*/, ''),
    deal_model: item.querySelector(".deal-sku-value").innerText,
    deal_number: item.querySelector('span.deal-num-value').textContent,
    comment_time: item.querySelector('span.deal-date-value').textContent,
    comment_content: item.querySelector('div.evaluate-desc').textContent,
  };

  return comment;
}

function datetime(at=null) {
  if (!at) {
    at = new Date();
  }

  function padH0 (value, len=2) { return value.toString().padStart(len, '0')}

  function timezoneOffset(offset) {
    if (offset === 0) {
      return "Z";
    }

    let hour = padH0(Math.floor(Math.abs(offset) / 60));
    let minute = padH0(Math.abs(offset) % 60);
    return `${(offset < 0) ? "+" : "-"}${hour}:${minute}`;
  }

  at.date = `${at.getFullYear()}-${padH0(at.getMonth() + 1)}-${padH0(at.getDate())}`;
  at.time = `${padH0(at.getHours())}:${padH0(at.getMinutes())}:${padH0(at.getSeconds())}`;
  at.ms = padH0(at.getMilliseconds(), 3);
  at.tz = timezoneOffset(at.getTimezoneOffset());

  at.datetime = `${at.date}T${at.time}`;
  at.rfc3339 = at.datetime + `${at.tz}`;
  at.rfc3339ms = at.datetime + `.${at.ms}${at.tz}`;

  return at; // ts: new Date(at.rfc3339).getTime()
}

function pageInfo() {
  // _btn_next = document.querySelector("button.next-next");
  // var _btn_confirm = document.querySelector("next-btn-helper");
  // _btn_next.addEventListener('click', () => getComments().forEach(e => comments.push(e)));
  // _btn_confirm.addEventListener('click', () => download(comments));

  var shop_elem = document.querySelector("#hd").children[0].children[0].children[0];
  var sale_elems = document.querySelector("div.title-sale-column").children;
  var images = document.querySelectorAll("img.detail-gallery-img");
  var url = new URL(document.URL);
  var now = datetime();
  // now.toISOString().replace(/:/g, "-").replace(".", "-")

  var download = url.host + "-" + 
    url.pathname.split('/').slice(-1)[0].replace(".html", '') + "_" +
    now.date + ".json";

  var data = {
    datetime: now.rfc3339ms,
    download: download,
    title: document.querySelector("div.title-text").innerText,
    url: url.origin + url.pathname,
    images: Array.from(images).map(e => e.src),
    shop: shop_elem.querySelector("span").innerText,
    sale: Array.from(sale_elems).map(e => e.innerText),
    pages: -1,
    count: 0,
    comments: [],
  };

  return data;
}

function getPageMax() {
  var num;
  var span = document.querySelector("span.next-pagination-display");

  if (span != null) {
    num = span.innerText.split('/').map(e => Number(e))[1];
  } else {
    num = Array.from(document.querySelectorAll("span.next-btn-helper")).length - 2;
  }

  return num;
}

function download(data) {
  var link = document.createElement("a");
  link.download = data.download;
  delete data.download;
  // data:text/plain;charset=utf8
  link.href = `data:text/json;charset=utf-8,${JSON.stringify(data)}\n`;

  link.click();
  alert(`==> Download ${data.count} items: ${link.download}`);
}

function post(url, data) {
  let req = new XMLHttpRequest();
  // let url = new URL(window.location.href);
  // url = `${url.protocol}//${url.host}`;

  req.onload = (event) => {
    if (req.status != 200) {
       console.log(`!!! status: ${req.status}`);
    }
    return;

    let res = null;
    try {
      res = JSON.parse(req.responseText);
    } catch (e) {
      console.log(`!!! failed to send request:: ${e}`)
      return
    }

    if (res.code > 0) {
      console.log(`!!! response: code=${res.code}, msg=${res.msg}`);
      alert(`code=${res.code}, ${res.msg}`);
      return
    }
  }

  req.open("POST", url); // `${url}/api/post?id=${id}`
  req.setRequestHeader("Content-Type", "application/json");
  req.send(JSON.stringify(data));
  req.send();
}

function autoScrap(pageMax=5, secs=1, archive=download) {    
  function getComments() {
    var evaluates = document.getElementsByClassName("evaluate-item");
    var items = Array.from(evaluates).map(e => parseComment(e));
    console.log(`==> Got comments: ${items.length}`);
    return items;
  }

  var data = pageInfo();
  var btn_next = null;

  var looper = setInterval(function(){
    if (data.pages === -1) {
      let tabs = document.querySelectorAll("div.next-tabs-tab-inner");

      if (tabs && tabs.length >= 2) {
        console.log("==> Click...");
        tabs[tabs.length - 2].click();
        data.pages+=1;
      } else {
        console.log("==> Checking...");
      }

      return;
    }

    data.pages+=1;
    console.log(`==> Page: ${data.pages}`);

    if (data.pages === 1) {
      pageMax = Math.min(pageMax, getPageMax());
      btn_next = document.querySelector("button.next-next");
    }

    getComments().forEach(e => {
      data.comments.push(e);
      data.count = data.comments.length;
    });

    if (data.pages >= pageMax) {
      clearInterval(looper);
      archive(data);
    } else { 
      btn_next.click();
    }
  }, secs*1000);
}

autoScrap(5, 1, download);
// autoScrap(5, 1, (data) => post("http://127.0.0.1:8000", data));
