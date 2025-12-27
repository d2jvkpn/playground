(() => {
  // 1) 获取页面 HTML（包含 doctype）
  // const html = document.body.outerHTML;
  // const html = "<!doctype html>\n" + document.documentElement.outerHTML;

  const clone = document.documentElement.cloneNode(true);

  ["script", "noscript", "canvas", "object", "embed", "applet"]
    .map(e => clone.querySelectorAll(e).forEach(s => s.remove()));


  clone.querySelectorAll("*").forEach(el => {
    [...el.attributes].forEach(attr => {
      if (attr.name.startsWith("on")) {
        el.removeAttribute(attr.name);
      }
    });
  });

  const html = "<!doctype html>\n" + clone.outerHTML;

  // 2) 用 title 命名并清理非法字符（Windows/macOS 常见限制）
  const safeTitle = (document.title || "page")
    .trim()
    .replace(/[\\/:*?"<>|]/g, "_")
    .replace(/\s+/g, " ");

  const filename = `${safeTitle}.html`;

  // 3) Blob + a 下载
  const blob = new Blob([html], { type: "text/html;charset=utf-8" });
  const url = URL.createObjectURL(blob);

  const a = document.createElement("a");
  a.href = url;
  a.download = filename;

  document.body.appendChild(a);
  a.click();
  a.remove();

  // 4) 释放 URL
  setTimeout(() => URL.revokeObjectURL(url), 1000);
})();
