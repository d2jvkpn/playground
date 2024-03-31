// var question = document.querySelector("div.HotLanding-contentItemTitle");
var items = document.querySelectorAll("div.List-item");

// let e = items[0];
Array.from(items).map( e => {
  let q = e.querySelector("div.ContentItem").querySelector("a");
  let a = e.querySelector("div.AnswerItem").getAttribute("name");

  console.log(`==> ${q.innerText}\n    https://www.zhihu.com${q.getAttribute("href")}/answer/${a}`);  
});

