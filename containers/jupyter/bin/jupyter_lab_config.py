# path: ~/.jupyter/jupyter_lab_config.py
# $ jupyter-lab --generate-config
# $ jupyter-lab --no-browser --NotebookApp.token='' --NotebookApp.password='' --ip=127.0.0.1 --port=8888

c = get_config()  #noqa

c.ServerApp.terminado_settings = {
    "shell_command": ["/usr/bin/bash"],
}

c.ServerApp.open_browser = False
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = 8888
#c.ServerApp.token = ''
#c.ServerApp.password = ''

#pip install jupyter-resource-usage
c.ResourceUseDisplay.track_cpu_percent = True
