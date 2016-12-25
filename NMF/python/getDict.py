import numpy as np
import glob
import scipy.io.wavfile as wavio
import scipy.signal as sg
import matplotlib.pyplot as plt
import nmf


#read wav file and return the spectogram
def readwav(path):
	wav_object = wavio.read(path)
	f,t,Sxx = sg.spectrogram(wav_object[1],wav_object[0])
	return f,t,Sxx

def show(spec):
	plt.pcolormesh(spec[1],spec[0],spec[2])
	plt.ylabel('Frequency [Hz]')
	plt.xlabel('Time [sec]')
	plt.show()
	return

def main():
	path = r'G:\School\thesis\DS4_T\wav_renamed'
	WavFiles = glob.glob(path + '\\*.' + 'wav')
	for index in WavFiles:
		spec = readwav(index)
		show(spec)
	return

if __name__ == "__main__":
	main()
	
	