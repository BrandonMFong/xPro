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
    /**
     * @brief Construct a new xFile object
     * 
     */
    xFile();

    /**
     * @brief Construct a new xFile object
     * 
     * @param path Path to the file
     */
    xFile(xString path);

    /**
     * @brief Returns the content of the file
     * 
     * @return xString 
     */
    xString Content();

    /**
     * @brief Gets the name of the file 
     * 
     * @return xString 
     */
    xString Name();

    /**
     * @brief Confirms if this is a file
     * 
     * @return xBool 
     */
    // xBool IsFile();
private:
    xString _name; /** Name of the xFile */
    xBool _isFile; /** Boolean flag that shows if file exists */
};

#endif