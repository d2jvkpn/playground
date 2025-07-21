#!/usr/bin/env python3
import socket

# $ pip install pstuil
import psutil


def get_local_ip():
    try:
        # 连接到一个外部地址（不需要真的连通，只是用于获取绑定的IP）
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))  # Google DNS，任意公网IP即可
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        return "127.0.0.1"  # 回退为本地环回地址

def get_all_ips():
    ips = []
    for iface, addrs in psutil.net_if_addrs().items():
        for addr in addrs:
            if addr.family == socket.AF_INET and not addr.address.startswith("127."):
                ips.append((iface, addr.address))

    return ips


print("local_ip:", get_local_ip())
print("all_ips:", get_local_ip())
