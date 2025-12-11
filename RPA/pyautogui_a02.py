#!/usr/bin/env python3
import os, time

import pyautogui as pg
pg.FAILSAFE = True


desktop = os.path.join(os.environ["USERPROFILE"], "DESKTOP")

shortcut = os.path.join(desktop, "app.lnk") # "Xmind.lnk"
print("click:", shortcut)
# print(os.path.exists(shortcut))

os.startfile(shortcut)
time.sleep(50)
# print(".", end="", flush=True)

pg.moveTo(1010, 580, duration=0.5)  # 登录窗口 - 输入密码
pg.click()
pg.write("", interval=0.1)

#print("Press F5")                  # 登录窗口 - 确认
#pg.press("f5")
pg.moveTo(980, 640, duration=0.5)
pg.click()

print("position:", pg.position())
#pg.moveRe(100, 0, duration=0.5)

time.sleep(1)
pg.moveTo(1120,  610, duration=0.5) # 每日一贴 - 退出
pg.click()

time.sleep(2)
pg.moveTo(1380,  295, duration=0.5) # 今日事件提醒 - 关闭
pg.click()

time.sleep(2)
pg.moveTo(680,  70, duration=0.5)   # 退出系统 - 点击
pg.click()

pg.screenshot("screen.png")         # region=(100, 200, 800, 600)

os.sys.exit(0)
pg.moveTo(900,  600, duration=0.5)  # 退出系统 - 确认
pg.click()
