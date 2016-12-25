#include "nmf.h"

namespace AED_NMF{
	NMF::NMF(){
		matrix = new eigen::matrix;
	}
	
	NMF::NMF(eigen::matrix mM){
		matrix = mM;
	}
	NMF::~NMF(){
		delete matrix;
	}
	bool setmatrix(eigen::matrix mM){
		matrix = mM;	
	}
	void iter(){
		
	}
	
}