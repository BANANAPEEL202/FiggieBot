#use ipad external display for processing.
#processing and server and figgie run on same computer

import numpy as np
import cv2
from mss import mss
from PIL import Image
import pytesseract
import time
import socket
#import os

#os.system("kill -9 $(lsof -ti:9090)")
import os
import signal
from subprocess import Popen, PIPE

port = 9090
process = Popen(["lsof", "-i", ":{0}".format(port)], stdout=PIPE, stderr=PIPE)
stdout, stderr = process.communicate()
for process in str(stdout.decode("utf-8")).split("\n")[1:]:       
    data = [x for x in process.split(" ") if x != '']
    if (len(data) <= 1):
        continue
    os.kill(int(data[1]), signal.SIGKILL)

SERVER = True
if (SERVER):
    HOST = '127.0.0.1'
    PORT = 9090
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    server.bind((HOST, PORT))
    server.listen()
    conn, addr = server.accept() 


conn.send(("R: Bot-Gazelle719").encode())
time.sleep(0.1)
conn.send(("G: Bot-Meerkat519").encode())
time.sleep(0.1)
conn.send(("Y: Bot-Rat959").encode())
time.sleep(0.1)
conn.send(("B: Bot-Ferret20").encode())
time.sleep(0.1)

with open("Example Data.txt") as file_in:
    lines = []
    for line in file_in:
        lines.append(line.replace('\n', '').replace('\x0c', ''))
    
index = 0
while (index < len(lines)):
    time.sleep(0.5)
    conn.send(lines[index].encode())
    index+=1
    if (index == len(lines)):
        index = 0
        print("Loop")

     