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
    this->path = xEmptyString;
    this->exists = False;
}

xDirectory::xDirectory(xString path)
{
    xString filepath, tmp; 
    xString currdir;
    xChar cwd[PATH_MAX];

    this->SetPath(path);

    // // Testing if the path exists
    // result = (stat(this->path.c_str(), &buffer) == 0); // does file exist
    // this->exists = result;
    this->SetExists();

    // initialize items into Items vector
    if(this->exists)
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
            filepath = currdir + PathSeparator + tmp; 
            this->items.push_back(filepath);
        }
    }
}

xBool xDirectory::Exists()
{
    return this->exists;
}

void xDirectory::SetExists()
{
    xBool result = false; // Will assume it does not exist
    struct stat buffer;

    // will only check if path was set
    if(!this->path.empty())
    {
        // Testing if the path exists
        result = (stat(this->path.c_str(), &buffer) == 0); // does file exist

        // If the path does not exist, do not waste the memory 
        // TODO delete memory space 
        this->path = result ? this->path : xEmptyString;
    }

    this->exists = result;
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

xString xDirectory::Path()
{
    return this->path;
}

void xDirectory::SetPath(xString path)
{
    xChar cwd[PATH_MAX];
    xString currdir;

    // I don't think all cases are considered
    // if this matches, i am assuming path is coming from root
    // so will not proceed
    if(std::to_string(path[0]).compare(std::to_string(PathSeparator)))
    {
        // Get Curent working directory
        getcwd(cwd,sizeof(cwd));
        currdir = cwd;

        if(path[0] != PathSeparator)path = '/' + path; // if doesn't start with / and is unix file separator
        else if (path[0] == '.') path.erase(0,1);

        path = currdir + path;
    }

    this->path = path; // concat base dir with relative path
}