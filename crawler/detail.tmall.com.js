function showComments() {
  var btn_comment = Array.from(document.querySelectorAll("span")).find(e => e.innerText == "宝贝评价");
  btn_comment.parentElement.click();
}

function findWithClassPrefix(elem, tag, prefix) {
  // console.log(`==> findWithClassPrefix: ??, ${tag}, ${prefix}`);
  return Array.from(elem.querySelectorAll(tag)).find(e => e.className.startsWith(prefix));
}

function getComments() {
  var comment = findWithClassPrefix(document, "div", "Comments--comments--");
  if (!comment) {
    return [];
  }

  return Array.from(comment.children).map(e => {
    // var avatar = e.querySelector("img");
    var header = findWithClassPrefix(e, "div", "Comment--header--");
    var user_avatar = header.querySelector("img").src;
    var user_name = header.children[1].children[0].innerText;
    var deal_model = header.children[1].children[1].innerText;

    var comment_content = header.nextElementSibling.innerText;
    var comment_reply = findWithClassPrefix(header.parentElement, "div", "Comment--reply--");
    comment_reply = comment_reply ? comment_reply.innerText : "";

    return { user_avatar, user_name, deal_model, comment_content, comment_reply: comment_reply };
  });
}

function clickNextPage() {
  var foot = findWithClassPrefix(document, "div", "Comments--footer--");
  if (!foot) {
    return false;
  }

  var btn_next = foot.querySelectorAll("button")[1];
  if (!btn_next) {
    return false;
  }

  if (!btn_next.disabled) {
     btn_next.click();
     return true;
  }

  return false;
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
  var header = findWithClassPrefix(document, "div", "ShopHeader--root--");
  var shop = header.children[0].children[0].innerText;
  var shop_avatar = header.querySelector("img").src;

  var shop_evaluation = {}

  Array.from(header.children[0].children[2].children).forEach(e => {
    shop_evaluation[e.children[0].innerText] = e.children[1].innerText;
  });

  var images = Array.from(
      findWithClassPrefix(document, "ul", "PicGallery--thumbnails--").querySelectorAll("img")
    ).map( e => e.src);

  var url = new URL(document.URL);
  var now = datetime();

  var filename = url.host + "-" +
    url.pathname.split('/').slice(-1)[0].replace(".html", '') + "_" +
    url.searchParams.get("id") +
    "_" + now.date + ".json";

  var data = {
    datetime: now.rfc3339ms,
    filename: filename,
    title: findWithClassPrefix(document, "h1", "ItemHeader--mainTitle--").innerText,
    price: findWithClassPrefix(document, "span", "Price--priceText--").innerText,
    url: url.origin + url.pathname + `?id=${url.searchParams.get("id")}`,
    images: images,
    shop: shop,
    pages: -1,
    count: 0,
    comments: [],
  };

  return data;
}

function downloadAnchor(data) {
  var link = document.createElement("a");
  link.download = data.filename;
  delete data.filename;
  // data:text/plain;charset=utf8
  link.href = `data:text/json;charset=utf-8,${JSON.stringify(data)}\n`;

  link.click();
  alert(`==> Download ${data.count} items: ${link.download}`);
}

function postArchive(url, data) {
  url += `?filename=${data.filename}`;
  delete data.filename;

  let req = new XMLHttpRequest();
  // let url = new URL(window.location.href);
  // url = `${url.protocol}//${url.host}`;

  req.onload = (event) => {
    if (req.status != 200) {
      alert(`!!! Response status: ${req.status}`);
    } else {
       alert(`==> Archived data by request`);
    }
  }

  req.open("POST", url); // `${url}/api/post?id=${id}`
  req.setRequestHeader("Content-Type", "application/json");
  req.send(JSON.stringify(data));
  req.send();
}

function autoScrap(pageMax=5, secs=1, archive=download) {
  var data = pageInfo();

  var looper = setInterval(function(){
    if (data.pages === -1) {
      data.pages+=1;
      showComments();
      return;
    }

    data.pages+=1;
    console.log(`==> Page: ${data.pages}`);

    getComments().forEach(e => {
      data.comments.push(e);
      data.count = data.comments.length;
    });

    if (data.pages >= pageMax || !clickNextPage()) {
      clearInterval(looper);
      archive(data);
      return;
    }
  }, secs*1000);
}

// autoScrap(10, 1, downloadAnchor);
// autoScrap(5, 1, (data) => postArchive(`http://127.0.0.1:3000/`, data));
