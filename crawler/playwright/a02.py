#!/usr/bin/env python3
import asyncio

from playwright.async_api import async_playwright

async def run():
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=False)
        page = await browser.new_page()

        await page.goto("https://example.com")

        title = await page.title()
        print("页面标题:", title)

        #h1_text = await page.text_content("h1")
        #print("h1 内容:", h1_text)

        body_text = await page.text_content("body")
        print("页面正文:", body_text[:200], "...")  # 截取前200个字符

        await browser.close()

asyncio.run(run())
