#!/usr/bin/env python3
import threading

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

