import socket

# create a socket object
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# get local machine name
host = socket.gethostname()

port = 9999
client.connect((host, port))

msg = client.recv(1024)

client.close()
print (msg.decode('utf8'))
