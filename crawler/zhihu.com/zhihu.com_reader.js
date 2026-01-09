(() => {
  let title = document.querySelector("h1.QuestionHeader-title").cloneNode(true);
  let article = document.querySelector("div.QuestionAnswer-content").cloneNode(true);

  let source = document.createElement('p');
  source.id = "source";
  source.textContent = `source: ${location.href}`;

  let exportedAt = document.createElement('p');
  exportedAt.id = "exportedAt";
  exportedAt.textContent = `exported_at: ${new Date().toISOString()}`;

  document.body.innerHTML = '';
  document.body.append(title, source, exportedAt, article);
  article.style.width = "100%";

  const css = `
h1 { text-align: center; font-size: 48px};
@media print {
  .print-block { break-inside: avoid; page-break-inside: avoid; }
  img { break-inside: avoid; page-break-inside: avoid; max-width: 100%; max-height: 250mm; display: block; }
};`;
  const style = document.createElement('style');
  style.id = 'print-fix-style';
  style.textContent = css;
  document.head.appendChild(style);

  let t = null;
  t = document.querySelector("div.ContentItem-actions");
  if (t) {
    t.remove();
  }
})();


/*
let t = null;

t = document.querySelector("div.Question-sideColumnAdContainer");
if (t) {
  t.parentElement.remove();
}

t = document.querySelector("header.AppHeader");
if (t) {
  t.remove();
}

t = document.querySelector("div.MoreAnswers");
if (t) {
  t.remove();
}
*/
