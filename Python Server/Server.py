#use ipad external display for processing.
#processing and server and figgie run on same computer

import numpy as np
from numpy import save
from numpy import load
import cv2
from mss import mss
from PIL import Image
import pytesseract
import time
import socket
import os
os.system("kill -9 $(lsof -ti:9090)")
import os
import signal
from subprocess import Popen, PIPE
SERVER = True

if (SERVER):
    port = 9090
    process = Popen(["lsof", "-i", ":{0}".format(port)], stdout=PIPE, stderr=PIPE)
    stdout, stderr = process.communicate()
    for process in str(stdout.decode("utf-8")).split("\n")[1:]:       
        data = [x for x in process.split(" ") if x != '']
        if (len(data) <= 1):
            continue
        os.kill(int(data[1]), signal.SIGKILL)




if (SERVER):
    HOST = '127.0.0.1'
    PORT = 9090
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    server.bind((HOST, PORT))
    server.listen()
    conn, addr = server.accept() 
    conn.setblocking(0)


bounding_box = {'top': 0, 'left': 0, 'width': 1469, 'height': 955}
sct = mss()
redName = ''
yellowName = ''
greenName = ''
blueName = ''
myName = ''
lastTradeFrame = np.zeros((150, 540, 4))
whiteNameFrame = np.zeros((20, 200, 4))

synced = True
syncReference = np.load("syncFrame.npy")

def preprocess(img):
    width = img.shape[1]*10
    height = img.shape[0]*10
    resized = cv2.resize(img, dsize = (width, height), interpolation = cv2.INTER_CUBIC)
    gry = cv2.cvtColor(resized, cv2.COLOR_BGR2GRAY)
    otsu = cv2.threshold(gry,0,255,cv2.THRESH_BINARY+cv2.THRESH_OTSU)[1]
    #otsu = 255-otsu
    return otsu


#time.sleep(1)
if (SERVER):
    print("Connected")
