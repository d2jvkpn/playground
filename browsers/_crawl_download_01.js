function downloadFile(link, target) {
  function blobToDataUrl(blob) {
    return new Promise(r => {
      let reader = new FileReader();
      reader.onload = r;
      reader.readAsDataURL(blob);
    }).then(e => e.target.result);
  }

  if (!target) {
    target = link.replace(/\/+$/, "").split("/").pop();
    target = target ? target : "unknown.data";
  }

  fetch(link, {
    "headers": {},
    "referrer": document.URL,
    "method": "GET",
    "body": null,
  })
  .then(e => e.blob())
  .then(async (blob)=> {
    let dataUrl = await blobToDataUrl(blob);
    let elem = document.body.appendChild(document.createElement("a"));

    elem.download = target;
    // a.href = "data:text/plain;base64," + L_EncodedData;
    elem.href = dataUrl;
    elem.innerHTML = "Download";

    elem.click();
  })
}

function downloadFiles(tag, prefix) {
  let elems = document.querySelectorAll(tag);
  let links = Array.prototype.map.call(elems, e => e.getAttribute("src"));
  let n = 0;

  links.forEach(link => {
    if (!link) { return; }

    n += 1;
    let target = link.replace(/\/+$/, "").split("/").pop().split("?")[0];
    target = target ? target : "unknown.data";
    target = prefix + n.toString().padStart(2, "0") + "_" + target;

    console.log(`==> download ${target}, ${link}`);
    downloadFile(link, target)
  });
}

function downloalLinks(selector, prefix) {
  // var elems = document.getElementsByClassName("div-with-img");

  // var data = Array.prototype.map.call(elems, e => {
  //    return e.firstChild.getAttribute("src");
  // });

  // element_type="img.class_name=target, ..."

  var elems = document.querySelectorAll(selector);
  var links = Array.prototype.map.call(elems, e => e.getAttribute("src")).filter(e => e);

  var data = {
    url: document.URL,
    title: document.title,
    time: at.toISOString(),
    links: links,
  }

  var link = document.createElement("a");
  link.href = `data:text/json,${encodeURIComponent(JSON.stringify(data))}`;
  link.download = `${prefix}.json`;
  link.click();
}

////
var url = new URL(document.URL);
var at = new Date(); // .getTime()
var day = `${at.getFullYear()}-${at.getMonth()+1}-${at.getDate()}`;
var clock = `${at.getHours()}-${at.getMinutes()}-${at.getMinutes()}`;
var prefix = `${url.hostname}_${document.title}_${day}T${clock}`;

////
var selector = "img.Avatar";

downloalLinks(selector, prefix);

// https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelector
// downloadAll("elem.class[target]");
downloadFiles(selector, "");
