import os, subprocess, shlex

import psutil


procs = [proc for proc in psutil.process_iter()]


cmd = shlex.split("ShiBanQiao.exe -AudioMixer -PixelStreamingIP=47.117.115.165 -PixelStreamingPort=8204 -RenderOffScreen")
process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

proc = psutil.Process(process.pid)

target = proc.children()[0].children()[0]



os.getcwd()
os.chdir("D:\ShiBanQiao3-24")

cmd = shlex.split("ShiBanQiao.exe -AudioMixer -PixelStreamingIP=47.117.115.165 -PixelStreamingPort=8204 -RenderOffScreen")
process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)


proc = psutil.Process(5544)

target = proc.children()[0].children()[0]
