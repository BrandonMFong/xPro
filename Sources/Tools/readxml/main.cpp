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
    // xXml * xmlFile = new xXml("/home/brandonmfong/source/repo/xPro/Config/Users/Makito.xml"); 
    xConfigReader * config = new xConfigReader("/Users/BrandonMFong/brando/sources/repos/xPro/Config/Users/Makito.xml"); 

    std::cout << config->Machine.UpdateStamp.Value << std::endl;

    return 0;
}