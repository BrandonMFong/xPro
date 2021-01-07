/**
 * @file xpro.enumdir
 * 
 * @brief Prints out the items in a directory 
 * 
 * @author Brando (BrandonMFong.com)
 */

#include <xPro/xPro.h>

int main(int argc, char *argv[]) 
{
    int index = 1; // we are only accepting one argument here
    xDirectory * path;

    // Exit program if this is met
    if (argc != 2)
    {
        std::cout << "No argument was passed" << std::endl;
        return 1; // should be less than or equal to two 
    } 

    // Since there should only be two, this is the index to get the argument I want
    path = new xDirectory(argv[index]);

    if(!path->Exists()) 
    {
        // std::cout << "Path does not exist.  Please check spelling" << std::endl;
        return 1;
    }

    path->PrintItems(xEnumerateDirectoryItems);

    return 0;
}
