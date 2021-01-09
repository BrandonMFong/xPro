/**
 * @file xTypes.h 
 * 
 * @brief Defining some constants I would like to use across my tools 
 * 
 * @author Brando
 */

#ifndef _XPROTYPES_
#define _XPROTYPES_

#include <xPro/xPro.h>

#define True true /* Boolean True */
#define False false /* Boolean False */
#define xNull nullptr /* Null Pointer */
#define xEmptyString ""
#define IsxFile(path,ic) fs::is_regular_file(path,ec)
typedef int xInt; /** xPro-Type Integer */
typedef std::string xString; /** xPro-Type String */
typedef bool xBool; /** xPro-Type Boolean */
typedef std::vector<xString> xStringArray; /** xPro-Type String Array */
typedef char xChar; /** xPro-Type String */
typedef std::stringstream xStringStream; /** xPro-Type String Stream */
typedef std::ifstream xInputFile; /** xPro-Type ifstream */
typedef fs::path xPath; /** xPro-Type File System Path */

#endif