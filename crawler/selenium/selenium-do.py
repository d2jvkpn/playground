#!/usr/bin/env python3
import time, math, os, json
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

    username = loading(driver, '//input[@id="username"]')
    # username = driver.find_element(By.ID, 'username')
    username.send_keys(config["username"])

    password = driver.find_element(By.NAME, 'password')
    password.send_keys(config["password"])

    login_button = loading(driver, '//button[@type="submit"]')
    # login_button = driver.find_element(By.XPATH, '//button[@type="submit"]')
    login_button.click()

    #accept = driver.find_element(By.ID, 'btnAccept')
    while True:
        try:
            accept = driver.find_element(By.ID, "btnAccept")
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
    args = {}

    with open(args.config, 'r') as f:
        config = yaml.safe_load(f)

    # https://github.com/mozilla/geckodriver/releases
    service = Service('./data/geckodriver')
    options = webdriver.FirefoxOptions()

    # os.environ.get("headless")
    if args.headless:
         options.add_argument('--headless')

    driver = webdriver.Firefox(service=service, options=options)
    driver.set_page_load_timeout(10)

    try:
        main(driver, config)
    except Exception as e:
        print(f"!!! {now()} unexpected error: {e}")
    finally:
        driver.quit()
