// xPro
// g++ main.cpp -lstdc++fs -

#include <iostream>
#include <string>
#include <experimental/filesystem>

#ifdef _WIN32
#define PathSeparator '\\'
#elif __linux__ 
#define PathSeparator '/'
#elif __APPLE__
#define PathSeparator '/'
#endif

namespace fs = std::experimental::filesystem::v1;

int main(int argc, char *argv[]) 
{
    int index = 1; // we are only accepting one argument here
    std::string path; // will hold the argument 
    std::string filepath; // will hold each file path in the directory pointed to by the argument 
    char sep = PathSeparator; // defines how the file paths are separated
    int count = 1;

    // Exit program if this is met
    if (argc != 2)
    {
        std::cout << "No argument was passed" << std::endl;
        return 1; // should be less than or equal to two 
    } 

    // Since there should only be two, this is the index to get the argument I want
    path = argv[index];

    for (const auto & entry : fs::directory_iterator(path)) 
    {
        filepath = entry.path(); // apply to string 
        size_t i = filepath.rfind(sep, filepath.length()); // find the positions of the path delimiters
        
        // if no failure
        if (i != std::string::npos)  filepath = filepath.substr(i+1, filepath.length() - i);
        
        // Print out items
        std::cout << "[" << count << "] " << filepath << std::endl;

        count++;
    }

    return 0;
}