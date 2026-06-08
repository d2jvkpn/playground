#!/usr/bin/env python3
import os
from pathlib import Path

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
from selenium.webdriver.firefox.service import Service


parser = argparse.ArgumentParser(
    description="parse commandline arguments",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument("-c", "--config", help="config path", default="./configs/local.yaml")

# source: https://github.com/mozilla/geckodriver/releases
parser.add_argument("--geckodriver", help="geckodriver filepath", default="./configs/geckodriver")
parser.add_argument("--headless", help="headless mode", action="store_true")

parser.add_argument(
    "--profile", default="geckodriver",
    help="firefox profile name or path, default: ~/.mozilla/firefox/geckodriver",
)

args = parser.parse_args()

home_dir = str(Path.home()) # os.path.expanduser("~")

options = webdriver.FirefoxOptions()
# options.set_preference("dom.webdriver.enabled", False)
# options.set_preference("useAutomationExtension", False)
if args.headless:
    options.add_argument('--headless')

# $ firefox --profilemanager
options.add_argument("-profile")
if args.profile.startswith("/"):
    options.add_argument(args.profile)
else
    options.add_argument(os.path.join(home_dir, ".mozilla", "firefox", args.profile))

service = Service(executable_path=args.geckodriver)
driver = webdriver.Firefox(service=service, options=options)

driver.get("https://www.mozilla.org")
print(driver.title)

driver.quit()
