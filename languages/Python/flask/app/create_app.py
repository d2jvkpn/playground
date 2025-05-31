#!/usr/bin/env python3
import os, uuid, time


import magic
from werkzeug.utils import secure_filename
from flask import Flask, request, jsonify, Request
from flask_cors import CORS

Request.default_headers = {}

def create_app(config):
    app = Flask(__name__)
    cors_origins = config.get("cors_origins", "*")
    CORS(app, resources={r"/*": { "origins": cors_origins }})

    app.config["UPLOAD_FOLDER"] = config["upload_folder"]
    app.config["MAX_FILE_SIZE"] = config["max_file_size_mb"] * 1024 * 1024 

    allowed_extensions = config["allowed_extensions"]

    def allowed_file(file):
        if not '.' in file.filename:
            return False, "no file extension"

        ext = file.filename.rsplit('.', 1)[1].lower()
        if ext is None or ext not in allowed_extensions:
            return False, "file extension not allowed"

        buffer = file.read(2048)
        file.seek(0)
        mime = magic.from_buffer(buffer, mime=True)
        if mime not in allowed_extensions[ext]:
           return False, "invalid mime type"

        return True, "ok"

    @app.after_request
    def apply_default_headers(response):
        response.headers["X-App-Version"] = "1.0.0"
        return response

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

    @app.route("/healthz", methods=["GET"])
    def health_check():
      return "", 200

    @app.route("/echo", methods=["POST"])
    def echo():
        name = request.args.get('name', "")
        user_agent = request.headers.get("User-Agent")
        if not request.is_json:
            return jsonify({"code": "not_json", "msg": "Request must be JSON"}), 400

        data = request.get_json()
        return jsonify({"code": "ok", "data": {"name": name, "data": data, "user_agent":  user_agent }})

    @app.route("/slow", methods=["GET"])
    def slow():
        print("🌙 slow request start")
        time.sleep(10)
        print("🌞 slow request done")
        return "Done\n"

    @app.route("/upload", methods=["POST"])
    def upload_file():
        if 'file' not in request.files:
            return jsonify({"code": "params_required", "msg": "No file part"}), 400

        file = request.files['file']
        if file.filename == '':
            return jsonify({"code": "invalid_params", "msg": "No selected file"}), 400

        ok, msg = allowed_file(file)
        if not ok:
            return jsonify({ "code": "invalid_file_type", "msg": msg }), 400

        file_id = str(uuid.uuid4()) # uuid.uuid4().hex
        save_path = os.path.join(app.config["UPLOAD_FOLDER"], f"{file_id}_{secure_filename(file.filename)}")
        file.save(save_path)
        size_bytes = os.path.getsize(save_path)

        data = { "id": file_id, "save_path": save_path, "size_bytes": size_bytes }
        return jsonify({ "code": "ok", "data": data })

    return app
