#!/usr/bin/env python3
import os, yaml
from pathlib import Path
from dotenv import load_dotenv

#py = os.path.abspath(os.sys.argv[0])
#project = os.path.dirname(py)
#app = os.path.basename(project)
#print(py, project, app)


#### 1. init
env_file = Path("configs") / "local.env"
ok = load_dotenv(dotenv_path=env_file)
print(f"--> loaded {env_file}: {ok}")

with open("project.yaml", 'r') as f:
    project = yaml.safe_load(f)

with open(Path("configs") / "local.yaml", 'r') as f:
    config = yaml.safe_load(f)
    for k, v in config['environment'].items():
        os.environ[k] = v

app_name = os.path.basename(__file__).rsplit(".", 1)[0]


####
print(f"project: {project['name']}, version: {project['version']}, app: {app_name}")
api_key = os.getenv("API_KEY")
