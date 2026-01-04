(() => {
  const clone = document.documentElement.cloneNode(true);

  ["script", "noscript", "canvas", "object", "embed", "applet"].forEach(tag =>
    clone.querySelectorAll(tag).forEach(n => n.remove())
  );

  clone.querySelectorAll("*").forEach(el => {
    [...el.attributes].forEach(attr => {
      if (attr.name.startsWith("on")) el.removeAttribute(attr.name);
    });
  });

  // ==== ① 把网址写入 <head>（推荐） ====
  const pageUrl = location.href;
  const exportedAt = new Date().toISOString();

  const head = clone.querySelector("head") || (() => {
    const h = clone.ownerDocument.createElement("head");
    clone.insertBefore(h, clone.firstChild);
    return h;
  })();

  // <base> 让相对链接在本地打开时仍然指向原网站（可选但很有用）
  const base = clone.ownerDocument.createElement("base");
  base.href = pageUrl;

  const metaUrl = clone.ownerDocument.createElement("meta");
  metaUrl.name = "source-url";
  metaUrl.content = pageUrl;

  const metaTime = clone.ownerDocument.createElement("meta");
  metaTime.name = "exported-at";
  metaTime.content = exportedAt;

  // 你也可以加一个注释，方便用文本搜索找到
  const comment = clone.ownerDocument.createComment(
    ` saved from ${pageUrl} at ${exportedAt} `
  );

  head.insertBefore(comment, head.firstChild);
  head.insertBefore(metaTime, head.firstChild);
  head.insertBefore(metaUrl, head.firstChild);
  head.insertBefore(base, head.firstChild);

  // ==== ② 在 <body> 顶部加可见来源栏（可选） ====
  const body = clone.querySelector("body");
  if (body) {
    const bar = clone.ownerDocument.createElement("div");
    bar.setAttribute(
      "style",
      "padding:8px 12px;border-bottom:1px solid #ccc;font:12px/1.4 -apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica,Arial;word-break:break-all;background:#fff;color:#111;"
    );
    bar.innerHTML = `Saved from: <a href="${pageUrl}" target="_blank" rel="noopener noreferrer">${pageUrl}</a><br/>Exported at: ${exportedAt}`;
    body.insertBefore(bar, body.firstChild);
  }

  const html = "<!doctype html>\n" + clone.outerHTML;

  const safeTitle = (document.title || "page")
    .trim()
    .replace(/[\\/:*?"<>|]/g, "_")
    .replace(/\s+/g, " ");

  const filename = `${safeTitle}.html`;

  const blob = new Blob([html], { type: "text/html;charset=utf-8" });
  const url = URL.createObjectURL(blob);

  const a = document.createElement("a");
  a.href = url;
  a.download = filename;

  document.body.appendChild(a);
  a.click();
  a.remove();

  setTimeout(() => URL.revokeObjectURL(url), 1000);
})();
