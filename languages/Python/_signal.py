#!/usr/bin/env python3
import sys, signal

def handler(sig, frame):
    print(f"\n!!! Catched signal: signal={sig}, frame={frame}")
    sys.exit(0)

signal.signal(signal.SIGINT, handler)

print("Press Ctrl+C")
signal.pause()
