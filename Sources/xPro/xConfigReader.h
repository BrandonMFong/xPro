/**
 * @file xConfigReader.h 
 * 
 * @brief xConfigReader class
 * 
 * @author Brando
 */

#ifndef _XCONFIGREADER_
#define _XCONFIGREADER_

#include <xPro/xPro.h>
#define xDefaultConfigRootNodeName "Machine"

class xConfigReader : public xXml
{
public:
    xConfigReader();
    xConfigReader(xString filepath);
private: 
    
};

#endif