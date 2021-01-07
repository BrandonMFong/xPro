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
#define xEnumerateDirectoryItems "EnumerateDirectoryItems"

class xDirectory
{
public:
    xDirectory();
    xDirectory(xString path);
    xBool Exists();
    void PrintItems();
    void PrintItems(xString flag);
    xStringArray GetItems();
    xString xDirectory::ItemByIndex(xInt index);
private:
    xString path,leafitem;
    xBool exists;
    xStringArray items;
};

#endif