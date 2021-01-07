// xPro
// Engineer: Brando

#include <xPro/xPro.h>

void EnumItemsInDir(std::string path)
{
    int count = 1;
    std::vector<std::string> paths;
    std::vector<std::string>::iterator itr;

    if(IsExist(path))
    {
        if(path[0] == '\\') path.erase(0,1); 
        
        paths = GetDirItems(path);
    
        for(itr = paths.begin(); itr < paths.end(); itr++)
        {
            // Print out items
            std::cout << "[" << count << "] " << GetLeafItem(*itr) << std::endl;
            count++;
        }
    }
}

// Does file exist
// https://stackoverflow.com/questions/12774207/fastest-way-to-check-if-a-file-exist-using-standard-c-c11-c 
bool IsExist(std::string file)
{
    bool result = false; // Will assume it does not exist
    struct stat buffer;

    // for the case of Windows
    // I am not sure if this will affect any file system directories in UNIX 
    if(file[0] == '\\') file.erase(0,1); 

    result = (stat(file.c_str(), &buffer) == 0); // does file exist

    return result;
}

// Select item in directory by index
// 0 index
std::string GetFileByIndex(std::string path, int index)
{
    std::string result = "";
    int count = 0; // zero index
    std::vector<std::string> filepathvector;
    std::vector<std::string>::iterator itr;

    if(IsExist(path))
    {
        // remove leading \\ for the case of windows and Get the items from the directory 
        if(path[0] == '\\') path.erase(0,1); 
        filepathvector = GetDirItems(path);
        
        for(itr = filepathvector.begin(); itr < filepathvector.end(); itr++)
        {
            if (index == count) result = *itr;
            count++;
        }
    }

    return result;
}

std::vector<std::string> GetDirItems(std::string path)
{
    std::vector<std::string> filepathvectors;
    std::string filepath, tmp; 
    std::string currdir;
    char cwd[PATH_MAX];

    if(IsExist(path))
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
            filepathvectors.push_back(filepath);
        }
    }

    return filepathvectors;
}

// This function is assuming the path already exists
std::string GetLeafItem(std::string path)
{
    std::string leaf = "";
    size_t i;
    std::string filepath; // apply to string 
    if(path[0] == '\\') path.erase(0,1); 

    const auto & entry = fs::directory_entry(path);
    #ifdef isWINDOWS
    leaf = entry.path().filename().string();
    #else
    leaf = entry.path();
    #endif
    #ifdef isWINDOWS
    leaf = entry.path().filename().string(); // apply to string 
    #else 
    filepath = entry.path(); // apply to string 
    i = filepath.rfind(PathSeparator, filepath.length()); // find the positions of the path delimiters
    
    // if no failure
    if (i != std::string::npos)  leaf = filepath.substr(i+1, filepath.length() - i);
    #endif
    return leaf;
}