while True:
    if (SERVER):
        try:
            msg = conn.recv(2048)
            msg = msg.decode()
            if (msg != None):
                if (msg == "LOAD PLAYERS"):
                    print("LOADING PLAYERS")
                    redName = ''
                    yellowName = ''
                    greenName = ''
                    blueName = ''
                    myName = ''
                    if (redName == ''):
                        redFrame = frame[518*2:(518+20)*2, 80*2:(80+200)*2]
                        redFrame[redFrame > 100] = 255
                        redName = pytesseract.image_to_string(redFrame, config='--psm 7').replace('\n', '').replace('\x0c', '')
                        if (redName.find(" ") != -1):
                            redName = redName[redName.rfind(' ')+1:]
                        if (redName != '' and redName != "Be"):
                            print("Red: " + redName)
                            msg = "R: " + str(redName)
                            msg = msg.encode() 
                            if SERVER:
                                try:
                                    conn.send(msg)
                                except:
                                    print("TIMEOUT")
                
                    if (yellowName == ''):
                        yellowFrame = frame[256*2:(256+20)*2, 270*2:(270+200)*2]
                        yellowFrame[yellowFrame > 100] = 255
                        yellowName = pytesseract.image_to_string(yellowFrame, config='--psm 7').replace('\n', '').replace('\x0c', '')
                        if (yellowName.find(" ") != -1):
                            yellowName = yellowName[yellowName.rfind(' ')+1:]
                        if (yellowName != '' and yellowName != "Be"):
                            msg = "Y: " + str(yellowName) 
                            msg = msg.encode() 
                            print("Yellow: " + yellowName)
                            if SERVER:
                                try:
                                    conn.send(msg)
                                except:
                                    print("TIMEOUT")
                    
                    
                    if (greenName == ''):
                        greenFrame = frame[256*2:(256+20)*2, 750*2:(750+200)*2]
                        greenFrame[greenFrame > 100] = 255
                        greenName = pytesseract.image_to_string(greenFrame, config='--psm 7').replace('\n', '').replace('\x0c', '')
                        if (greenName.find(" ") != -1):
                            greenName = greenName[greenName.rfind(' ')+1:]
                        if (greenName != '' and greenName != "Be"):
                            msg = "G: " + str(greenName)
                            msg = msg.encode() 
                            print("Green: " + greenName)
                            if SERVER:
                                try:
                                    conn.send(msg)
                                except:
                                    print("TIMEOUT")    
                    if (blueName == ''):
                        blueFrame = frame[518*2:(518+20)*2, 910*2:(910+200)*2]
                        blueFrame[blueFrame > 100] = 255
                        blueName = pytesseract.image_to_string(blueFrame, config='--psm 7').replace('\n', '').replace('\x0c', '')
                        if (blueName.find(" ") != -1):
                            blueName = blueName[blueName.rfind(' ')+1:]
                        if (blueName != '' and blueName != "Be"):
                            print("Blue: " + blueName)
                            msg = "B: " + str(blueName) 
                            msg = msg.encode() 
                            if SERVER:
                                try:
                                    conn.send(msg)
                                except:
                                    print("TIMEOUT")
                    
                    if (myName == ''):
                        myFrame = frame[788*2:(788+20)*2, 540*2:(540+150)*2]
                        myName = pytesseract.image_to_string(myFrame, config='--psm 7').replace('\n', '').replace('\x0c', '')
                        if (myName.find(" ") != -1):
                            myName = myName[myName.rfind(' ')+1:]
                        if (myName != ''):
                            print("YOU: " + myName)
                            msg = "M: " + str(myName) 
                            msg = msg.encode() 
                            if SERVER:
                                try:
                                    conn.send(msg)
                                except:
                                    print("TIMEOUT")
                if (msg == "COUNT CARDS"):
                    print("COUNTING CARDS")
                    spadesFrame = frame[885*2:(885+15)*2, 385*2:(382+12)*2]
                    clubsFrame = frame[885*2:(885+15)*2, 520*2:(518+10)*2]
                    diamondsFrame = frame[885*2:(885+15)*2, 656*2:(654+10)*2]
                    heartsFrame = frame[885*2:(885+15)*2, 792*2:(790+10)*2]

                    spadesFrame = preprocess(spadesFrame)
                    clubsFrame = preprocess(clubsFrame)
                    diamondsFrame = preprocess(diamondsFrame)
                    heartsFrame = preprocess(heartsFrame)
                    

                    spades = (pytesseract.image_to_string(spadesFrame, config='--psm 8').replace('\n', '').replace('\x0c', '').replace(" ", ""))
                    clubs = (pytesseract.image_to_string(clubsFrame, config='--psm 8').replace('\n', '').replace('\x0c', '').replace(" ", ""))
                    diamonds = (pytesseract.image_to_string(diamondsFrame, config='--psm 8').replace('\n', '').replace('\x0c', '').replace(" ", ""))
                    hearts = (pytesseract.image_to_string(heartsFrame, config='--psm 8').replace('\n', '').replace('\x0c', '').replace(" ", ""))

                    msg = "Cards:" + spades + ":" + clubs + ":" + diamonds + ":" + hearts 

                    print(msg)
                    msg = msg.encode() 
                    if SERVER:
                        try:
                            conn.send(msg)
                        except:
                            print("TIMEOUT")
                    
        except Exception as e:
            #print(e)
            pass
    sct_img = sct.grab(bounding_box)
    frame = np.array(sct_img)


    if (False):
        spadesFrame = frame[885*2:(885+15)*2, 385*2:(382+12)*2]
                   

        spadesFrame = preprocess(spadesFrame)
        print((pytesseract.image_to_string(spadesFrame, config='--psm 8').replace('\n', '').replace('\x0c', '').replace(" ", "")))
        cv2.imshow("Frame", (spadesFrame))
        if (cv2.waitKey(1) & 0xFF) == ord('q'):
            cv2.destroyAllWindows()


    syncFrame = frame[160*2:(160+50)*2, 0 : 150*2]
    if (np.mean(np.abs(syncFrame - syncReference) != 0)):
        if (synced == True):
            synced = False
            msg = "NOT SYNCED"
            time.sleep(0.05)
            #print(msg)
            if SERVER:
                try:
                    conn.send(msg.encode())
                except:
                    print("TIMEOUT")
    elif (synced == False):
        synced = True
        msg = "SYNCED"
        try:
            conn.send(msg.encode())
        except:
            print("TIMEOUT")


    if (synced):
        trade_frame = frame[250*2:(250+75)*2, 1130*2:(1130+270)*2]
        if (np.mean(np.abs(trade_frame - lastTradeFrame) != 0)):
            lastTradeFrame = trade_frame
            #cv2.imshow("Frame", trade_frame)
            #if (cv2.waitKey(1) & 0xFF) == ord('q'):
            #    cv2.destroyAllWindows()
            msg = ((pytesseract.image_to_string(trade_frame)).replace('\n', '').replace('\x0c', ''))
            print(msg)
            msg = msg.encode()

            if SERVER:
                try:
                    conn.send(msg)
                except:
                    print("TIMEOUT")
