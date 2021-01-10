/** 
 * @file xPro.h
 * 
 * @author Brando
 * 
 * Notes:
 * I want to improve my coding 
 * To do this I want to follow coding standards
 * Will consider derofim's: https://gist.github.com/derofim/df604f2bf65a506223464e3ffd96a78a 
*/

#ifndef _XPRO_
#define _XPRO_

/** OPERATING SYSTEM SPECIFIC **/
/* WINDOWS */
#if defined(_WIN32) || defined(_WIN64)
#include <iostream>
#include <string>
#include <filesystem>
#include <fstream> 
#include <istream> 
#include <direct.h>
#include <sstream> 
namespace fs = std::filesystem;
#define PathSeparator '\\'
#define getcwd _getcwd
#define PATH_MAX _MAX_PATH
#define isWINDOWS

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
#include <fstream>
namespace fs = std::experimental::filesystem;
#define PathSeparator '/'

/* APPLE */
#elif __APPLE__
#include <iostream>
#include <string>
#include <filesystem>
#include <sys/stat.h>
#include <vector>
#include <unistd.h>
#include <sstream> 
namespace fs = std::__fs::filesystem;
#define PathSeparator '/'
#endif

#include <xPro/extern/refl.hpp>
#include <xPro/extern/rapidxml.hpp>
#include <xPro/extern/rapidxml_utils.hpp>
struct serializable : refl::attr::usage::field, refl::attr::usage::function{};

/** APP SPECIFIC START **/

/*** xTypes ***/
// #include <xPro/xTypes.h>
#define True true /* Boolean True */
#define False false /* Boolean False */
#define xNull nullptr /* Null Pointer */
#define xEmptyString "" /** Empty String */
#define IsFile(path,ec) fs::is_regular_file(path,ec)
#define IsDirectory(path,ec) fs::is_directory(path,ec)
typedef int xInt; /** xPro-Type Integer */
typedef std::string xString; /** xPro-Type String */
typedef bool xBool; /** xPro-Type Boolean */
typedef std::vector<xString> xStringArray; /** xPro-Type String Array */
typedef char xChar; /** xPro-Type String */
typedef std::stringstream xStringStream; /** xPro-Type String Stream */
typedef std::ifstream xInputFile; /** xPro-Type ifstream */
typedef fs::path xPath; /** xPro-Type File System Path */

/*** xClasses ***/
// Order in descending order of inheritance

/**** File System Objects ****/
#include <xPro/xDirectory.h>
#include <xPro/xFile.h>
#include <xPro/xXml.h>
#include <xPro/xConfigReader.h>

/** Get's leaf item from a given filesystem path. This function is assuming the path already exists. 
 * Reference: https://stackoverflow.com/questions/22818925/c-error-undefined-symbols-for-architecture-x86-64
 * 
 * @param path the filesyste path (can be a file or a directory)
 * 
 * @return xString
 */
xString LeafItemFromPath(xString path);

/** Converts a character type to an integer type
 * @param character the char variable
 * 
 * @return xInt
 */
xInt Char2xInt(xString character);

// Based off of serialization: https://github.com/veselink1/refl-cpp/blob/master/examples/example-serialization.cpp
template <typename T>
/**
 * @brief Get the Members a struct object
 * 
 * @param value The struct
 */
void GetMembers(T&& value)
{
    // std::vector<T&&> result;
    // iterate over the members of T
    for_each(refl::reflect(value).members, [&](auto member)
    {
        // is_readable checks if the member is a non-const field
        // or a 0-arg const-qualified function marked with property attribute
        // if constexpr (is_readable(member) && refl::descriptor::has_attribute<serializable>(member))
        if constexpr (is_readable(member))
        {
            // get_display_name prefers the friendly_name of the property over the function name
            std::cout << get_display_name(member) << std::endl;
            std::cout << get_simple_name(refl::reflect(value)) << std::endl;
        }
    });
}

/** APP SPECIFIC END **/

#endif