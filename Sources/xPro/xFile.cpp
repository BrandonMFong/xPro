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
    this->_path = xEmptyString;
    this->exists = False;
    this->_name = xNull;
}

xFile::xFile(xString path)
{
    // const xString pathString = path;
    const fs::path tempPath(path); // Constructing the path from a string is possible.
    std::error_code ec; // For using the non-throwing overloads of functions below.

    if(IsxFile(tempPath,ec))
    {
        this->SetPath(path); // Set's the private path member 
        this->SetExists();
        this->_name = LeafItemFromPath(this->_path);
    }
    
    if(ec || this->Exists()) 
    {
        std::cout << "xFile: File may not exist" << std::endl; 
    }
}

xString xFile::Content()
{
    xInputFile ifs(this->_path);
    std::string content((std::istreambuf_iterator<char>(ifs)),(std::istreambuf_iterator<char>()));
    return content;
}

xString xFile::Name()
{
    return this->_name;
}

xBool xFile::IsFile()
{
    return this->_isFile;
}
