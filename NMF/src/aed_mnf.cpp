#include "nmf.h"
#include "cluster.h"
#include "iostream.h"

using namespace AED_NMF;

int main(int argc,char*[] argv)
{
	if(argc<2){
		std::cerr<<"wrong input\n";
		return -1;
	}
	
	string workpath(argv[1]);
	io io_object(workpath);
	NMF nmf_object; 
	cluster cluster_object;
	
	io_object.readwav();

	return 0;
}