// xPro
// zero index

#include <xPro/xPro.h>
// #include "xProLibrary.h"

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
    std::vector<std::string> filepathvector;
    // std::vector<std::string>::iterator itr;
    std::string filepath = "";

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
        if(strcmp(argv[i],pathFlag) == 0) 
        {
            args.path = argv[i+1];

            // going to test if the path exists
            // if it does, then the IsExist() will string the leading dir separator
            if(!IsExist(args.path))
            {
                // std::cout << "Path does not exist.  Please check spelling" << std::endl;
                return 1;
            }
        }
        else if (strcmp(argv[i],indexFlag) == 0) 
        {
            // convert char* to int 
            strValue << argv[i+1];
            strValue >> args.index;
        }
    }

    filepath = GetFileByIndex(args.path,args.index);
    std::cout << GetLeafItem(filepath) << std::endl;
    
    return 0;
}