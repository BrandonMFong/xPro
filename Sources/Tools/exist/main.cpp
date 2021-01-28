/**
 * @file xpro.exist
 * 
 * @brief Determines if item is true
 * 
 * @author Brando (BrandonMFong.com)
 */

#include <xPro/xPro.h>

xBegin

    xInt index = 1; // we are only accepting one argument here
    xDirectory * item;

    // Exit program if this is met
    if (argc != 2)
    {
        std::cout << "No argument was passed" << std::endl;
        return 1; // should be less than or equal to two 
    } 

    item = new xDirectory(argv[index]);

    std::cout << "File " << (item->Exists() ? "does exist" : "does not exist") << std::endl;

xEnd