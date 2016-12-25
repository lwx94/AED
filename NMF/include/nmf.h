#ifndef NMFHEADER
#define NMFHEADER
#include <iostream>

namespace AED_NMF{
	class NMF{
	public:
		NMF();
		NMF(eigen::matrix mM);
		~NMF();
		void iter();
	private:
		eigen::matrix matrix
	}
};
#endif