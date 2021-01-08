/**
 * @file xpro.getpath
 * 
 * @brief returns full path
 * 
 * @author Brando (BrandonMFong.com)
 */

#include <xPro/xPro.h>

int main(int argc, char *argv[]) 
{
    if(argc != 1)
    {
        std::cout   
            << "Usage: getpath <arg>"
            << "    <arg>   Relative or real full path" 
            << 
        std::endl;
    }
    xDirectory * pathObject = new xDirectory(argv[1]);
    std::cout << pathObject->Path() << std::endl;
}