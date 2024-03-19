function getTarget() {
  let target = document.querySelector(".AnswerCard");

  if (!target) {
    target = document.querySelector(".RichContent");
  }

  return target;
}

function getText(target, archive) {
  let filename = `${document.title.split(" - ")[0]}` + 
    `__${document.URL.split("//").pop().replace(/\//g, "-")}.md`;

  /*
  let data = `# ${document.title.split(" - ")[0]}\n\n` +
    `**link**: *${document.URL}*\n` +
    `**filename**: *${filename}*\n` +
    target.innerText.replace(/\n+/g, "\n");
  */

  let text = `# ${document.title.split(" - ")[0]}\n\n` +
    `**link**: *${document.URL}*\n` +
    `**filename**: *${filename}*\n` +
    target.querySelector(".RichContent-inner").innerText + "\n\n" +
    target.querySelector(".ContentItem-time").innerText + "\n\n" +
    target.querySelector(".ContentItem-actions").children[0].innerText + "\n";

  let comments = document.querySelector(".Comments-container") ||
    document.querySelector(".Modal-content");

  if (comments) {
    let items = Array.from(comments.querySelectorAll("div")).filter(e => e.hasAttribute("data-id"));
    items.forEach(e => {
      text += "\n\n#### " + e.innerText;
    });
  }

  let moreAns = document.querySelector(".MoreAnswers");
  if (moreAns) {
    let links = Array.from(moreAns.querySelectorAll(".AnswerItem"))
      .map(e => document.URL.replace(/\d+$/, e.getAttribute("name")));

    text += `\n\n#### More Answers:\n- ${links.join("\n- ")}\n`;
  }

  archive(text);
}

function printData(data) {
  console.log(data);
}

function downloadAnchor(data) {
  let link = document.createElement("a");
  link.href = `data:text/plain;charset=utf8,${data.replace(/\n/g, "%0D%0A").replace(/#/g, "%23")}\n`;

  link.download = `${document.title.split(" - ")[0]}` +
    `__${document.URL.split("//").pop().replace(/\//g, "-")}.md`;

  link.click();

  alert(`==> saved ${link.download}`);
}

function postArchive(url, data) {
  let filename = `${document.title.split(" - ")[0]}` +
    `__${document.URL.split("//").pop().replace(/\//g, "-")}.md`;

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

//
var target = getTarget();
var btn = Array.from(target.querySelectorAll("button")).find(e => e.innerText.includes("条评论"));

if (btn) {
  btn.click();
  setTimeout(() => getText(target, downloadAnchor), 1000);
  // setTimeout(() => getText(target, printData), 1000);
  // setTimeout(() => getText(target, data => postArchive(`http://127.0.0.1:3000/`, data)), 1000);
} else {
  getText(target, downloadAnchor);
  // getText(target, printData);
  // getText(target, getText(target, data => postArchive(`http://127.0.0.1:3000/`, data)));
};
