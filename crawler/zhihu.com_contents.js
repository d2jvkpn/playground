function datetime(at=null) {
  if (!at) { at = new Date(); }

  function padH0 (value, len=2) { return value.toString().padStart(len, '0')}

  function timezoneOffset(offset) {
    if (offset === 0) { return "Z"; }

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
  // ts = new Date(at.rfc3339).getTime()
}

function postArchive(url, data) {
  let filename = newFilename();

  url += `?filename=${filename}`;

  let req = new XMLHttpRequest();
  // let url = new URL(window.location.href);
  // url = `${url.protocol}//${url.host}`;

  req.onload = (event) => {
    if (req.status != 200) {
      alert(`!!! Response status: ${req.status}`);
    } else {
      alert(`==> Http archived`);
    }
  }

  req.open("POST", url); // `${url}/api/post?id=${id}`
  // req.setRequestHeader("Content-Type", "application/json");
  req.send(data);
  req.send();
}

function newFilename() {
  let url = new URL(document.URL);
  let path = url.pathname.slice(1).replace(/\//g, '-');

  let now = datetime();

  let title = document.title.replace(/^\(.*\) /, "").split(" - ")[0].replace(/ +/g, "_");
  if (title.length > 32) { title = title.slice(0, 29) + "..." };

  // ${document.URL.split("//").pop().replace(/\//g, "-")}
  return `zhihu.com__${title}__${now.date}__${path}.md`;
}

function listSearch() {
  // var question = document.querySelector("div.HotLanding-contentItemTitle");
  var items = document.querySelectorAll("div.List-item");

  // let e = items[0];
  Array.from(items).map( e => {
    let q = e.querySelector("div.ContentItem").querySelector("a");
    let a = e.querySelector(".ContentItem-title").getAttribute("name");
    let p = `${q.getAttribute("href")}`;

    if (a) { p = `${q.getAttribute("href")}/answer/${a}`; }
    console.log(`==> ${q.innerText}\n    https://www.zhihu.com${p}`);
  });
}

function archiveArticle() {
  let article = document.querySelector("article.Post-Main, Post-NormalMain");

  if (!article) { alert("No an article!"); return; }

  let filename = newFilename();

  let text = `# ${document.title.split(" - ")[0]}\n\n` +
    `#### Meta\n` +
    "```yaml\n" +
    `link: ${document.URL}\n` +
    `datetime: ${datetime().rfc3339}\n` +
    `filename: ${filename}\n` +
    "```\n\n";

  text += `#### Content\n` + article.innerText + "\n\n";

  let comment = document.querySelector("div.Comments-container");

  text += "\n#### Comments\n"
  if (comment) {
    let items = Array.from(comment.querySelectorAll("div")).filter(e => {
      return e.hasAttribute("data-id") && !e.parentElement.hasAttribute("data-id");
    });

    items.forEach(e => { text += "\n\n##### " + e.innerText; });
  }

  let link = document.createElement("a");

  link.href = `data:text/plain;charset=utf8,` +
    `${text.replace(/\n/g, "%0D%0A").replace(/#/g, "%23")}\n`;

  link.download = filename;
  link.click();

  alert(`==> saved ${link.download}`);
}

// answers
function parseAnsText(target, archive) {
  function getMoreAnswers(ansUrl) {
    let moreAns = document.querySelector(".MoreAnswers");

    if (moreAns) {
      return Array.from(moreAns.querySelectorAll(".AnswerItem"))
        .map(e => ansUrl.replace(/\d+$/, e.getAttribute("name")));
    }

    let taregt = document.querySelector(".AnswersNavWrapper");
    if (!target) { return [] };

    target = taregt.querySelector("div.List-item");
    if (!target) { return [] };

    return Array.from(taregt.querySelectorAll("div.AnswerItem")).slice(1).map(e => {
      return ansUrl.replace(/\d+$/, e.getAttribute("name"));
    });
  }

  let ansUrl = new URL(document.URL).origin + new URL(document.URL).pathname;;
  let filename = newFilename();
  let title = document.title.replace(/^\(.*\) /, "").split(" - ")[0].replace(/ +/g, "_");

  /*
  let data = `# ${document.title.split(" - ")[0]}\n\n` +
    `**link**: *${document.URL}*\n` +
    `**filename**: *${filename}*\n` +
    target.innerText.replace(/\n+/g, "\n");
  */

  let author = target.querySelector(".AuthorInfo-content");
  author = author.innerText.replace(/\n/g, " ") + " " + author.querySelector("a.UserLink-link");

  let text = `# ${title}\n\n` +
    `#### Meta\n` +
    "```yaml\n" +
    `link: ${ansUrl}\n` +
    `datetime: ${datetime().rfc3339}\n` +
    `filename: ${filename}\n` +
    `author: ${author}\n` +
    "```\n\n";

  text += `#### Content\n` +
    target.querySelector(".RichContent-inner").innerText + "\n\n" +
    target.querySelector(".ContentItem-time").innerText + "\n\n" +
    target.querySelector(".ContentItem-actions").children[0].innerText + "\n";

  let comment = document.querySelector(".Comments-container") ||
    document.querySelector(".Modal-content");

  text += "\n#### Comments\n"
  if (comment) {
    let items = Array.from(comment.querySelectorAll("div")).filter(e => e.hasAttribute("data-id"));

    items.forEach(e => { text += "\n\n##### " + e.innerText; });
  }

  let links = getMoreAnswers(ansUrl);
  text += `\n\n#### More Answers:\n- ${links.join("\n- ")}\n`;

  archive(text);
}

function downloadAnchor(data) {
  let link = document.createElement("a");

  link.href = `data:text/plain;charset=utf8,` +
    `${data.replace(/\n/g, "%0D%0A").replace(/#/g, "%23")}\n`;

  link.download = newFilename();
  link.click();

  alert(`==> saved ${link.download}`);
}

//
function getAnswer() {
  let target = document.querySelector(".AnswerCard");

  // target = document.querySelector(".RichContent");
  if (!target) { target = document.querySelector(".AnswersNavWrapper"); }
  if (!target) { target = document.querySelector(".Post-content"); }
  if (!target) { target = document.querySelector(".Post-main"); }

  if (!target) {
    alert("No Target Found!");
  }

  var btn = Array.from(target.querySelectorAll("button")).find(e => e.innerText.includes("条评论"));

  if (btn) {
    btn.click();
    setTimeout(() => parseAnsText(target, downloadAnchor), 1000);
  } else {
    parseAnsText(target, downloadAnchor);
  };
}

// biz
var url = new URL(document.URL);

if (!url.host.includes("zhihu.com")) {
  alert("!!! not zhihu.com");
} else if (url.pathname.startsWith("/search")) {
  listSearch();
} else if (url.pathname.startsWith("/p/")) {
  archiveArticle();
} else if (/\/question\/[0-9]+\/answer\/[0-9]+/.test(url.pathname)) {
  getAnswer();
} else {
  alert(`!!! unknown url path: ${url.pathname}`);
}
