/**
 * @file xXml.h 
 * 
 * @brief xXml class
 * 
 * @author Brando
 */

#ifndef _XXML_
#define _XXML_

#include <xPro/xPro.h>

class xXml : public xFile
{
public:
    xXml();
    xXml(xString xmlDocument);
protected:
    pugi::xml_document * _xmlDocument; /** Rapidxml file object */
private: 
};

#endif