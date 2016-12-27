from numpy import *
import re

class NMF(object):
	V = []
	H = []
	W = []
	maxiters = 0
	convolutive = True
	TDL = False
	MLD = True
	tol = 0
	#########parameter and V initialization###########
	def __init__(self,V,parameterPath):
		self.V = mat(V)
		fileObject = open(parameterPath,"r")
		lines = fileObject.readlines()
		for ln in lines:
			if(re.match(r"maxiters:",ln)):
				self.maxiters = int(re.split(r" |\n",ln)[1])
			if(re.match(r"convolutive:",ln)):
				self.convolutive = bool(re.split(r" |\n",ln)[1])
			if(re.match(r"TDL:",ln)):
				self.TDL = bool(re.split(r" |\n",ln)[1])
			if(re.match(r"MLD:",ln)):
				self.MLD = bool(re.split(r" |\n",ln)[1])
			if(re.match(r"tol:",ln)):
				self.tol = float(re.split(r" |\n",ln)[1])
	
	#########printing current parameters and shape of matrix and factors############
	def printparas(self):
		print("--------------------------")
		print("Parameters: ")
		print("Max Iterations: %d" %int(self.maxiters))
		print("Convolutive: %d" %int(self.convolutive))
		print("TDL: %d" %int(self.TDL))
		print("MLD: %d" %int(self.MLD))
		print("Tolerance: %f" %float(self.tol))
		if(self.V!=[]):
			print("V shape: %d,%d" %(self.V.shape[0],self.V.shape[1]))
		else:
			print("V shape: %d,%d" %(0,0))
		if(self.H!=[]):
			print("H shape: %d,%d" %(self.H.shape[0],self.H.shape[1]))
		else:
			print("H shape: %d,%d" %(0,0))
		if(self.W!=[]):
			print("W shape: %d,%d" %(self.W.shape[0],self.W.shape[1]))
		else:
			print("W shape: %d,%d" %(0,0))
		print("--------------------------")
	
	########writing decomposition results into a file#############
	def writeresults(self,filename):
		if(self.V!=[]):
			savetxt(filename+"_V.dat",self.V,fmt = ['%s']*self.V.shape[1],newline='\n')
		else:
			print("V is empty")
		if(self.H!=[]):
			savetxt(filename+"_H.dat",self.H,fmt = ['%s']*self.H.shape[1],newline='\n')
		else:
			print("H is empty")
		if(self.W!=[]):
			savetxt(filename+"_W.dat",self.W,fmt = ['%s']*self.W.shape[1],newline='\n')
		else:
			print("W is empty")
	
	def optimize(self):
		
		return
	
	def decompose(self):
		
		return