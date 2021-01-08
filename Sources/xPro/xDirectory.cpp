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
    std::string filepath, tmp; 
    std::string currdir;
    char cwd[PATH_MAX];

    this->path = path; 

    // for the case of Windows
    // I am not sure if this will affect any file system directories in UNIX 
    if(this->path[0] == '\\') this->path.erase(0,1); 

    // Testing if the path exists
    result = (stat(this->path.c_str(), &buffer) == 0); // does file exist
    this->exists = result;

    // initialize items into Items vector
    if(this->exists)
    {
        if(path[0] == '\\') path.erase(0,1); // For windows

        getcwd(cwd,sizeof(cwd));

        currdir = cwd;

        for (const auto & entry : fs::directory_iterator(path)) 
        {
            #ifdef isWINDOWS
            tmp = entry.path().filename().string();
            #else
            tmp = entry.path();
            #endif
            filepath = currdir + PathSeparator + tmp; 
            this->items.push_back(filepath);
        }
    }
}

xBool xDirectory::Exists()
{
    return this->exists;
}

void xDirectory::PrintItems()
{
    this->PrintItems(xNull);
}

void xDirectory::PrintItems(xString flag)
{
    int count = 1;
    xStringArray::iterator itr;

    if(this->exists)
    {
        if(path[0] == '\\') path.erase(0,1); 
        
        for(itr = this->items.begin(); itr < this->items.end(); itr++)
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
    std::string result = "";
    int count = 0; // zero index
    xStringArray::iterator itr;

    if(this->exists)
    {
        // remove leading \\ for the case of windows and Get the items from the directory 
        if(path[0] == '\\') path.erase(0,1); 
        
        for(itr = this->items.begin(); itr < this->items.end(); itr++)
        {
            if (index == count) result = *itr;
            count++;
        }
    }

    return result;
}
