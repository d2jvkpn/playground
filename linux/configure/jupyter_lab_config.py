# path: ~/.jupyter/jupyter_lab_config.py
# $ jupyter-lab --generate-config
# $ jupyter-lab --no-browser --NotebookApp.token='' --NotebookApp.password='' --ip=127.0.0.1 --port=8888

c = get_config()  #noqa

c.ServerApp.open_browser = False
c.ServerApp.token = ''
c.ServerApp.password = ''
c.ServerApp.ip = 'localhost'
c.ServerApp.port = 8888
