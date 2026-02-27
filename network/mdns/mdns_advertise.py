#!/usr/bin/env python3
import socket
import time
from zeroconf import IPVersion, ServiceInfo, Zeroconf


def get_local_ip() -> str:
    """
    取一个最常用的本机局域网 IP（避免拿到 127.0.0.1）。
    """
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # 不会真的连出去，但能让系统选一个合适的出接口地址
        s.connect(("8.8.8.8", 80))
        return s.getsockname()[0]
    finally:
        s.close()

def main():
    ip = get_local_ip()
    port = 4096

    # 服务类型固定以 _xxx._tcp.local. 这种形式
    service_type = "_demo._tcp.local."
    # 服务实例名（可以随便取，但建议包含设备名/应用名）
    name = "MyDemoService._demo._tcp.local."

    # 可选的 TXT 记录（发现时能读到）
    props = {
        "path": "/",
        "version": "1",
        "note": "hello-mdns",
    }

    info = ServiceInfo(
        type_=service_type,
        name=name,
        addresses=[socket.inet_aton(ip)],  # IPv4
        port=port,
        properties={k: v.encode("utf-8") for k, v in props.items()},
        server="my-demo-host.local.",      # mDNS 主机名（可选）
    )

    zc = Zeroconf(ip_version=IPVersion.V4Only)

    print(f"[+] Registering: {name} -> {ip}:{port}")
    zc.register_service(info)

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n[!] Unregistering...")
    finally:
        zc.unregister_service(info)
        zc.close()

if __name__ == "__main__":
    main()
