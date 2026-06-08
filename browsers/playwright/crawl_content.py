#!/usr/bin/env python3
import asyncio

import trafilatura, httpx
from selectolax.parser import HTMLParser

async def fetch(url):
    async with httpx.AsyncClient(follow_redirects=True, timeout=20) as c:
        r = await c.get(url, headers={"User-Agent":"Mozilla/5.0"})
        r.raise_for_status()
        html = r.text

    return html

async def extract(url, html):
    meta = trafilatura.metadata.extract_metadata(html, url)

    content = trafilatura.extract(
        html,
        include_images=False,
        include_links=False,
        no_fallback=False,
        url=url,
    )

    return {
        "title": (meta.title if meta else ""),
        "url": url,
        "content": content,
    }

async def crawl(url):
    html = await fetch(url)
    result = await extract(url, html)
    return result

if __name__ == "__main__":
    import os, json

    url = os.sys.argv[1]
    result = asyncio.run(crawl(url))
    print(json.dumps(result, indent=2, ensure_ascii=False))
