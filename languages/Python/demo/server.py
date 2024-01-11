import socket

# create a socket object
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 

# bind to the port
port = 9999
host = socket.gethostname()
server.bind((host, port))

# queue up to 5 requests
server.listen(5)

while True:
    # establish a connection
    client,addr = server.accept()
    print("Got a connection from %s" % str(addr))

    msg = 'Thank you for connecting'+ "\r\n"
    client.send(msg.encode('utf8'))
    client.send(msg.encode('utf8'))
    client.close()
