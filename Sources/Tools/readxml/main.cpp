/**
 * @file xpro.readxml
 * 
 * @brief 
 * 
 * @author Brando (BrandonMFong.com)
 */

#include <xPro/xPro.h>

int main(int argc, char *argv[]) 
{
    xBool okayToContinue;
    xStringArray::iterator itr;
    xConfigReader * config = new xConfigReader("/Users/BrandonMFong/brando/sources/repos/xPro/Config/Users/Makito.xml");

    std::cout << config->Machine.MachineName << std::endl;

    return 0;
}