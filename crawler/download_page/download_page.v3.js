(() => {
  const clone = document.documentElement.cloneNode(true);

  // 1) 移除不需要的标签（含 style）
  ["script", "noscript", "canvas", "object", "embed", "applet", "style", "iframe"]
    .forEach(tag => clone.querySelectorAll(tag).forEach(n => n.remove()));

  // 2) 移除 on* 事件属性（可选：也移除内联 style）
  clone.querySelectorAll("*").forEach(el => {
    [...el.attributes].forEach(attr => {
      if (attr.name.startsWith("on")) el.removeAttribute(attr.name);
      // 如果你也想移除内联样式，取消下一行注释
      // if (attr.name === "style") el.removeAttribute("style");
    });
  });

  // 3) 删除 head 中的 link
  const head = clone.querySelector("head") || (() => {
    const h = clone.ownerDocument.createElement("head");
    clone.insertBefore(h, clone.firstChild);
    return h;
  })();

  if (head) {
    head.querySelectorAll("link").forEach(n => n.remove());
  }

  // 4) 删除 meta[http-equiv]（通常在 head）
  // clone.querySelectorAll('meta[http-equiv]').forEach(n => n.remove());
  clone.querySelectorAll('meta').forEach(n => n.remove());

  // 5) 把网址写入 <head>（推荐）
  const pageUrl = location.href;
  const exportedAt = new Date().toISOString();

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
  //const comment = clone.ownerDocument.createComment(
  //  ` saved from ${pageUrl} at ${exportedAt} `
  //);

  // head.insertBefore(comment, head.firstChild);
  head.insertBefore(metaTime, head.firstChild);
  head.insertBefore(metaUrl, head.firstChild);
  head.insertBefore(base, head.firstChild);

  // 6) HTML 格式化（pretty print）
  const formatHtml = (input) => {
    let html = input.replace(/>\s+</g, "><").trim();

    const voidTags = new Set([
      "area","base","br","col","embed","hr","img","input",
      "link","meta","param","source","track","wbr"
    ]);

    let out = "";
    let indent = 0;

    const re = /<!--[\s\S]*?-->|<!doctype[\s\S]*?>|<\/?[^>]+>/gi;
    let lastIndex = 0;

    const pushLine = (s) => {
      if (!s) return;
      out += "  ".repeat(indent) + s + "\n";
    };

    let m;
    while ((m = re.exec(html)) !== null) {
      const tag = m[0];
      const text = html.slice(lastIndex, m.index);
      lastIndex = re.lastIndex;

      const textTrim = text.replace(/\s+/g, " ").trim();
      if (textTrim) pushLine(textTrim);

      const isComment = tag.startsWith("<!--");
      const isDoctype = /^<!doctype/i.test(tag);
      const isClosing = /^<\//.test(tag);
      const isSelfClosing = /\/>$/.test(tag);

      const tagNameMatch = tag.match(/^<\/?\s*([a-z0-9:-]+)/i);
      const tagName = tagNameMatch ? tagNameMatch[1].toLowerCase() : "";
      const isVoid = voidTags.has(tagName);

      if (isClosing) {
        indent = Math.max(0, indent - 1);
        pushLine(tag);
      } else if (isComment || isDoctype) {
        pushLine(tag);
      } else if (isSelfClosing || isVoid) {
        pushLine(tag);
      } else {
        pushLine(tag);
        indent += 1;
      }
    }

    const tail = html.slice(lastIndex).replace(/\s+/g, " ").trim();
    if (tail) pushLine(tail);

    return out.trim() + "\n";
  };

  const rawHtml = "<!doctype html>\n" + clone.outerHTML;
  const html = formatHtml(rawHtml);

  // 7) 文件名
  const safeTitle = (document.title || "page")
    .trim()
    .replace(/[\\/:*?"<>|]/g, "_")
    .replace(/\s+/g, " ");

  const filename = `${safeTitle}.html`;

  // 8) 下载
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

