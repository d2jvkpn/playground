#!/usr/bin/env python3
import os, argparse, uuid

import yaml, magic
from werkzeug.utils import secure_filename
from flask import Flask, request, jsonify
from flask_cors import CORS

def create_app(config):
    app = Flask(__name__)
    cors_origins = config.get("http", {}).get("cors_origins", "*")
    CORS(app, resources={r"/*": {"origins": cors_origins}})

    upload_folder = config.get("http.uploads", os.path.join("data", "uploads"))
    os.makedirs(upload_folder, exist_ok=True)

    allowed_extensions = config.get("http.allowed_extensions", ['pdf', 'txt', 'docx', 'doc', 'ppt', 'pptx'])
    allowed_extensions = set(allowed_extensions)

    allowed_mime_types = config.get("http.allowed_extensions", [
      'application/pdf',
      'application/msword',
      'text/plain',
      'application/vnd.ms-powerpoint',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    ])
    allowed_mime_types = set(allowed_mime_types)

    def allowed_file(file):
        if not '.' in file.filename and file.filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS:
            return False

        buffer = file.read(2048)
        file.seek(0)
        mime = magic.from_buffer(buffer, mime=True)
        return mime in allowed_mime_types


    @app.errorhandler(404)
    def not_found(error):
        return jsonify({
          "code": "route_not_found",
          "msg": "The requested URL OR Method was not found on the server."
        }), 404

    @app.errorhandler(405)
    def method_not_allowed(e):
        return jsonify({
          "code": "route_not_found",
          "msg": "The requested URL OR Method was not found on the server."
        }), 404

    @app.route("/", methods=["GET"])
    def home():
        #return "<h2>✅ Flask HTTP Server is running with CORS!</h2>"#
        return "Flask HTTP Server is running with CORS!\n"

    @app.route("/echo", methods=["POST"])
    def echo():
        name = request.args.get('name', "")
        if not request.is_json:
            return jsonify({"code": "not_json", "msg": "Request must be JSON"}), 400

        data = request.get_json()
        return jsonify({"code": "ok", "data": {"name": name, "data": data }})

    @app.route("/upload", methods=["POST"])
    def upload_file():
        if 'file' not in request.files:
            return jsonify({"code": "params_required", "msg": "No file part"}), 400

        file = request.files['file']
        if file.filename == '':
            return jsonify({"code": "invalid_params", "msg": "No selected file"}), 400

        if not allowed_file(file):
            return jsonify({"code": "invalid_file_type", "msg": "File type not allowed"}), 400

        file_id = str(uuid.uuid4()) # uuid.uuid4().hex
        save_path = os.path.join(upload_folder, f"{file_id}_{secure_filename(file.filename)}")
        file.save(save_path)
        size_bytes = os.path.getsize(save_path)

        return jsonify({
          "code": "ok",
          "data": {
            "filename": file.filename,
            "save_path": save_path,
            "id": file_id,
            "size_bytes": size_bytes,
          }
        })

    return app


# config
# http:
#   cors_origins:
#   - "https://example.com"
#   - "http://localhost:3000"
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Flask HTTP Server with CORS and YAML config")
    parser.add_argument('--config', type=str, default='configs/local.yaml', help='config YAML filepath')
    parser.add_argument('--host', type=str, default='127.0.0.1', help='http listening host')
    parser.add_argument('--port', type=int, default=5000, help='http listening port')
    parser.add_argument('--debug', action='store_true', help='debug mode')
    args = parser.parse_args()

    with open(args.config, 'r') as f:
        config = yaml.safe_load(f)

    app = create_app(config)
    print(f"==> args: {args}")
    app.run(host=args.host, port=args.port, debug=args.debug)
