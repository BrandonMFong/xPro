/**
 * @file xFile.cpp
 * 
 * @brief xFile class
 * 
 * @author Brando
 */

#include <xPro/xConfigReader.h>
#include <xPro/xXml.h>
#include <xPro/xFile.h>

xFile::xFile() : xDirectory()
{
    this->_path = xEmptyString;
    this->_exists = False;
    this->_name = xNull;
}

xFile::xFile(xString path) : xDirectory(path)
{
    xBool result = this->_result;
    const xPath * tempPath; // Constructing the path from a string is possible.
    std::error_code ec; // For using the non-throwing overloads of functions below.

    // Test if this is file
    if(result)
    {
        tempPath = new xPath(path);
        this->_isFile = IsFile(*tempPath,ec);
    }

    if(result) 
    {
        // TODO delete SetPath and SetExists from here 
        this->SetPath(path); // Set's the private path member 
        this->SetExists();
        this->_name = LeafItemFromPath(this->_path);
    }
    
    // Handle error 
    if(ec || !this->_exists || !result) 
    {
        std::cout << "xFile:"; 
        if(ec) std::cout << "\tError Code returned.  File path may not exist." << std::endl;
        else if(!this->_exists) std::cout << "\tMay not exist" << std::endl;
        else if(!result) std::cout << "\tIsFile return null" << std::endl;
        else std::cout << "\tUnknown error" << std::endl;
    }

    this->_result = result;
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

