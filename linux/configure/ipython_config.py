# path: ~/.ipython/profile_default/ipython_config.py

c = get_config()

####
#c.InteractiveShellApp.exec_lines = [
#    'import sys; sys.path.insert(0, "/home/jovyan/work/data/packages")',
#]

####
#c.InteractiveShellApp.exec_lines = [
#"""
#from datetime import datetime

#from IPython import get_ipython


#_config_ipython = get_ipython()
#_config_state = {}


#def _config_pre_run_cell(info):
#    start = datetime.now()
#    _config_state['start'] = start
#    start = start.astimezone().strftime("%Y-%m-%d %H:%M:%S%:z")
#    #print(f"Cell start: {_config_state['start'].astimezon():%Y-%m-%d %H:%M:%S.%f}")
#    print(f"CELL START: {start}")

#def _config_post_run_cell(result):
#    end = datetime.now()
#    start = _config_state.get('start', end)
#    elapsed = end - start
#    end = end.astimezone().strftime("%Y-%m-%d %H:%M:%S%:z")
#    print(f"CELL END: {end}, {elapsed}")

#if _config_ipython:
#    _config_ipython.events.register('pre_run_cell', _config_pre_run_cell)
#    _config_ipython.events.register('post_run_cell', _config_post_run_cell)
#""",
#]
