run:
	python3 server.py --host=127.0.0.1 --port=5000 --debug

gunicorn:
	config=configs/local.yaml \
	  gunicorn -c examples/gunicorn.sync.py --workers=4 --bind=127.0.0.1:5000 main:app
