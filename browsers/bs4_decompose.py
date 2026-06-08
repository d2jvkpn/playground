#!/usr/bin/env python3
from bs4 import BeautifulSoup

html = """
<div class="card">
  <h1>标题</h1>
  <svg width="20" height="20"><path d="M0,0 L10,10"/></svg>
  <p>这里是内容</p>
</div>
"""

soup = BeautifulSoup(html, "html.parser")

for svg in soup.find_all("svg"):
    svg.decompose()

clean_html = str(soup)
print(clean_html)
