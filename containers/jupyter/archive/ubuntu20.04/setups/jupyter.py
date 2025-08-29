#! /usr/bin/env python3
import os, sys, subprocess

from notebook.auth import passwd

port, password = os.getenv("JUPYTER_Port"), os.getenv("JUPYTER_Password")
if port == "" or password == "":
    sys.exit("JUPYTER_Port or JUPYTER_Password is unset.")

# dirpath = os.path.dirname(os.path.abspath(sys.argv[0]))
dirpath = os.getcwd()

ret = subprocess.run(["jupyter", "notebook", "--generate-config", "-y"])
if ret.returncode != 0: sys.exit(1)

appendLines = """
c.NotebookApp.open_browser = False
c.NotebookApp.allow_root = True
c.NotebookApp.allow_origin = '*'
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = %s
""" % port

pemFile = os.path.join(dirpath, "jupyter.pem")
keyFile = os.path.join(dirpath, "jupyter.key")
if os.path.isfile(pemFile) and os.path.isfile(keyFile):
    appendLines += ("c.NotebookApp.certfile = u'%s'\n" % pemFile)
    appendLines += ("c.NotebookApp.keyfile = u'%s'\n" % keyFile)

appendLines += ("c.NotebookApp.password = u'%s'\n" % passwd(password))

script = os.path.expanduser("~/.jupyter/jupyter_notebook_config.py")
with open(script, "a") as f: f.write(appendLines)
