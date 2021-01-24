/** 
 * @file xPro.h
 * 
 * @author Brando
 * @date 2021-01-23
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
// #include <xPro/extern/pugixml.hpp>
namespace fs = std::filesystem;
#define dPathSeparator '\\'
#define getcwd _getcwd
#define PATH_MAX _MAX_PATH
#define isWINDOWS
#define dAppPointerFile "Profile.xml"

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
// #include <xPro/extern/pugixml.hpp>
namespace fs = std::experimental::filesystem;
#define dPathSeparator '/'
#define dAppPointerFile ".profile.xml"

/* APPLE */
#elif __APPLE__
#include <iostream>
#include <string>
#include <filesystem>
#include <sys/stat.h>
#include <vector>
#include <unistd.h>
#include <sstream> 
#include <fstream>
// #include <xPro/extern/macos/pugixml.hpp>
namespace fs = std::__fs::filesystem;
#define dPathSeparator '/'
#define dAppPointerFile ".profile.xml"
#endif

// Using Pugixml as an xml parser 
#include <xPro/extern/pugixml.hpp>

/** APP SPECIFIC START **/

/*** xTypes ***/
#define True true /** Boolean True */
#define False false /** Boolean False */
// #define Good true /** Status = Good */
// #define Bad false /** Status = Bad */ 
#define xNull nullptr /** Null Pointer */
#define xEmptyString "" /** Empty String */
#define IsFile(path,ec) fs::is_regular_file(path,ec)
#define IsDirectory(path,ec) fs::is_directory(path,ec)
#define dUserConfigDirectoryPath "/Config/Users" /** User Config Path */
#define Return(value) return (xInt)(!value)
typedef int xInt; /** xPro-Type Integer */
typedef uint xUInt; /** xPro-Type Unsigned Integer */
typedef std::string xString; /** xPro-Type String */
typedef bool xBool; /** xPro-Type Boolean */
typedef bool xStatus; /** xPro-Type Status */
typedef std::vector<xString> xStringArray; /** xPro-Type String Array */
typedef char xChar; /** xPro-Type String */
typedef std::stringstream xStringStream; /** xPro-Type String Stream */
typedef std::ifstream xInputFile; /** xPro-Type ifstream */
typedef fs::path xPath; /** xPro-Type File System Path */

/*** xConstants ***/
const std::string kHomeDirectoryPath = getenv("HOME");
const std::string kHomeProfilePath = kHomeDirectoryPath + "/" + dAppPointerFile;

/*** xEnums ***/
enum xEnums
{
    Good = true,
    Bad = false

    // TODO add True and False
};

// Order in descending order of inheritance
/*** xClasses ***/
#include <xPro/xObject.h>

/**** File System Objects ****/
#include <xPro/xDirectory.h>
#include <xPro/xFile.h>
#include <xPro/xXml.h>
#include <xPro/xConfigReader.h>
#include <xPro/xAppPointer.h>

/**** Database Objects ****/
#include <xPro/xDatabase.h>
#include <xPro/xQuery.h>

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

/** APP SPECIFIC END **/

#endif