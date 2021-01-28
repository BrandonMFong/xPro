/**
 * @file xDirectory.cpp
 * 
 * @brief xDirectory class
 * 
 * @author Brando
 * @date 2021-01-23
 */

#include <xPro/xAppPointer.h>
#include <xPro/xConfigReader.h>
#include <xPro/xXml.h>
#include <xPro/xFile.h>
#include <xPro/xDirectory.h>

xDirectory::xDirectory() : xObject()
{
    this->_path = xEmptyString;
    this->_exists = False;

    this->_isInitialized = False;
}

xDirectory::xDirectory(xString path) : xObject()
{
    this->_isInitialized = True;
    xBool status = this->_status;
    xString filepath, tmp; 
    xString currdir;
    xChar cwd[PATH_MAX];
    const xPath * tempPath; // Constructing the path from a string is possible.
    std::error_code ec; // For using the non-throwing overloads of functions below.

    status = !path.empty(); // if the string is empty 

    // Test if this is a directory 
    if(status)
    {
        tempPath = new xPath(path);
        this->_isDirectory = IsDirectory(*tempPath,ec);
    }

    if(status) 
    {
        this->SetPath(path);
        this->SetExists();

        // Keep track if this path exists
        status = this->_exists;
    }

    // if this is a directory, initialize items into Items vector
    if(status && this->_isDirectory)
    {
        if(path[0] == '\\') path.erase(0,1); // For windows

        // Get Curent working directory
        getcwd(cwd,sizeof(cwd));
        currdir = cwd;

        for (const auto & entry : fs::directory_iterator(path)) 
        {
            #ifdef isWINDOWS
            tmp = entry.path().filename().string();
            #else
            tmp = entry.path();
            #endif
            filepath = currdir + dPathSeparator + tmp; 
            this->_items.push_back(filepath);
        }
    }

    // if(ec || !this->_exists || !result) std::cout << "xDirectory: This path may not be a directory" << std::endl;

    this->_status = status;
}

xBool xDirectory::Exists()
{
    return this->_exists;
}

void xDirectory::SetExists()
{
    xBool result = false; // Will assume it does not exist
    struct stat buffer;

    // will only check if path was set
    if(!this->_path.empty())
    {
        // Testing if the path exists
        result = (stat(this->_path.c_str(), &buffer) == 0); // does file exist

        // If the path does not exist, do not waste the memory 
        // TODO delete memory space 
        this->_path = result ? this->_path : xEmptyString;
    }
    else std::cout << "xDirectory: Path is empty" << std::endl;

    this->_exists = result;
}

void xDirectory::PrintItems()
{
    this->PrintItems(xNull);
}

void xDirectory::PrintItems(xString flag)
{
    xInt count = 1;
    xStringArray::iterator itr;

    if(this->_exists)
    {
        for(itr = this->_items.begin(); itr < this->_items.end(); itr++)
        {
            // Print out items
            if (xEnumerateDirectoryItems == flag) std::cout << "[" << count << "] ";
            std::cout << LeafItemFromPath(*itr) << std::endl;
            count++;
        }
    }
}

xString xDirectory::ItemByIndex(xInt index)
{
    xString result = xEmptyString;
    xInt count = 0; // zero index
    xStringArray::iterator itr;

    if(this->_exists)
    {
        for(itr = this->_items.begin(); itr < this->_items.end(); itr++)
        {
            if (index == count) result = *itr;
            count++;
        }
    }

    return result;
}

xString xDirectory::Path()
{
    return this->ToString();
}

xChar * xDirectory::ToCString()
{
    return (xChar *)this->ToString().c_str();
}

// In the previous methods, I don't think I need to check if the path starts with 
// '/' because I create the full path here
void xDirectory::SetPath(xString path)
{
    // xChar cwd[PATH_MAX];
    // xString currdir;

    // I don't think all cases are considered
    // if this matches, i am assuming path is coming from root
    // so will not proceed
    // if(path[0] == dPathSeparator)
    // {
    //     std::cout << "Here" << std::endl;
    //     // Get Curent working directory
    //     getcwd(cwd,sizeof(cwd));
    //     currdir = cwd;

    //     if(path[0] != dPathSeparator)path = '/' + path; // if doesn't start with / and is unix file separator
    //     else if (path[0] == '.') path.erase(0,1);

    //     path = currdir + path;
    // }
    this->_path = fs::canonical(path); // Remove any of the ".." or "~" in path 
}

xString xDirectory::ToString()
{
    return this->_path;
}