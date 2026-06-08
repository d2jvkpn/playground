#!/usr/bin/env python3
import os, time, argparse, json
from datetime import datetime
from pathlib import Path

from playwright.sync_api import sync_playwright


user_data_dir = Path("data") / "user_data"
user_data_dir.mkdir(parents=True, exist_ok=True)

downloads_dir = Path("data") / "downloads"
downloads_dir.mkdir(parents=True, exist_ok=True)

screenshots_dir = Path("data") / "screenshots"
screenshots_dir.mkdir(parents=True, exist_ok=True)

def search_content(search, pages=1, open_browser=False, sleep=0):
    with sync_playwright() as p:
        #browser = p.chromium.launch(headless=False, slow_mo=500)
        #browser.new_context() # no cache

        browser = p.chromium.launch_persistent_context(
            #executable_path="/path/to/chromium",
            user_data_dir=user_data_dir,
            downloads_path=downloads_dir,
            headless=not open_browser,
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
        results = []

        #page.fill("input#kw", "Playwright Python")
        #page.click("input#su")
        page.fill("textarea#chat-textarea", search)
        page.click("button#chat-submit-button")
        page.wait_for_selector("#content_left")
        page.wait_for_load_state('networkidle')

        title = page.evaluate("() => document.title")
        print(f"---> page loaded: {title}")
        results.append(page.content())

        for i in range(pages - 1):
            print(f"---> page loaded: {i+2}")
            page_index = page.locator("div#page")
            links = page_index.locator("a")
            links.nth(-1).click()

            page.wait_for_selector("#content_left")
            page.wait_for_load_state('networkidle')
            results.append(page.content())

        #img_path = screenshots_dir /"search_result.png"
        #page.screenshot(path=img_path)
        #print(f"<--- saved screenshot: {img_path}")

        if sleep > 0:
            time.sleep(sleep)

        print(f"<-- close the browser")
        browser.close()
        return results


parser = argparse.ArgumentParser(
    description="search baidu by playwright",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument("--search", required=True, default=None, help="content to search")
parser.add_argument("--pages", required=False, default=1, type=int, help="pages to visit")
parser.add_argument("--output", required=True, default=None, help="save html to file")
parser.add_argument("--open", help="open", action="store_true")

parser.add_argument(
    "--sleep", required=False, default=0, type=int,
    help="sleep seconds before close the browser",
)

args = parser.parse_args(args=None)

#page = document.querySelector("div@page")
#links = page.querySelectorAll("a")
#links[links.length - 1].click()
results = search_content(args.search, args.pages, args.open, args.sleep)

with open(args.output, 'w', encoding='utf-8') as f:
    data = {
        "created_at": datetime.now().astimezone().strftime("%FT%T%:z"),
        "pages": results,
    }

    json.dump(data, f, indent=2, ensure_ascii=False)
