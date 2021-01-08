/**
 * @file xFile.h 
 * 
 * @brief xFile class
 * 
 * @author Brando
 */

#ifndef _XFILE_
#define _XFILE_

#include <xPro/xPro.h>

class xFile : public xDirectory
{
public:
    xFile();
    xFile(xString path);
    xBool Exist();
    xString GetContent();
private:
    xString name;
    xBool exists;
};

#endif