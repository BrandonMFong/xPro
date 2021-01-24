/**
 * @file xConfigReader.h 
 * 
 * @brief xConfigReader class
 * @author Brando (BrandonMFong.com)
 * @brief 
 * @date 2021-01-23
 * 
 * @copyright Copyright (c) 2021
 * 
 * Am not using the below.  Will think about it though
 * https://github.com/veselink1/refl-cpp
 * https://medium.com/@vesko.karaganev/refl-cpp-deep-dive-86b185f68678
 */

#ifndef _XAPPPOINTER_
#define _XAPPPOINTER_

#include <xPro/xPro.h>

/**
 * @brief The C++ xml structure for xPro User config files.  Please read xPro.xsd for more details
 * 
 */
struct xRootAppPointer : BasicXml
{
    xString MachineName;

    struct GitRepoDir : BasicXml
    {} GitRepoDir;

    struct ConfigFile : BasicXml
    {} ConfigFile;
};

class xAppPointer : public xXml
{
public:
    /**
     * @brief This will parse the Profile.xml by default
     * 
     */
    xAppPointer();

    xString ToString();

    operator std::string();

    /**
     * @brief Carries the xPro App Pointer structure 
     * 
     */
    xRootAppPointer Machine;
private: 
};

#endif