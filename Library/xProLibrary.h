#ifndef _XPROLIBRARY_
#define _XPROLIBRARY_

/* WINDOWS */
//cl main.cpp /std:c++latest
#if defined(_WIN32) || defined(_WIN64)
#include <iostream>
#include <string>
#include <filesystem>
#include <fstream> 
#include <istream> 
namespace fs = std::filesystem;
#define PathSeparator '\\'

/* LINUX */
#elif __linux__ 
#include <iostream>
#include <string>
#include <experimental/filesystem>
#include <sstream> 
#include <cstring>
namespace fs = std::experimental::filesystem;
#define PathSeparator '/'

/* APPLE */
#elif __APPLE__
#include <iostream>
#include <string>
#include <filesystem>
#include <sys/stat.h>
#define PathSeparator '/'
namespace fs = std::__fs::filesystem;
#endif

// Functions 
void enumItemsInDir(std::string path)
{
    std::string filename;
    int count = 1;

    // If this isn't windows, define these variables for the operations of getting the file
    #if !defined(_WIN32) || !defined(_WIN64)
    std::string filepath; // will hold each file path in the directory pointed to by the argument 
    char sep = PathSeparator; // defines how the file paths are separated
    #endif

    for (const auto & entry : fs::directory_iterator(path)) 
    {
        #if defined(_WIN32) || defined(_WIN64)
        filename = entry.path().filename().string(); // apply to string 
        #else 
        filepath = entry.path(); // apply to string 
        size_t i = filepath.rfind(sep, filepath.length()); // find the positions of the path delimiters
        
        // if no failure
        if (i != std::string::npos)  filename = filepath.substr(i+1, filepath.length() - i);
        #endif
        
        // Print out items
        std::cout << "[" << count << "] " << filename << std::endl;

        count++;
    }
}

// Does file exist
// https://stackoverflow.com/questions/12774207/fastest-way-to-check-if-a-file-exist-using-standard-c-c11-c 
bool exist(const std::string& name)
{
    bool result = true;
    struct stat buffer;

    result = (stat(name.c_str(), &buffer) == 0); // does file exist

    return result;
}

#endif