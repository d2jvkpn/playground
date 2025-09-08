#!/usr/bin/env python3
import os, time
from datetime import datetime

import PIL.ImageGrab
import pygetwindow as gw


title = os.sys.argv[1]

while True:
    active_window = gw.getActiveWindow()
    window_title = active_window.title
    bbox = (
        active_window.left,
        active_window.top,
        active_window.left + active_window.width,
        active_window.top + active_window.height,
    )

    if title in window_title.lower():
        now = datetime.now()
        os.makedirs(now.strftime("%Y-%m-%d"), 511, exist_ok=True)
        filepath = os.path.join(now.strftime("%Y-%m-%d"), now.strftime("%Y-%m-%dT%H-%M-%s") + '.jpeg')

        img = PIL.ImageGrab.grab(bbox)
        img.save(filepath)

    time.sleep(1)


os.sys.exit(0)

#!/usr/bin/env python3
from bypy import ByPy


bp = ByPy()

bp.upload('temp.jpg', filename)
