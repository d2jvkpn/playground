#!/usr/bin/env python3
import os, time, subprocess
from pathlib import Path

import pyperclip
import pyautogui as pg
pg.FAILSAFE = True


print("mouse position:", pg.position())

disk_c = Path("C:")
home_dir = Path(os.environ['USERPROFILE'])

#### 1. get all opened windows
os.sys.exit(0)
titles = pg.getAllTitles()
for i, t in enumerate(titles, 1):
    if t.strip():
        print(f"{i:02d}: {t}")

#### 2.
os.sys.exit(0)
name = "hello.txt"
file = home_dir / "DESKTOP" / name
open(file, 'w').close()
#shortcut = disk_c / "Windows"  / "system32" / "notepad.exe"
#os.startfile(shortcut)
subprocess.Popen(["notepad", file])
time.sleep(1)

wins = pg.getWindowsWithTitle(f"{name} - 记事本")
win = wins[0]

win.activate()
win.minimize()
win.restore()
win.resizeTo(500, 600)
win.moveTo(1000, 100)

win.activate()
#pg.write("Hello from pyautogui on Linux!\n", interval=0.05)
pyperclip.copy("Hello, world!\n")
time.sleep(0.5)
pg.hotkey("ctrl", "v")
pg.hotkey("ctrl", "s")
win.close()
#pg.hotkey("shift", "s")

#### 3. terminal
os.sys.exit(0)
pg.write("ls", interval=0.05)
pg.hotkey("enter")

pg.write("pwd", interval=0.05)
pg.hotkey("enter")
