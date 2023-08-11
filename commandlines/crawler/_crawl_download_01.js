function download(link, target) {
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

  fetch(link)
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

function downloadAll(tag, prefix) {
  let elems = document.querySelectorAll(tag);
  let links = Array.prototype.map.call(elems, e => e.getAttribute("src"));
  let n = 0;

  links.forEach(link => {
    if (!link) {
      return
    }
    n += 1;
    let target = link.replace(/\/+$/, "").split("/").pop().split("?")[0];
    target = target ? target : "unknown.data";
    target = prefix + n.toString().padStart(2, "0") + "_" + target;

    console.log(`==> download ${target}, ${link}`);
    download(link, target)
  });
}

// https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelector
// downloadAll("elem.class[target]");
var selector = "img.Avatar";
var prefix = "";

downloadAll(selector, prefix);
