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
    xDirectory * pathObject = new xDirectory(argv[1]);
    std::cout << pathObject->Path() << std::endl;
}