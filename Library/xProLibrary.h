#ifndef _XPROLIBRARY_
#define _XPROLIBRARY_

// Libs
#include <iostream>
#include <string>

/* WINDOWS */
//cl main.cpp /std:c++latest
#if defined(_WIN32) || defined(_WIN64)
#include <filesystem>
#include <fstream> 
#include <istream> 
namespace fs = std::filesystem;
#define PathSeparator '\\'

/* LINUX */
#elif __linux__ 
#include <experimental/filesystem>
namespace fs = std::experimental::filesystem;
#define PathSeparator '/'

/* APPLE */
#elif __APPLE__
#include <filesystem>
#define PathSeparator '/'
namespace fs = std::__fs::filesystem;
#endif

#endif