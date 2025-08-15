#!/usr/bin/env python3
import time
from pathlib import Path

from playwright.sync_api import sync_playwright


user_data_dir = Path("data") / "user_data"
user_data_dir.mkdir(parents=True, exist_ok=True)

downloads_dir = Path("data") / "downloads"
downloads_dir.mkdir(parents=True, exist_ok=True)

screenshots_dir = Path("data") / "screenshots"
screenshots_dir.mkdir(parents=True, exist_ok=True)


with sync_playwright() as p:
    #browser = p.chromium.launch(headless=False, slow_mo=500)
    #browser.new_context() # no cache

    browser = p.chromium.launch_persistent_context(
        #executable_path="/path/to/chromium",
        user_data_dir=user_data_dir,
        downloads_path=downloads_dir,
        headless=False,
        slow_mo=500,
        #proxy={
        #    "server": "socks5://127.0.0.1:1080",  # http / https / socks5
        #    "username": "user",
        #    "password": "pass"
        #},
    )

    page = browser.new_page()
    #page.set_extra_http_headers({
    #    "Cache-Control": "no-cache, no-store, must-revalidate",
    #    "Pragma": "no-cache",
    #    "Expires": "0"
    #})

    page.goto("https://www.baidu.com")

    #page.fill("input#kw", "Playwright Python")
    #page.click("input#su")

    page.fill("textarea#chat-textarea", "Playwright Python")
    page.click("button#chat-submit-button")

    page.wait_for_selector("#content_left")

    title = page.evaluate("() => document.title")
    print(f"---> page title: {title}")

    img_path = screenshots_dir /"search_result.png"
    page.screenshot(path=img_path)
    print(f"<--- saved screenshot: {img_path}")

    time.sleep(30)

    browser.close()
