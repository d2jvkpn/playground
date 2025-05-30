#!/usr/bin/env python3
import os, argparse, signal, sys, threading

from app.create_app import create_app

import yaml
from werkzeug.serving import make_server


class ServerThread(threading.Thread):
    def __init__(self, app, host="0.0.0.0", port=5000):
        threading.Thread.__init__(self)
        self.host, self.port = host, port
        self.server = make_server(host, port, app)
        self.ctx = app.app_context()
        self.ctx.push()

    def run(self):
        print(f"🚀 Starting server: host={self.host}, port={self.port}")
        self.server.serve_forever()

    def shutdown(self):
        print("📴 Shutting down server...")
        # db.close()
        # thread_pool.shutdown()
        # logger.flush()
        self.server.shutdown()


#### 1. config
parser = argparse.ArgumentParser(description="Flask HTTP Server with CORS and YAML config")
parser.add_argument('--config', type=str, default='configs/local.yaml', help='config YAML filepath')
parser.add_argument('--host', type=str, default='127.0.0.1', help='http listening host')
parser.add_argument('--port', type=int, default=5000, help='http listening port')
parser.add_argument('--debug', action='store_true', help='debug mode')
args = parser.parse_args()
# print(f"==> args: {args}")

with open(args.config, 'r') as f:
    config = yaml.safe_load(f)

os.makedirs(config["http"]["upload_folder"], exist_ok=True)

#### 2. load
app = create_app(config["http"])
#app.run(host=args.host, port=args.port, debug=args.debug)

#### 3. setup
shutdown_event = threading.Event()
server = ServerThread(app, host=args.host, port=args.port)

def handle_signal(sig, frame):
    print(f"\n🛑 Caught signal {sig}, initiating shutdown...")
    shutdown_event.set()
    server.shutdown()
    print("✅ Graceful shutdown complete")
    sys.exit(0)

signal.signal(signal.SIGINT, handle_signal)   # Ctrl+C
signal.signal(signal.SIGTERM, handle_signal)  # docker stop / k8s

server.start()
shutdown_event.wait()
