#!/usr/bin/env python3

import sys, signal

def signal_handler(sig, frame):
    print(f"You pressed Ctrl+C: signal={sig}, frame={frame}")
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

print('Press Ctrl+C')
signal.pause()
