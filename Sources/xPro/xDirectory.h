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
    /**
     * @brief Construct a new xDirectory object
     * 
     */
    xDirectory();

    /**
     * @brief Construct a new xDirectory object
     * 
     * @param path filesystem path
     */
    xDirectory(xString path);

    /**
     * @brief Does this object exist in the file system
     * 
     * @return xBool 
     */
    xBool Exists();

    /**
     * @brief Set the object's existence
     * 
     */
    void SetExists();

    /**
     * @brief Prints items from objects path
     * 
     */
    void PrintItems();

    /**
     * @brief Prints items from objects path
     * 
     * @param flag pass xEnumerateDirectoryItems to enumerate the list, otherwise just leave blank
     */
    void PrintItems(xString flag);

    /**
     * @brief If this is a directory and there are items in there, the returned object is filled with those items
     * 
     * @return xStringArray 
     */
    xStringArray GetItems();

    /**
     * @brief Returns the selected object outlined by PrintItems()
     * 
     * @param index The items num on the list
     * @return xString 
     */
    xString ItemByIndex(xInt index);

    /**
     * @brief Returns full path.  If the path isn't a real path, return xEmptyString
     * 
     * @return xString 
     */
    xString Path();

    /**
     * @brief Set the Path 
     * 
     */
    void SetPath(xString path);
protected:
    xString path; /** The object's path */
    xBool exists; /** if the path exists */
private:
    xString leafitem; /** The object's leaf item from path */
    xStringArray items; /** List of items in path */
};

#endif