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
    this->_exists = False;
    this->_name = xNull;
}

xFile::xFile(xString path)
{
    xBool result = true;
    const xPath tempPath(path); // Constructing the path from a string is possible.
    std::error_code ec; // For using the non-throwing overloads of functions below.

    result = IsFile(tempPath,ec);
    
    if(result) this->SetPath(path); // Set's the private path member 
    if(result) this->SetExists();
    if(result) this->_name = LeafItemFromPath(this->_path);
    
    if(ec || !this->_exists || !result) 
    {
        std::cout << "xFile: File may not exist" << std::endl; 
    }
}

xString xFile::Content()
{
    xInputFile * ifs;
    xString * fileContent = new xString();

    // If the file exists, init with content
    if(this->Exists())
    {
        ifs = new xInputFile(this->_path);
        fileContent = new xString((std::istreambuf_iterator<char>(*ifs)),(std::istreambuf_iterator<char>())); // init with new content
    }
    return *fileContent;
}

xString xFile::Name()
{
    return this->_name;
}

// xBool xFile::IsFile()
// {
//     return this->_isFile;
// }
