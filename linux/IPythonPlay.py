#! python3

import os
from glob import glob
from IPython.display import Video

basename = os.path.basename

def printList(arr):
    for i in range(len(arr)):
        print("[{:02d}] {}".format(i, arr[i]))

dirs = sorted(glob("*/"), key=lambda x: x.split(".")[0].zfill(3))
printList(dirs)

def strNumIndex(str, n=2):
    if "." in str: return str.split(".")[0].zfill(n)
    if " " in str: return str.split()[0].zfill(n)
    return str.zfill(n)

videos = sorted(glob(dirs[0] + "*.mp4"), key = lambda x: strNumIndex(basename(x)))
printList(videos)
