#!/usr/bin/env python3
import os, argparse, asyncio, base64
from pathlib import Path
os.environ['LITELLM_LOCAL_MODEL_COST_MAP'] = "True"
from dotenv import load_dotenv

#####
parser = argparse.ArgumentParser(
    description="Stagehand",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument("--goto", help="goto page", default="login")
parser.add_argument("--options", help="optional args for goto", default="")
parser.add_argument("--env_file", help="env file", default=Path("configs") / "local.env")
parser.add_argument("--headless", help="open browser in headless mode", action="store_true")
parser.add_argument("--debug", help="debug mode", action="store_true")

args = parser.parse_args(args=None)

####
import litellm
if args.debug:
    litellm._turn_on_debug()
    litellm.set_verbose = True

from stagehand import StagehandConfig, Stagehand
from pydantic import BaseModel, Field
from bs4 import BeautifulSoup


# Load environment variables
loaded = load_dotenv(args.env_file)
print(f"~~~ load env file {args.env_file}: {loaded}")

js_get_qrcode = """
async (img) => {
  const response = await fetch(img.src);
  const blob = await response.blob();
  const arrayBuffer = await blob.arrayBuffer();

  let binary = '';
  const bytes = new Uint8Array(arrayBuffer);
  const chunkSize = 0x8000;

  for (let i = 0; i < bytes.length; i += chunkSize) {
    binary += String.fromCharCode.apply(null, bytes.subarray(i, i + chunkSize));
  }

  return btoa(binary);
}
"""

class PageSummary(BaseModel):
    text: str


async def login(stagehand, secs):
    page = stagehand.page

    ####
    p = page.locator("p", has_text="请登录/注册")
    await p.click()

    #await page.wait_for_selector('div.pc-subtitle', state="visible", timeout=5000) # 5s
    locator = page.locator('img.qrcode-img')
    await locator.wait_for(state="visible", timeout=15*1000) # 15s

    # login
    img_data = await locator.evaluate(js_get_qrcode)
    img_path = Path("data") / "dianping.com_qrcode.png"
    with open(img_path, "wb") as f:
        f.write(base64.b64decode(img_data))
        print(f"<--- saved qrcode: {img_path}")

    await asyncio.sleep(secs)

    #summary = await page.extract("Summary this webpage", schema=PageSummary)
    #print(f"==> summary: {summary.text}")


# 30, "衡山路"
async def get_food_shops(stagehand, number_of_pages, search_key):
    #toggle = page.locator("//span[text()='模式']/following-sibling::*[1]")
    #ai_span.locator(".current + div")
    #await p.click()

    search_input = stagehand.page.locator('input.J-search-input').first
    await search_input.fill(search_key)

    context = stagehand.page.context
    async with context.expect_page() as new_page_info:
        search_btn = stagehand.page.locator('a#J-channel-bnt')
        await search_btn.click()

    page = await new_page_info.value
    await page.wait_for_load_state()
    await page.bring_to_front()
    title = await page.title()
    print(f"---> opened shop_list page: {title}")

    shop_list = page.locator('div.shop-all-list').nth(0)

    food_shops_dir = Path("data") / "food_shops_html"
    food_shops_dir.mkdir(parents=True, exist_ok=True)

    #shop_list_html = await shop_list.inner_html()
    shop_list_html = await shop_list.evaluate("el => el.outerHTML")

    html_path = food_shops_dir / f"page-{1:03d}.html"
    with open(html_path, "w") as f:
        f.write(shop_list_html)
        print(f"--> saved html: {html_path}")

    for i in range(number_of_pages-1):
        p_num = i+2
        next_page = page.locator("a.next[title='下一页']")
        if not await next_page.is_visible():
            print("--> no next page")
            break

        await next_page.click()

        shop_list_html = await shop_list.evaluate("el => el.outerHTML")

        html_path = shop_list_dir / f"page-{p_num:03d}.html"
        with open(html_path, "w") as f:
            f.write(shop_list_html)
            print(f"<-- saved html: {html_path}")


async def visit_shop(page, shop_id, html_path): # "https://www.dianping.com/shop/G2LQYgctM49uMwz"
    link = f"https://www.dianping.com/shop/{shop_id}"
    print(f"--> visit shop: {link}")
    await page.goto(link)

    await page.locator("div.component-reviewlist").is_visible()

    shop_info = page.locator("div.pc-shopInfo") # 店铺信息
    if await shop_info.is_visible():
        shop_info_html = await shop_info.inner_html()
    else:
        shop_info_html = ""

    shop_dish = page.locator("div#shop-dish") # 店铺菜单
    if await shop_dish.is_visible():
        shop_dish_html = await shop_dish.inner_html()
    else:
        shop_dish_html = ""

    shop_reviewlist = page.locator("id.center") # 网友评价
    if await shop_reviewlist.is_visible():
        shop_reviewlist_html = await shop_reviewlist.inner_html()
    else:
        shop_reviewlist_html = ""

    if not shop_info_html and not shop_dish_html and not shop_reviewlist_html:
        return False

    with open(html_path, 'w') as f:
        f.write(shop_info_html + "\n\n")
        f.write(shop_dish_html + "\n\n")
        f.write(shop_reviewlist_html + "\n\n")
        print(f"<--- saved html: {html_path}")

    return True


# await visit_all_shops(stagehand, "data/food_shops_html")
async def visit_all_shops(stagehand, html_dir: str):
    html_dir = Path(html_dir)
    shop_htmls = list(html_dir.glob("*.html"))

    for html in shop_htmls:
        save_dir = html_dir / html.name.rsplit(".html")[0]
        save_dir.mkdir(parents=True, exist_ok=True)

        with open(html, "r", encoding="utf-8") as f:
            soup = BeautifulSoup(f.read(), "html.parser")

        shop_ids = set()
        for a in soup.find("div", class_="shop-list").find_all("a"):
            shop_id = a.get("data-shopid")
            if shop_id:
                shop_ids.add(shop_id)

        for shop_id in set(shop_ids):
            html_path = save_dir / f"shop_{shop_id}.html"
            if html_path.exists():
                continue

            await visit_shop(stagehand.page, shop_id, html_path)
            await asyncio.sleep(1)


async def main():
    traces_dir = Path("data") / "stagehand" / "traces"
    user_data_dir = Path("data") / "stagehand" / "user_data"
    downloads_dir = Path("data") / "stagehand" / "downloads"

    traces_dir.mkdir(parents=True, exist_ok=True)
    user_data_dir.mkdir(parents=True, exist_ok=True)
    downloads_dir.mkdir(parents=True, exist_ok=True)

    localBrowserLaunchOptions = {
        "headless": args.headless,
        "traces_dir": traces_dir,  # Directory to store trace files
        "user_data_dir": user_data_dir, # Custom user data directory
        "accept_downloads": True,
        "downloads_path": downloads_dir,
        #"proxy": {
        #    "server": "http://proxy.example.com:8080",
        #    "bypass": "localhost",
        #    "username": "user",
        #    "password": "pass"
        #},
        #"record_video": {...},
        #"record_har": {...},
    }

    llm_api_model = os.environ['LLM_API_MODEL']

    litellm.register_model({
        llm_api_model: {
            "litellm_provider": "hosted_vllm",
            "mode": "chat",
            "max_tokens": 8192,
            "input_cost_per_token": 0.00003,
            "output_cost_per_token": 0.00006,
        },
    })

    #os.environ['OPENAI_API_KEY'] = os.environ['LLM_API_KEY'] # "sk-xxxxxxxx"
    os.environ['OPENAI_BASE_URL'] = os.environ['LLM_API_BASE'] # "http://127.0.0.1:11434/v1"
    #print("~~~ LLM_API_BASE:", os.environ['LLM_API_BASE'])

    # Create configuration
    sconf = StagehandConfig(
        env="LOCAL",
        verbose=1,
        self_heal=True,
        enable_caching=True,
        system_prompt="You are a browser automation assistant that helps users navigate websites effectively.",
        localBrowserLaunchOptions=localBrowserLaunchOptions,
        model_name=os.environ['LLM_API_MODEL'], # "hosted_vllm/qwen-plus", "ollama/qwen3:8b"
        model_api_key=os.environ['LLM_API_KEY'],
    )

    stagehand = Stagehand(sconf) # TODO: stagehand.llm
    print("\n==> Initializing Stagehand...")
    await stagehand.init() # Initialize Stagehand

    if stagehand.env == "BROWSERBASE":
        print(f"--> View your live browser: https://www.browserbase.com/sessions/{stagehand.session_id}")

    await stagehand.page.goto("https://www.dianping.com")

    try:
        if args.goto == "login":
            await login(stagehand, int(args.options))
        elif args.goto == "shop_list":
            target = stagehand.page.locator('p.ellipsis', has_text="美食")
            await target.click()

            number_of_pages, search_key = args.options.split(" ", 1)# 30 衡山路
            number_of_pages, search_key = int(number_of_pages), search_key.strip()
            # await stagehand.page.goto("https://www.dianping.com/shanghai/ch10/d1")
            await get_food_shops(stagehand, number_of_pages, search_key)
        elif args.goto == "visit_shops":
            await visit_all_shops(stagehand, args.options) # "data/food_shops_html"
        else:
            print(f"!!! unknown goto: {args.goto}")
    except Exception as e:
        print(f"Error: {str(e)}")
        raise
    finally:
        # Close the client
        print("\n<== Closing Stagehand...")
        await stagehand.close()


if __name__ == "__main__":
    asyncio.run(main())
