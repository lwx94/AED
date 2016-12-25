#include "io.h"

namespace AED_NMF{
	io::io(string path){
		if(path.empty())
			std::cerr<<"Wrong working path input to io class\n";
		workpath = path;
	}
	
	bool io::readwav(){
		
	}
}