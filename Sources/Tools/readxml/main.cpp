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
    xConfigReader * config = new xConfigReader("/Users/BrandonMFong/brando/sources/repos/xPro/Config/Users/Makitos.xml");

    okayToContinue = config->Exists();
    
    if(okayToContinue)
    {
        xStringArray arr = config->RootChildNames();

        for(itr = arr.begin(); itr < arr.end(); itr++)
        {
            std::cout << *itr << std::endl;
        }
    }

    return 0;
}