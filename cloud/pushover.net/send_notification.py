#!/usr/bin/env python3
import os, shlex, subprocess


def send_notification(title, message):
    cmd = os.getenv("send_notification") # 'bash pushover.sh device'
    if cmd is None:
        return

    command = shlex.split(cmd)
    command.append(title)
    command.append(message)

    _ = subprocess.Popen(command)
