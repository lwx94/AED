import os
import re

filepath = "targeturls.txt"
file_object = open(filepath,"r")
lines = file_object.readlines()
for ln in lines:
	if(re.search("#",ln)):
		continue
	os.system('youtube-dl -f mp4 %s' %(ln))
	