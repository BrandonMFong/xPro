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
#include <sys/stat.h>
#include <vector>
#include <unistd.h>
#include <stdio.h>
#include <limits.h>
namespace fs = std::experimental::filesystem;
#define PathSeparator '/'

/* APPLE */
#elif __APPLE__
#include <iostream>
#include <string>
#include <filesystem>
#include <sys/stat.h>
namespace fs = std::__fs::filesystem;
#define PathSeparator '/'
#endif

// Prototypes
void enumItemsInDir(std::string path);
bool exist(const std::string& name);
void getFileByIndex(std::string path, int index);
std::string char2str(char arr[],int size);

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

// Select item in directory by index
void getFileByIndex(std::string path, int index)
{
    std::string filename;

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
        std::cout << filename << std::endl;
    }
}

std::vector<std::string> getDirItems(std::string path)
{
    std::vector<std::string> filepathvectors;
    std::string filepath, tmp; 
    char cwd[PATH_MAX];

    getcwd(cwd,sizeof(cwd));
    std::string currdir = char2str(cwd,sizeof(cwd));

    for (const auto & entry : fs::directory_iterator(path)) 
    {
        tmp = entry.path();
        filepath = currdir + tmp; 
        filepathvectors.push_back(filepath);
    }

    return filepathvectors;
}

std::string char2str(char arr[],int size)
{
    std::string str = "";
    for (int i = 0; i < size; i++)
    {
        str = str + arr[i];
    }
    return str;
}

#endif