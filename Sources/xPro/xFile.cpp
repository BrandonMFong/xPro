/**
 * @file xFile.cpp
 * 
 * @brief xFile class
 * 
 * @author Brando
 */

#include <xPro/xFile.h>

xFile::xFile()
{
    this->path = xEmptyString;
    this->exists = False;
    this->name = xNull;
}

xFile::xFile(xString path)
{
    this->SetPath(path);
    this->SetExists();
    this->name = LeafItemFromPath(this->path);
}
