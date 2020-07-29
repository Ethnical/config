#!/usr/bin/env python3
import os,time,subprocess,_thread,threading
from subprocess import PIPE

PATH="/home/pythonwebserver/ftp/"
def maxfromtuple(tab):
    max = 0
    for t in tab:
        if t[0] > max:
            max = t[0]
    return max
class Mycheckfile (threading.Thread):
   def __init__(self,lastdate,delay):
        threading.Thread.__init__(self)
        self.delay = delay
        self.lastdate = lastdate
   def run(self):
       while(True):
            jump = False
            tabtime = []
            listfile = os.listdir(PATH)
            i = 0
            for file in listfile:
                tabtime += [(os.path.getmtime(PATH + file),file)] #unixtimpstamp

            if self.lastdate < (maxfromtuple(tabtime)):
                print("The file : " + file)
                changefile= 0
                oldsize = os.path.getsize(PATH + file)
                time.sleep(2)
                monitoring = True
                while (monitoring):
                    if os.path.getsize(PATH + file) == oldsize:
                        changefile +=1
                        print("la taille du fichier : " + str(os.path.getsize(PATH + file)))
                        if changefile >= 10:
                            print("the following file as been created : " + file)
                            os.system("sudo /home/pythonwebserver/youtube/call_script.sh " + "\"" + PATH + str(file) + "\"")
                            monitoring = False
                            jump = True
                            time.sleep(5)
                    oldsize = os.path.getsize(PATH + file)
                    time.sleep(1)
            self.lastdate = (maxfromtuple(tabtime))
            if jump:
                self.lastdate = os.path.getmtime(PATH +file)

            time.sleep(self.delay)

print("[+] YoutubeFTP started...")
listfile = os.listdir(PATH)
i = 0
tabtime = []
for file in listfile:
    tabtime += [(os.path.getmtime(PATH + file))] #unixtimpstamp
lastdate = max(tabtime)
print(time.ctime(lastdate))
checkfilethread = Mycheckfile(lastdate,0.5)
checkfilethread.start()
