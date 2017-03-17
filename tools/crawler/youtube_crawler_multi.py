#!/usr/bin/python
# coding=utf-8
from __future__ import unicode_literals
import youtube_dl
import urllib2
import csv
import sys,os,re
import subprocess
import time
import numpy
import Queue
import threading

# 宏变量
store_path = 'tmp/'
file_extension = '.mp4'
threadn = 8
down_queue = Queue.Queue()
ydl_opts = {'outtmpl': 'tmp/%(id)s_temp.%(ext)s','format': 'worstvideo[ext=mp4]+bestaudio[ext=m4a]/mp4', 'ignoreerrors':True,'quiet':True}
global_counter = 0
counterLock = threading.RLock()

def downloader(threadID, q):
	global global_counter
	global ydl_opts
	while not q.empty():
		cvs_line = q.get()
		with counterLock:
			global_counter+=1
			print "%d processing video no. %d,  %s" % (threadID, global_counter, cvs_line[0])
			
		YTID = cvs_line[0]  

		start_sec = str(max(int(float(cvs_line[1]))-30,0))
		end_sec = str(int(float(cvs_line[2]))+30)
		duration = str(70)
		pos_labels = cvs_line[3].strip()
		
		try:
			if os.path.isfile(store_path+YTID+file_extension):	
				raise OSError

			url = 'https://www.youtube.com/watch?v=' + YTID #+ '?start=' + start_sec + '&end' + end_sec
		################
			with youtube_dl.YoutubeDL(ydl_opts) as ydl:
				ydl.download([url])
			subprocess.call(['ffmpeg', '-nostats', '-loglevel','error','-i', 'tmp/'+YTID+'_temp.mp4', '-ss', start_sec, '-codec', 'copy', '-t', duration, 'tmp/'+YTID+'.mp4'])
			subprocess.call(['rm','tmp/'+YTID+'_temp.mp4'])

		except OSError, e:
			try:
				print "%s exists!!!" % YTID
			except IndexError, e:
				print "We have downloaded all the elements in the cvs file.Thread %d exit" %(threadID)
				# 打印统计信息
				sys.exit() 
		# HTTPError:
			#HTTPError 是 URLError的子类
		except urllib2.HTTPError, e:
			print e.code
			print e.reason
			print 'Waitingfor reconnect ...'
		# URLError 产生的原因：
			# 网络无连接
			# 连接不到特定的服务器
			# 服务器不存在
		except urllib2.URLError, e: 
			print e.reason
			print 'Waiting for reconnect ...'
			get_times = 0
			while True:
				if not os.system('ping -c 1 -w 1 www.baidu.com'):
					get_times += 1
					if get_times < 3:
						continue
					break
				get_times = 0
			print 'Get back to work'
		else: 
			q.task_done()


# 读取cvs文件
try:
	cvs_file = file('balanced_train_segments.csv','rb')
except IOError, e:
	print e
	sys.exit()

print "Load list CVS file ..."
cvs_handler = csv.reader(cvs_file)
cvs_list = []
for line in cvs_handler:
	cvs_list.append(line)	
cvs_file.close()
print "Done"

# 统计信息
cvs_head = cvs_list[0:3]
cvs_list[0:3] = []

########################for testing purposes##############
cvs_list = cvs_list[0:600]
#########################################

for i in cvs_list:
	down_queue.put(i)


start_t = time.time()

threads = []
for i in range(threadn):
	try:
		p = threading.Thread(target=downloader, args=(i, down_queue,))
		threads.append(p)
		p.start()
		print("Thread %d up and running" %(i))
	except:
		print("Failed to create thread %d" %(i))

for t in threads:
	t.join()
end_t = time.time()
print("Download Complete")
print(end_t-start_t)	