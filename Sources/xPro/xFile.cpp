/**
 * @file xFile.cpp
 * 
 * @brief xFile class
 * 
 * @author Brando
 * @date 2021-01-23
 */

#include <xPro/xAppPointer.h>
#include <xPro/xConfigReader.h>
#include <xPro/xXml.h>
#include <xPro/xFile.h>

xFile::xFile() : xDirectory()
{
    this->_name = xEmptyString;
}

xFile::xFile(xString path) : xDirectory(path)
{
    xStatus status = this->_status;
    const xPath * tempPath; // Constructing the path from a string is possible.
    std::error_code ec; // For using the non-throwing overloads of functions below.

    // Test if this is file
    if(status)
    {
        tempPath = new xPath(path);
        this->_isFile = IsFile(*tempPath,ec);
    }

    if(status) 
    {
        // TODO delete SetPath and SetExists from here 
        // this->SetPath(path); // Set's the private path member 
        // this->SetExists();
        this->_name = LeafItemFromPath(this->_path);

        status = this->_exists;
    }
    
    // Handle error 
    if(this->_isFile && (ec || !this->_exists || !status))
    {
        std::cout << "xFile:"; 
        if(ec) std::cout << "\tError Code returned.  File path may not exist." << std::endl;
        else if(!this->_exists) std::cout << "\tMay not exist" << std::endl;
        else if(!status) std::cout << "\tIsFile return null" << std::endl;
        else std::cout << "\tUnknown error" << std::endl;
    }

    this->_status = status;
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

