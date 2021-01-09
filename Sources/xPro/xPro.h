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

/** APP SPECIFIC **/
#include <xPro/xTypes.h>
#include <xPro/xDirectory.h>
#include <xPro/xFile.h>

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

#endif