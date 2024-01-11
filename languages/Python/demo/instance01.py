os.getcwd()
os.chdir("D:\ShiBanQiao3-24")

cmd = "ShiBanQiao.exe -AudioMixer -PixelStreamingIP=47.117.115.165 -PixelStreamingPort=8204 -RenderOffScreen"
px = ProcX(cmd)

ok = px.run()
print(ok)


# px.process
px.isRunning()
px.status()


px.execute("stop")
px.status()


px.status()


px.execute("resume")
px.status()


# px.terminate()
px.execute("kill")
px.status()


px.status()


px.is_running()


px.run()
