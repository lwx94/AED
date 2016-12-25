import numpy as np

class parameters(object):
	maxiters = 0
	convolutive = True
	TDL = False
	MLD = True
	tol = 0
	
	def __init__(self,maxiter,conv,tdl,mld,tol):
		self.maxiters = maxiter
		self.convolutive = conv
		self.MLD = mld
		self.TDL = tdl
		self.tol = tol
	
	def __str__():

class NMF(object):
	V = np.array([0])
	H = []
	W = []
	para = parameters()
	
	def __init__(self,V,parameters):
		self.V = V
		self.
	
	def decompose():