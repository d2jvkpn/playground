#!/usr/bin/env python3
import time, math, os, json, argparse
from datetime import datetime
from urllib.parse import urlparse, parse_qs

import yaml
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
from selenium.webdriver.firefox.service import Service


def now():
    return datetime.now().astimezone()

def open_url(driver, url):
    try:
        driver.get(url)
    except Exception as e:
        pass

def loading(driver, xpath, delay=0.5, max_retry=30):
    n = 0
    while True:
        n += 1
        try:
            target = driver.find_element(By.XPATH, xpath)
            if target:
                return target
        except Exception as e:
            #print(f"!!! an error ocurred while loading: {e}")
            pass

        if n >= max_retry:
            return None

        time.sleep(delay)


def main(dirver, config):
    open_url(driver, config["login"])

    #username = loading(driver, '//input[@id="username"]')
    # username = driver.find_element(By.ID, 'username')
    username = loading(driver, config["username"]["key"])
    username.send_keys(config["username"]["value"])

    # password = driver.find_element(By.NAME, 'password')
    password = loading(driver, config["password"]["key"])
    password.send_keys(onfig["password"]["value"])

    login_button = loading(driver, config["action"])
    # login_button = driver.find_element(By.XPATH, '//button[@type="submit"]')
    login_button.click()

    #accept = driver.find_element(By.ID, 'btnAccept')
    while True:
        try:
            accept = driver.find_element(By.XPATH, config["post"])
            if accept:
                accept.click()
                break
        except Exception as e:
            pass

        time.sleep(1)

    driver.set_page_load_timeout(2)
    os.makedirs(f"data/pages", exist_ok=True)

    for item in config["targets"]: # id, url, loaded, target
        html_path = f"data/pages/{item['id']}.html"
        if os.path.exists(html_path): continue

        open_url(dirver, item["url"])

        if item.get("loaded"):
            loaded = loading(driver, item["loaded"])
            if loaded is None:
                print(f"!!! {now()} can't get loaded from page: id={item['id']}")
                continue

        #target = driver.find_element(By.ID, item["id"])
        target = driver.find_element(By.XPATH, item["target"])
        html = target.get_attribute("outerHTML")
        if html is None: continue

        with open(html_path, 'w') as f:
            print(f"--> {now()} saved: {html_path}")
            f.write(html)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="parse commandline arguments",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )

    parser.add_argument("-c", "--config", help="config path", default="./configs/local.yaml")
    parser.add_argument("--headless", help="headless mode", action="store_true")

    parser.add_argument("msg", help="message", nargs="*")

    args = parser.parse_args()

    with open(args.config, 'r') as f:
        config = yaml.safe_load(f)

    service = Service(config["geckodriver"])
    options = webdriver.FirefoxOptions()

    if args.headless: # os.environ.get("headless")
         options.add_argument('--headless')

    driver = webdriver.Firefox(service=service, options=options)
    driver.set_page_load_timeout(10)

    try:
        main(driver, config)
    except Exception as e:
        print(f"!!! {now()} unexpected error: {e}")
    finally:
        driver.quit()
