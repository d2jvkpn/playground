#!/usr/bin/env python3
import os, argparse, asyncio
from pathlib import Path

import yaml
from playwright.async_api import async_playwright

#### 1.
async def playbook_run(page, run):
    await page.goto(run['site'])

    result = None
    for step in run['steps']:
        action, target = step['action'], step['target']
        inputs = step.get("inputs", {})

        if action == "load":
            await page.wait_for_selector(target)
        elif action == "wait":
            await asyncio.sleep(int(target))
        elif action == "click":
            elem = stagehand.page.locator(target, **inputs)
            await elem.click()

        elif action == "exec":
            js = Path(target).read_text()
            result = await page.evaluate(js)

        elif action == "extract_text":
            await page.wait_for_selector(target)
            result = await page.text_content(target)
        elif action == "extract_html":
            await page.wait_for_selector(target)
            elem = page.locator(target)
            #result = await elem.inner_html()
            result = await elem.evaluate("el => el.outerHTML")

        else:
            raise(ValueError(f"Unknown action in steps: {action}"))

    if result is None:
        #result = await page.inner_html("html")
        elem = page.locator("html")
        result = await elem.evaluate("el => el.outerHTML")

    output_file = run.get("output_file")
    if output_file is None:
        print(f"{result}")
    else:
        print(f"==> Saved to {output_file}", file=os.sys.stderr)
        with open(output_file, "w") as f:
            f.write(result)

async def open_async(stop_event, browser, headless, data_dir, playbook):
    async with async_playwright() as p:
        if browser == "chromium":
            b = p.chromium
        elif browser == "firefox":
            b = p.firefox
        else:
            raise ValueError(f"Unknown parameter browser: {browser}")

        #browser = await p.chromium.launch(headless=headless)
        ctx = await b.launch_persistent_context(
            headless=headless,
            args=["--window-size=1280,800"],
            no_viewport=True,
            traces_dir=data_dir / "traces",
            user_data_dir=data_dir / "user_data",
            accept_downloads=True,
            downloads_path=data_dir / "downloads",
            proxy=playbook.get("proxy"),
        )

        #page = await ctx.new_page() # this will open a new browser window
        page = ctx.pages[0]
        if "run" in playbook:
            await playbook_run(page, playbook['run'])
        # TODO

        if headless:
            return

        msg = f"The browser was closed: {ctx.browser.browser_type.executable_path}."
        ctx.on("close", lambda ctx: (
            print(msg, file=os.sys.stderr),
            stop_event.set(),
        ))

        #await ctx.close()
        await stop_event.wait()
        return result

#### 2.
parser = argparse.ArgumentParser(
    description="Browser Open",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument("--browser", default="chromium", help="browser to use,  e.g. firefox, chromium")

parser.add_argument("--open", help="open", action="store_true")

parser.add_argument(
    "--data_dir", default=None,
    help="directory to persist data, default is 'data/{browser}'",
)

parser.add_argument(
    "--playbook",
    default=Path("configs") / "playbook.yaml",
    help="open a playbook file(yaml)",
)
args = parser.parse_args(args=None)

#### 3.
if args.data_dir is None:
    args.data_dir = Path("data") / args.browser
else:
    args.data_dir = Path(args.data_dir)

args.data_dir.mkdir(mode=511, parents=True, exist_ok=True)

playbook = {}
if args.playbook not in ["", "None", "none"]: # args.playbook is not None
    with open(args.playbook, 'r') as f:
        playbook = yaml.safe_load(f)

#### 4.
#loop = asyncio.get_running_loop(); loop.run_forever(); loop.run_until_complete()
stop_event = asyncio.Event()

try:
    asyncio.run(open_async(
        stop_event,
        args.browser,
        not args.open,
        args.data_dir,
        playbook,
    ))
except KeyboardInterrupt:
    print("", file=os.sys.stderr)
    stop_event.set()
except ValueError as e:
    print(f"{e}", file=os.sys.stderr)
    os.sys.exit(1)
except Exception as e:
    print(f"Unexpected error occured: {e}", file=os.sys.stderr)
    os.sys.exit(1)
