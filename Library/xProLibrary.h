#ifdef _XPROLIBRARY_
#define _XPROLIBRARY_


#include 

#ifdef _WIN32
#include <experimental/filesystem>
#define PathSeparator '\\'
#elif __linux__ 
#include <experimental/filesystem>
#define PathSeparator '/'
#elif __APPLE__
#include <filesystem>
#define PathSeparator '/'
#endif

void myFunction()
{
    for (const auto & entry : fs::directory_iterator(path)) 
    {
        filepath = entry.path(); // apply to string 
        size_t i = filepath.rfind(sep, filepath.length()); // find the positions of the path delimiters
        
        // if no failure
        if (i != std::string::npos)  filename = filepath.substr(i+1, filepath.length() - i);
        
        // Print out items
        std::cout << "[" << count << "] " << filename << std::endl;

        count++;
    }
}

#endif