#!/usr/bin/env python3
import os, time

import pyautogui as pg
pg.FAILSAFE = True

pg.write("ls", interval=0.05)
pg.hotkey("enter")

pg.write("pwd", interval=0.05)
pg.hotkey("enter")


chrome = None
for w in pg.getAllWindows():
    if " - Google Chrome" in w.title:
        chrome = w
        break

if chrome is None:
    print("Chrome window not found!")
    os.sys.exit()

chrome.activate()
time.sleep(0.5)
x = chrome.left + 100
y = chrome.top + 100
pg.moveTo(x, y, duration=0.2)

pg.click()
pg.scroll(-200)
time.sleep(2)
pg.scroll(200)
time.sleep(2)
pg.press('pagedown')
