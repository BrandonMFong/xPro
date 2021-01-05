// xPro
// zero index

#include "xProLibrary.h"

#define ArgsLimit 5

// Flags
#define pathFlag "-path"
#define indexFlag "-index"

struct Arguments 
{
    int index;
    std::string path;
};

int main(int argc, char *argv[]) 
{
    Arguments args;
    std::stringstream strValue;
    std::vector<std::string> filepathvector;
    // std::vector<std::string>::iterator itr;
    std::string filepath = "";

    // Exit program if this is met
    if (argc != ArgsLimit)
    {
        std::cout << "Not all arguments were passed, must pass arguments with flags:" << std::endl;
        std::cout << " -path = Full/Relative path to directory" << std::endl;
        std::cout << " -index = nonzero index of the item in alphabetical order" << std::endl;
        return 1; // should be less than or equal to two 
    } 

    // extract arguments 
    for (int i = 0; i < argc; i++)
    {
        // If we find correct argument, get the one in the succeeding index 
        if(strcmp(argv[i],pathFlag) == 0) args.path = argv[i+1];
        else if (strcmp(argv[i],indexFlag) == 0) 
        {
            // convert char* to int 
            strValue << argv[i+1];
            strValue >> args.index;
        }
    }

    filepath = getFileByIndex(args.path,args.index);
    const auto & entry = fs::directory_entry(filepath);
    #ifdef isWINDOWS
    std::string filename = entry.path().filename().string();
    #else
    std::string filename = entry.path();
    #endif
    #if defined(_WIN32) || defined(_WIN64)
    filename = entry.path().filename().string(); // apply to string 
    #else 
    filepath = entry.path(); // apply to string 
    size_t i = filepath.rfind(PathSeparator, filepath.length()); // find the positions of the path delimiters
    
    // if no failure
    if (i != std::string::npos)  filename = filepath.substr(i+1, filepath.length() - i);
    #endif
    std::cout << filename << std::endl;
    
    return 0;
}