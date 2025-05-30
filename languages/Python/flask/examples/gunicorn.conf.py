import multiprocessing


workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "gevent"
graceful_timeout = 30
timeout = 30
keepalive = 60
max_requests = 1000
max_requests_jitter = 50
preload_app = True
loglevel = "info"
bind = "unix:/tmp/gunicorn.sock"
#accesslog = "/var/log/gunicorn/access.log"
#errorlog = "/var/log/gunicorn/error.log"'
