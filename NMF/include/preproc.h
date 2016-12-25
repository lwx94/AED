#ifndef PREPROC_HEADER
#defien PREPROC_HEADER
#include <iostream>

namespace AED_NMF{
	class preProcParams{
	public:
		preProcParams();
		~preProcParams();
		
		int width;
		
		
	};
	
	class preProcessor{
	public:
		void spectrum(eigen::matrix& preM,eigen::matrix postM);
	
	};
}

#endif
