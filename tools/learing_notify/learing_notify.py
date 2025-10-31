#!/usr/bin/env python3
import argparse, time, random
from datetime import datetime
from pathlib import Path
#random.seed(42)

import yaml, chime


def now():
    return datetime.now().astimezone().strftime("%FT%T%:z")

def learning(r1_mins, r2_mins, total_mins, break_secs=10):
    step = 0
    t0 = time.time()
    r1_secs = r1_mins * 60
    r2_secs = r2_mins * 60
    total_secs = total_mins * 60

    while True:
        delta = int(time.time() - t0)
        if delta >= total_secs:
            break

        step += 1
        secs = delta if delta > 0 and delta < r1_secs else random.randint(r1_secs, r2_secs)
        print(f"--> {now()} learning: step={step}, seconds={secs}s")
        chime.info()

        time.sleep(secs)
        chime.success()

        print(f"--> {now()} have a break: step={step}, seconds={break_secs}s")
        time.sleep(break_secs)

    chime.success()
    chime.success()
    chime.success()

parser = argparse.ArgumentParser(
    description="",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

#parser.add_argument("--config", help="yaml config filepath", default=Path("configs") / "local.yaml")
parser.add_argument("--r1_mins", help="min minutes", type=int, default=3)
parser.add_argument("--r2_mins", help="max minutes", type=int, default=5)
parser.add_argument("--break_secs", help="break seconds", type=int, default=10)
parser.add_argument("--total_mins", help="total minutes", type=int, default=90)

args = parser.parse_args(args=None) # parser.parse_args(os.argv[1:])
#print(f"==> Args: {args}")

print(f"==> {now()} Starting: you will keep learning in {args.total_mins}m")
learning(args.r1_mins, args.r2_mins, args.total_mins, args.break_secs)
print("<== {now()} Finished: rest for 20 minutes")
