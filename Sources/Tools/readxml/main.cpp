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
    xConfigReader * config = new xConfigReader("/home/brandonmfong/source/repo/xPro/Config/Users/Zukai.xml");

    okayToContinue = config->Exists();

    if(!okayToContinue) return 1;

    std::cout << config->Machine.MachineName << std::endl;

    return 0;
}