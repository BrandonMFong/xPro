/**
 * @file xpro.goto
 * 
 * @brief 
 * 
 * @author Brando (BrandonMFong.com)
 */

#include <xPro/xPro.h>

/**
 * @brief   We are only accepting the directory alias. The push flag was never really used when I implemented
 *          it in powershell
 * 
 */
#define MAXARG 1

// I want to have an argument handler but I don't have enough times I deal with this 
// arguments to solidify a template yet 
// So, will deal with arguments in main for now until I 
// get a better idea 
int main(int argc, char *argv[]) 
{
    xStatus status = Good;
    xInt argIndex = 1; // We only have one argument here 
    xUInt size = 0;
    xString destination;
    xString alias;
    xDirectory * directory = new xDirectory();
    xAppPointer * AppPointer = new xAppPointer();
    xConfigReader * ConfigReader = new xConfigReader(*AppPointer);

    if(argc > (MAXARG + 1))
    {
        status = Bad; // we have more than 1 argument 
    }

    if(status)
    {
        alias = argv[argIndex];
        std::cout << alias << std::endl;
        status = !alias.empty(); 
    }

    if(status)
    {
        size = ConfigReader->Machine.Directories.Directory.size();
        std::cout << size << std::endl;
        for(xUInt i = 0; i < size; i++)
        {
            std::cout << ConfigReader->Machine.Directories.Directory[i].Alias << std::endl;
            if(ConfigReader->Machine.Directories.Directory[i].Alias == alias)
            {
                std::cout << "Found " << alias << std::endl;
                directory = new xDirectory(ConfigReader->Machine.Directories.Directory[i].InnerXml);
                break;
            }
        }

        status = directory->Initialized() ? directory->Status() : Bad;
    }
    std::cout << status << std::endl;

    // set the current directory    
    if(status)
    {
        status = directory->SetDirectory();
    }

    return (xInt)(!status);
}
