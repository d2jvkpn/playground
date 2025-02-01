import argparse
from http.server import HTTPServer, SimpleHTTPRequestHandler


class NoListingHTTPRequestHandler(SimpleHTTPRequestHandler):
    def list_directory(self, path):
        self.send_error(403, "Directory listing is not allowed")
        return None

def main():
    parser = argparse.ArgumentParser(description="http server parameters")

    # nargs='+', default=[1, 2, 3]
    parser.add_argument("--bind", type=str, required=False, default="127.0.0.1", help="bind ip")
    parser.add_argument("--port", type=int, required=False, default=8000, help='server port')
    parser.add_argument(
      "--list_dir", type=bool, required=False, default=False, help='list directory',
    )
    args = parser.parse_args()

    if args.list_dir:
       httpd = HTTPServer((args.bind, args.port), SimpleHTTPRequestHandler)
    else:
       httpd = HTTPServer((args.bind, args.port), NoListingHTTPRequestHandler)

    print(f"==> Serving on {args.ip}:{args.port}: list_dir={args.list_dir}")
    httpd.serve_forever()

if __name__ == "__main__":
    main()
