import os, time, shlex, subprocess

import psutil, GPUtil


def gpuInfo() -> dict:
    gpus = GPUtil.getGPUs()
    if len(gpus) == 0: return {}
    gpu = gpus[0]

    # gpu.id, gpu.name, gpu.uuid
    return {
        "load_percent": round(gpu.load*100, 2),
        "memory_percent": round(gpu.memoryUsed/gpu.memoryTotal*100, 2),
        "temperature": gpu.temperature,
    }


class ProcX:
    cmd = []
    wd = ""
    n = 0
    process = None

    __wait_seconds = 5;
    __cpu_interval = 1;

    def __init__(self, cmd: str):
        x = shlex.split(cmd)
        if len(x) < 2: return False
        self.cmd, self.wd = x, os.getcwd()

    def run(self, excludes=[]) -> bool:
        try:
            process = subprocess.Popen(
              self.cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
            )
            # process.kill()
        except:
            print("command start failed: 1")
            return False

        time.sleep(self.__wait_seconds)
        procs = []
        for proc in psutil.process_iter(): # can't get commandline process id directly
            if len(proc.children()) > 0 or proc.pid in excludes: continue
            if proc.name() == self.cmd[1]: procs.append(proc)

        if len(procs) == 0:
            print("command start failed: 2")
            return False

        procs.sort(key=lambda p: p.create_time(), reverse=True)
        # print(procs)
        self.process, self.n = procs[0], 1
        return True

    def isRunning(self) -> bool:
        if self.process is None: return False

        return self.process.is_running()

    def kill(self):
        if self.process is None: return

        self.process.kill()

    def status(self) -> dict:
        if self.process is None: return {}

        cpu_percent = round(self.process.cpu_percent(self.__cpu_interval)/psutil.cpu_count(), 2)
        status = self.process.status()
        status = "suspened" if status == "stopped" else status

        return {
            "staus": status,
            "memory_percent": round(self.process.memory_percent(), 2),
            "cpu_percent": cpu_percent,
            "system_gpu_info": gpuInfo(),
        }
