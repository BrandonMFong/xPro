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
    xString Content();
    xString Name();
    xBool IsFile();
private:
    xString _name;
    xBool   _exists,
            _isFile;
};

#endif