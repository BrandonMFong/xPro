// xPro
// g++ main.cpp -I./../

#include "xProLibrary.h"

#define ArgsLimit 5

// Flags
#define pathFlag "-path"
#define indexFlag "-index"

struct Arguments 
{
    int index;
    std::string path;
};

int main(int argc, char *argv[]) 
{
    Arguments args;
    std::stringstream strValue;

    // Exit program if this is met
    if (argc != ArgsLimit)
    {
        std::cout << "Not all arguments were passed, must pass arguments with flags:" << std::endl;
        std::cout << " -path = Full/Relative path to directory" << std::endl;
        std::cout << " -index = nonzero index of the item in alphabetical order" << std::endl;
        return 1; // should be less than or equal to two 
    } 

    // extract arguments 
    for (int i = 0; i < argc; i++)
    {
        // If we find correct argument, get the one in the succeeding index 
        if(strcmp(argv[i],pathFlag) == 0) args.path = argv[i+1];
        else if (strcmp(argv[i],indexFlag) == 0) 
        {
            // convert char* to int 
            strValue << argv[i+1];
            strValue >> args.index;
        }
    }

    std::cout << "Index: " << args.index << std::endl;
    std::cout << "Path: " << args.path << std::endl;

    getFileByIndex(args.path,args.index);
    
    return 0;
}