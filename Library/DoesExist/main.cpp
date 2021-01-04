// xPro

#include "xProLibrary.h"

int main(int argc, char *argv[]) 
{
    int index = 1; // we are only accepting one argument here
    bool result = false;

    // Exit program if this is met
    if (argc != 2)
    {
        std::cout << "No argument was passed" << std::endl;
        return 1; // should be less than or equal to two 
    } 

    result = exist(argv[index]);

    std::cout << "File " << (result ? "does exist" : "does not exist") << std::endl;

    return 0;
}