run:
	python3 make_server.py --host=127.0.0.1 --port=5000 --debug

gunicorn:
	gunicorn --workers=4 --worker-class=gevent --graceful_timeout=10 --bind=127.0.0.1:5000 main:app
	# gunicorn -c examples/gunicorn.conf.py --bind=127.0.0.1:5000 main:app
