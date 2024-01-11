/*
firefox: about:config, devtools.selfxss.count = 100
chromium/chrome: TODO
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

  return at;
  // ts: new Date(at.rfc3339).getTime()
}

function download(comments) {
  var now = datetime();
  var url = new URL(document.URL);

  var shop_elem = document.querySelector("#hd").children[0].children[0].children[0];
  var sale_elems = document.querySelector("div.title-sale-column").children;
  var images = document.querySelectorAll("img.detail-gallery-img");

  var data = {
    datetime: now.rfc3339ms,
    title: document.querySelector("div.title-text").innerText,
    url: url.origin + url.pathname,
    images: Array.from(images).map(e => e.src),
    shop: shop_elem.querySelector("span").innerText,
    sale: Array.from(sale_elems).map(e => e.innerText),
    count: comments.length,
    comments,
  };

  var link = document.createElement("a");
  // data:text/plain;charset=utf8
  link.href = `data:text/json;charset=utf-8,${JSON.stringify(data)}\n`;

  // now.toISOString().replace(/:/g, "-").replace(".", "-")
  link.download = url.host + "-" +
    url.pathname.split('/').slice(-1)[0].replace(".html", '') + "_" +
    now.date +
    ".json";

  link.click();
  alert(`==> Download ${comments.length} items: ${link.download}`);
}

function autoScrap(pageMax=5, secs=2) {    
  function getComments() {
    var evaluates = document.getElementsByClassName("evaluate-item");
    var items = Array.from(evaluates).map(e => parseComment(e));
    console.log(`==> Got comments: ${items.length}`);
    return items;
  }

  var next_btn = document.querySelector("button.next-next");
  // var confirm = document.querySelector("next-btn-helper");
  // next_btn.addEventListener('click', () => getComments().forEach(e => comments.push(e)));
  // next_btn.addEventListener('click', () => download(comments));
  var x;

  var span = document.querySelector("span.next-pagination-display");
  if (span != null) {
    x = span.innerText.split('/').map(e => Number(e))[1];
  } else {
    x = Array.from(document.querySelectorAll("span.next-btn-helper")).length - 2;
  }
  pageMax = Math.min(pageMax, x);

  var comments = [];
  var counter = 0;

  var looper = setInterval(function(){
    counter+=1;
    console.log(`==> Page: ${counter}`);

    getComments().forEach(e => comments.push(e));

    if (counter >= pageMax) {
      clearInterval(looper);
      download(comments);
    } else { 
      next_btn.click();
    }

  }, secs*1000);
}

var checker = setInterval(function(){
  let tabs = document.querySelectorAll("div.next-tabs-tab-inner");

  if (tabs && tabs.length >= 2) {
    console.log("==> Go...");
    clearInterval(checker);
    tabs[tabs.length - 2].click();
    autoScrap(5, 2);
    // window.close();
    return;
  }

  console.log("==> Checking...");
}, 200); // check every 200ms
