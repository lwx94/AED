import os
start_sec = str(100)
duration = str(60)
url = 'https://www.youtube.com/watch?v=qdkMXEPyXq0'
command = 'youtube-dl  -f "best" --external-downloader ffmpeg --external-downloader-args "-ss %s -t %s" %s' %(start_sec,duration,url)
re = os.system(command)
print(command)
