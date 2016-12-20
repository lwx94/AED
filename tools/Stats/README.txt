#############################USAGE############################
CMD "python event_stats.py <filepath> <rename>(optional)"

-filepath is the folder of the textgrid folder, 
-rename is the base rename string, for example string "AEDA" 
 will rename both textgrid and wav files to AEDA_000X_XX_XX.wav etc.
 if rename is left out, the script will not rename the files.
 
 #############################USAGE############################

 
#############################FUNCTION#########################
-This script outputs the event statistics of a TEXTGRID and 
 WAV folder and can rename all files in the folder if chosen so. 
-Please backup your files before using this script(!!!).
-Each tier is calculated independantly.
-This script outputs stat.txt and count.txt.
 stat.txt are statistics for the folder, count.txt is the 
 keycount and scenecount for each file.
-Typical output is 
	
	qj	110	1137
	<eventname>	<event times>	<timelength in seconds>
	
#############################FUNCTION#########################


##############################IMPORTANT#######################
-If you rename the files, please make sure that both textgrid and 
 wav files are read in the same order.
-Textgrid files generated from praat may be named different from 
 wav files which could lead to a wrong reading order. The direct 
 outcome is that wav files and textgrid files would be named
 wrong. If you are not sure, please backup before renaming.
 
##############################IMPORTANT#######################
