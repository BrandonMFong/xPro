/**
 * @file xConfigReader.h 
 * 
 * @brief xConfigReader class
 * 
 * @author Brando
 * 
 * Am not using the below.  Will think about it though
 * https://github.com/veselink1/refl-cpp
 * https://medium.com/@vesko.karaganev/refl-cpp-deep-dive-86b185f68678
 */

#ifndef _XCONFIGREADER_
#define _XCONFIGREADER_

#include <xPro/xPro.h>

class xConfigReader : public xXml
{
public:
    xConfigReader();
    xConfigReader(xString filepath);
private: 
};

#endif