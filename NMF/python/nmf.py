from numpy import *
import re

class NMF(object):
	V = []
	V_pre = []
	H = []
	W = []
	r = 1;
	maxiters = 0
	loss_function = "sq"
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
			if(re.match(r"loss_function:",ln)):
				self.loss_function = re.split(r" |\n",ln)[1]
			if(re.match(r"convolutive:",ln)):
				self.convolutive = bool(re.split(r" |\n",ln)[1])
			if(re.match(r"TDL:",ln)):
				self.TDL = bool(re.split(r" |\n",ln)[1])
			if(re.match(r"MLD:",ln)):
				self.MLD = bool(re.split(r" |\n",ln)[1])
			if(re.match(r"tol:",ln)):
				self.tol = float(re.split(r" |\n",ln)[1])
			if(re.match(r"r:",ln)):
				self.r = int(re.split(r" |\n",ln)[1])
	
	#########printing current parameters and shape of matrix and factors############
	def printparas(self):
		print("--------------------------")
		print("Parameters: ")
		print("Max Iterations: %d" %int(self.maxiters))
		print("Loss functino: %s" %self.loss_function)
		print("Convolutive: %d" %int(self.convolutive))
		print("TDL: %d" %int(self.TDL))
		print("MLD: %d" %int(self.MLD))
		print("Tolerance: %f" %float(self.tol))
		print("Target dimension R: %f" %int(self.r))
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
	
	def loss(self):
		err = 0
		if(self.loss_function == "sq"):
			#### just for test
			E = self.V-self.V_pre
			m,n = E.shape
			
			for i in xrange(m):
				for j in xrange(n):
					err += E[i,j]*E[i,j]
					
		if(self.loss_function == "KL"):
			m,n = self.V.shape
			for i in xrange(m):
				for j in xrange(n):
					err += self.V[i,j]*log(self.V[i,j]/self.V_pre[i,j])-self.V[i,j]+self.V_pre[i,j]
		return err
	
	def update(self):	
	########most descent gradient#########
		desc = self.loss_function
		if(desc == "sq"):
			m,n = self.V.shape
			a = self.W.T*self.V
			b = self.W.T*self.W*self.H
			for i in xrange(self.r):
				for j in xrange(n):
					if b[i,j] !=0:
						self.H[i,j] = self.H[i,j]*a[i,j]/b[i,j]
						
			c = self.V*self.H.T
			d = self.W*self.H*self.H.T
			
			for i_2 in xrange(m):
				for j_2 in xrange(self.r):
					if d[i_2,j_2] !=0:
						self.W[i_2,j_2] = self.W[i_2,j_2]*c[i_2,j_2]/d[i_2,j_2]
		if(desc =="KL"):
			m,n = self.V.shape
			One = ones((m,n))
			V_err = mat(array(self.V)*array(self.V_pre))
			self.H = mat(array(self.H)*(array(self.W.T*V_err)/array(self.W.T*One)))
			self.W = mat(array(self.W)*(array(V_err*self.H.T)/array(One*self.H.T)))		
	
	def decompose(self):
		m,n = shape(self.V)
		self.W = mat(random.random((m,self.r)))
		self.H = mat(random.random((self.r,n)))

		for x in xrange(self.maxiters):
			self.V_pre = self.W*self.H
			err = self.loss()
			print("iteration no.%d err: %f" %(x,err))
			
			if(err<self.tol):
				print("Converged. Stopping iteration.")
				break
			
			self.update()
			
			
			
			
		
			
		
		return