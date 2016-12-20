import re  
import urllib  
import os
  
def getHtml(url):  
	page = urllib.urlopen(url)  
	html = page.read()  
	return html  
    
def getUrl(query,html):  
	reg = r"(?<=a\shref=\"/watch).+?(?=\")"  
	urlre = re.compile(reg)  
	urllist = re.findall(urlre,html)  
	format = "https://www.youtube.com/watch%s\n"  
	filename = query+"_url.txt"
	f = open(filename, 'a')  
	for url in urllist:
		result = (format % url)
		print("-----------------------------")
		#print('youtube-dl -f mp4 -o %s/%%(title)s-%%(id)s.%%(ext)s		%s' %(query,result))
		#os.system('youtube-dl -f mp4 -o ./%s/ %s' %(query,result))
		os.system('youtube-dl -f mp4 %s' %(result))
		f.write(result)  
		print("Done.")
	f.close()  

query = "police riots"	
query = query.replace(" ","+")
if os.path.exists(query)==False:
	os.mkdir(query)
page_st = 1
page_end = 10

for i in range(page_st,page_end+1):  
	html = getHtml("https://www.youtube.com/results?search_query="+query+"&page=%s" % i)  
	getUrl(query,html)
	i += 1  
	print("Query: %s //Page: %s" %(query,i))
print("-----------------------------")
print("Downloaded done, query %s, from page %d to %d"%(query,page_st,page_end))