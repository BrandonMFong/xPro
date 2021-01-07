/**
 * @file xDirectory.h 
 * 
 * @brief xDirectory class
 * 
 * @author Brando
 */

#ifndef _XDIRECTORY_
#define _XDIRECTORY_

#include <xPro/xPro.h>

class xDirectory
{
public:
    xDirectory();
    xDirectory(xString path);
    xBool Exists();
private:
    xString path;
    xBool exists;
};

#endif