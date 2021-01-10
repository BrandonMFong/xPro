/**
 * @file xpro.getrootchild
 * 
 * @brief 
 * 
 * @author Brando (BrandonMFong.com)
 */

#include <xPro/xPro.h>

int main(int argc, char *argv[]) 
{
    xXml * xmlDocument;
    xStringArray rootNodeNames;
    xStringArray::iterator nameItr;

    if(argc != 3)
    {
        std::cout << "Usage: xpro.getrootchild <FilePath> <RootNodeName>\n\n";
        std::cout << "\t<FilePath>\t\tFull or relative path to xml file\n";
        std::cout << "\t<RootNodeName>\t\tThe name of the root xml node\n";
        std::cout << std::endl;
        return 1;
    }

    xmlDocument = new xXml(argv[2], argv[1]); 
    rootNodeNames = xmlDocument->RootChildNames();

    std::cout << "Children for " << xmlDocument->RootNodeName() << ": " << std::endl;
    for(nameItr = rootNodeNames.begin(); nameItr < rootNodeNames.end(); nameItr++)
    {
        std::cout << "\t" << *nameItr << std::endl;
    }

    return 0;
}