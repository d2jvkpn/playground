#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)


uv pip install jupyterlab-execute-time

uv pip install jupyter-resource-usage
# config to show cpu, ~/jupyter/jupyter_lab_config.py
#
#```bash
#[ -s ~/jupyter/jupyter_lab_config.py ] || jupyter-lab --generate-config
#```
#
#```python
#c = get_config()
#c.ResourceUseDisplay.track_cpu_percent = True
#```

uv pip install jupyterlab-nvdashboard

#uv pip install bash_kernel
#python -m bash_kernel.install
