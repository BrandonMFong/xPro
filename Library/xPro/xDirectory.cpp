/**
 * @file xDirectory.cpp
 * 
 * @brief xDirectory class
 * 
 * @author Brando
 */

#include <xPro/xDirectory.h>

xDirectory::xDirectory()
{
    this->path = xNull;
    this->exists = False;
}

xDirectory::xDirectory(xString path)
{
    bool result = false; // Will assume it does not exist
    struct stat buffer;

    this->path = path; 

    // for the case of Windows
    // I am not sure if this will affect any file system directories in UNIX 
    if(this->path[0] == '\\') this->path.erase(0,1); 

    result = (stat(this->path.c_str(), &buffer) == 0); // does file exist

    this->exists = result;
}

xBool xDirectory::Exists()
{
    return this->exists;
}
