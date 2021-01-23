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
    xInt index = 1; // We only have one argument here 
    xDirectory * dir;
    xConfigReader * config;

    if(argc > (MAXARG + 1))
    {
        status = Bad; // we have more than 1 argument 
    }

    if(status)
    {
        dir = new xDirectory(argv[index]);
        status = dir->Status(); 
    }

    return (xInt)(!status);
}
