#ifndef IO_HEADER
#define IO_HEADER
#include <iostream>

namespace AED_NMF{
	class io{
	public:
		io(string path);
		~io(){}
		bool readwav(char* filename,eigen::matrix m);
		bool writelog(char* filename);
		bool writeresults(char* filename);
		void getallfiles(std::vector<string> &filelist);
		
	private:
		std::string workpath;
	};
}
#endif