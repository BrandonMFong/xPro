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
        std::cout << "Not all arguments were passed:" << std::endl;
        std::cout << " -path = Full/Relative path to directory" << std::endl;
        std::cout << " -index = nonzero index of the item in alphabetical order" << std::endl;
        return 1; // should be less than or equal to two 
    } 

    // extract arguments 
    for (int i = 0; i < argc; i++)
    {
        if(strcmp(argv[i],pathFlag)) args.path = argv[i];
        else if (strcmp(argv[i],indexFlag)) 
        {
            // convert char* to int 
            strValue << argv[i];
            strValue >> args.index;
        }
    }
    

    return 0;
}