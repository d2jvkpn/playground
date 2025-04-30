#!/usr/bin/env python3
import argparse, socket

parser = argparse.ArgumentParser(
  description="parse commandline arguments",
  formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument("command", help="command name", choices=["client", "server"])

parser.add_argument("--host", help="host", default="127.0.0.1")
parser.add_argument("--port", help="port",  type=int, default=12345)

args = parser.parse_args()

if args.command == "client":
    print(f"==> Connecting to server: {args.host}:{args.port}")
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.sendto(b"Hello", (args.host, args.port))
    response = sock.recvfrom(1024)

    print("<-- received:", response[0].decode())
    sock.close()
else:
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((args.host, args.port))

    print(f"==> UDP server started on: {args.host}:{args.port}")

    while True:
        data, addr = sock.recvfrom(1024)
        msg = data.decode()
        print(f"<-- received from {addr}: {msg}")
        sock.sendto(b"OK", addr)
