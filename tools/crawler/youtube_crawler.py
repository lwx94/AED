import urllib2
import csv
import re
import os
from pytube import YouTube
from pprint import pprint


proxy = urllib2.ProxyHandler({'https':'127.0.0.1:51077'})
opener = urllib2.build_opener(proxy)


cvsfile = file('E:\\A_RESEARCH_6month\STATE-1_DataPreparation\\audioset\csv\\balanced_train_segments.csv','rb')
cvshandler = csv.reader(cvsfile)
linenum = 0


for line in cvshandler:
	linenum += 1
	if linenum == 1:
		print line[0] 
		continue
	elif linenum == 2:
		print(' '.join(line).strip())
		continue
	elif linenum == 3:
		print(' '.join(line).strip())
		continue

	YTID = line[0]
	start_sec = str(int(float(line[1])))
	duration =  str(int(float(line[2])-float(line[1])))
	end_sec = str(int(float(line[2])))
	pos_labels = line[3].strip()
	
	###

	
	url = 'https://www.youtube.com/watch?v=' + YTID #+ '?start=' + start_sec + '&end' + end_sec

	command = 'youtube-dl  -f "22/mp4/best" --external-downloader ffmpeg --external-downloader-args "-ss %s -t %s" %s' %(start_sec,duration,url)
	#requset = urllib2.Request(url)
	print url
	try:
		#opener.open(url)	
		rs = os.system(command)
		yt = YouTube(url)
		# Once set, you can see all the codec and quality options YouTube has made
		# available for the perticular video by printing videos.

		yt.get_videos()

		# [<Video: MPEG-4 Visual (.3gp) - 144p>,
		#  <Video: MPEG-4 Visual (.3gp) - 240p>,
		#  <Video: Sorenson H.263 (.flv) - 240p>,
		#  <Video: H.264 (.flv) - 360p>,
		#  <Video: H.264 (.flv) - 480p>,
		#  <Video: H.264 (.mp4) - 360p>,
		#  <Video: H.264 (.mp4) - 720p>,
		#  <Video: VP8 (.webm) - 360p>,
		#  <Video: VP8 (.webm) - 480p>]

		# The filename is automatically generated based on the video title.  You
		# can override this by manually setting the filename.

		# view the auto generated filename:
		print(yt.filename)

		# Pulp Fiction - Dancing Scene [HD]

		# set the filename:
		yt.set_filename(YTID)

		# You can also filter the criteria by filetype.
		resolution = re.findall(r'([0-9]+p)',str(yt.filter('mp4')[0]))
		
		# [<Video: Sorenson H.263 (.flv) - 240p>,
		#  <Video: H.264 (.flv) - 360p>,
		#  <Video: H.264 (.flv) - 480p>]

		# Notice that the list is ordered by lowest resolution to highest. If you
		# wanted the highest resolution available for a specific file type, you
		# can simply do:
		#print(yt.filter('mp4')[-1])
		# <Video: H.264 (.mp4) - 720p>

		# You can also get all videos for a given resolution
		#print(yt.filter(resolution='480p'))

		# [<Video: H.264 (.flv) - 480p>,
		#  <Video: VP8 (.webm) - 480p>]

		# To select a video by a specific resolution and filetype you can use the get
		# method.

		video = yt.get('mp4', resolution[0])

		# NOTE: get() can only be used if and only if one object matches your criteria.
		# for example:

		#print(yt.videos)

		#[<Video: MPEG-4 Visual (.3gp) - 144p>,
		# <Video: MPEG-4 Visual (.3gp) - 240p>,
		# <Video: Sorenson H.263 (.flv) - 240p>,
		# <Video: H.264 (.flv) - 360p>,
		# <Video: H.264 (.flv) - 480p>,
		# <Video: H.264 (.mp4) - 360p>,
		# <Video: H.264 (.mp4) - 720p>,
		# <Video: VP8 (.webm) - 360p>,
		# <Video: VP8 (.webm) - 480p>]

		# Since we have two H.264 (.mp4) available to us... now if we try to call get()
		# on mp4...

		#video = yt.get('mp4')
		
		# MultipleObjectsReturned: 2 videos met criteria.

		# In this case, we'll need to specify both the codec (mp4) and resolution
		# (either 360p or 720p).

		# Okay, let's download it! (a destination directory is required)
		
		video.download('E:\\Workspace\\python\\python_crawler\\tmp\\')
		
		
		#print(yt.get_videos())
		#yt.set_filename(YTID)
		#print_out = str(yt.filter('mp4')[-1])
		#print_out_part = print_out[23:27
	except urllib2.URLError, e:
		print e.reason
	
	#yt = YouTube(url)
	#print yt.get_videos()
	# yt.set_filename(YTID)
	# print_out = str(yt.filter('mp4')[-1])
	# print_out_part = print_out[23:27]
	# video = yt.get('mp4',print_out_part)
	# video.download('tmp_srx/')

cvsfile.close()
