#!/usr/bin/env python3
import os, argparse, asyncio
from pathlib import Path

from playwright.async_api import async_playwright


async def open_async(stop_event, browser="firefox", url=None, data_dir=None):
    if data_dir is None:
        data_dir = Path("data") / browser

    async with async_playwright() as p:
        if browser == "chromium":
            b = p.chromium
        elif browser == "firefox":
            b = p.firefox
        else:
            raise ValueError(f"Unknown parameter browser: {browser}")

        #browser = await p.chromium.launch(headless=headless)
        browser_ctx = await b.launch_persistent_context(
            headless=False,
            traces_dir=data_dir / "traces",
            user_data_dir=data_dir / "user_data",
            accept_downloads=True,
            downloads_path=data_dir / "downloads",
            args=["--window-size=1280,800"],
            no_viewport=True,
            proxy=None,
        )

        if url:
            if not url.startswith("http"):
                url = f"https://{url}"
            #page = await browser_ctx.new_page() # this will open a new browser window
            page = browser_ctx.pages[0]
            await page.goto(url)

        browser_ctx.on("close", lambda ctx: (
            print(f"The browser was closed: {ctx.browser.browser_type.executable_path}."),
            stop_event.set(),
        ))

        #await browser_ctx.close()
        await stop_event.wait()


parser = argparse.ArgumentParser(
    description="Browser Open",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument(
    "--browser", default="firefox",
    help="browser to use,  e.g. firefox, chromium",
)

parser.add_argument("--url", default=None, help="url to open")

parser.add_argument(
    "--data_dir", default=None,
    help="directory to persist data, default is 'data/{browser}'",
)

args = parser.parse_args(args=None)

#loop = asyncio.get_running_loop(); loop.run_forever(); loop.run_until_complete()
stop_event = asyncio.Event()

try:
    asyncio.run(open_async(stop_event, args.browser, args.url, args.data_dir))
except KeyboardInterrupt:
    print("")
    stop_event.set()
except ValueError as e:
    print(f"{e}")
    os.sys.exit(1)
except Exception as e:
    print(f"Unexpected error occured: {e}")
    os.sys.exit(1)
