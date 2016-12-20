#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import sys
import re
import wave
import numpy
import glob

def read_textgrid(label_path,name,tier):
	datalabel = open(os.path.join(label_path,name),'r')
	bPrint = 0
	minlist = []
	maxlist = []
	textlist = []
	
	for index in datalabel.readlines():
		if bPrint==1 and re.search('item',index):
			bPrint = 0	
		if re.search('item \['+tier+'\]',index):
			bPrint = 1
		
		if bPrint:
			m = re.search(r'xmin',index)
			n = re.search(r'xmax',index)
			l = re.search(r'text',index)
			if m:
				v = re.findall(r'xmin = (\d+\.?\d*)',index)[0]
				xmin = int(float(v))
			elif n:
				v = re.findall(r'xmax = (\d+\.?\d*)',index)[0]
				xmax = int(float(v))
			elif l:
				v = re.findall(r'text = \"(.*)\"',index)[0]
				text = v.strip()
				if not text:
					text = 'oth'
				minlist.append(xmin)
				maxlist.append(xmax)
				textlist.append(text)
				if text=="marching":
					print (label_path+name)
					print(text)
					print(index)
	return minlist,maxlist,textlist
	
def data_dict(path,newname):
	
	Event_List = ([],[],[],[],[])
	counter_List = ([],[],[],[],[])
	time_List = ([],[],[],[],[])
	TextGridFiles = glob.glob(path + '\\*.' + 'TEXTGRID')
	WavFiles = glob.glob(path + '\\*.' + 'wav')
	label_path = os.path.join(path,'label')
	dict_path = os.path.join(path,'..\\')
	wav_dict = {}
	label_dict = {}
	tiers = ['1','2','3','4','5']
	v = 0
	for index in TextGridFiles:
		index = index.strip()
		v += 1
		label_pdata = []
		for tier in tiers:
			label_pdata.append(read_textgrid(label_path,index,tier))
		label_dict[index] = label_pdata
	count_list_obj = open(os.path.join(dict_path,"count.txt"),'w')
	for index in TextGridFiles:
		count_list_obj.write("----------------\n")
		count_list_obj.write(index+"\n")
		keycount = 0
		scenecount = 0
		index = index.strip()
		for ii in range(0,5):
			xmin = label_dict[index][ii][0]
			xmax = label_dict[index][ii][1]
			text = label_dict[index][ii][2]
			n = 0
			for x in text:
				if x != "oth":
					if(ii == 0 or ii == 1):
						keycount +=1
					if(ii==3):
						scenecount +=1
				if x not in Event_List[ii]:
					print "%s is a  new class" % x
					Event_List[ii].append(x)
					counter_List[ii].append(1)
					time_List[ii].append(xmax[n]-xmin[n])

				else:
					ind = Event_List[ii].index(x)
					temp0 = counter_List[ii][ind] + 1
					temp1 = time_List[ii][ind] + xmax[n] - xmin[n]
					temp1 = time_List[ii][ind] + xmax[n]-xmin[n]
					counter_List[ii][ind] = temp0
					time_List[ii][ind] = temp1
				n += 1
		count_list_obj.write(str(hex(keycount))+'\t'+str(hex(scenecount))+'\n')
		ind1 = TextGridFiles.index(index)
		num  = str(ind1).zfill(4)
		key = str(hex(keycount))[2:].zfill(2)
		scene = str(hex(scenecount))[2:].zfill(2)
		if newname:
			print WavFiles[ind1]+'\n'
			print TextGridFiles[ind1]+'\n'
			os.system("pause")
			os.rename(WavFiles[ind1],path+"\\"+newname+"_"+num+'_'+key+'_'+scene+'.wav')
			os.rename(TextGridFiles[ind1],path+"\\"+newname+"_"+num+'_'+key+'_'+scene+'.textgrid')
	count_list_obj.close()
	#	wav_list_obj.close()

	events_list_obj = open(os.path.join(dict_path,"stats.txt"),'w')
	
		
	print Event_List
	for ii in range(0,5):
		n = 0
		events_list_obj.write("########################################################\n")
		events_list_obj.write("Tier "+tiers[ii]+'\n')
		for x in Event_List[ii]:
			events_list_obj.write(str(x)+'\t'+str(counter_List[ii][n])+'\t'+str(time_List[ii][n])+"\n")
			n += 1
	events_list_obj.close()

	print "***************************************"
	print "* Creating List Completed!             *"
	print "***************************************"
if __name__=='__main__':
	if len(sys.argv) <2 or len(sys.argv) > 3:
		exit("Usage: data_list.py <dev_path>")
	newname = []
	if len(sys.argv) == 3:
		newname = sys.argv[2]
	data_dict(sys.argv[1],newname)
