// xPro

#include "xProLibrary.h"


int main(int argc, char *argv[]) 
{
    int index = 1; // we are only accepting one argument here
    std::string path; // will hold the argument 

    // Exit program if this is met
    if (argc != 2)
    {
        std::cout << "No argument was passed" << std::endl;
        return 1; // should be less than or equal to two 
    } 

    // Since there should only be two, this is the index to get the argument I want
    path = argv[index];

    enumItemsInDir(path);

    return 0;
}
