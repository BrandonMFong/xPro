/**
 * @file xXml.h 
 * 
 * @brief xXml class
 * 
 * @author Brando
 */

#ifndef _XXML_
#define _XXML_

#include <xPro/extern/rapidxml.hpp>
#include <xPro/extern/rapidxml_utils.hpp>
#include <xPro/xPro.h>
// #define RAPIDXML_NO_EXCEPTIONS // read rapidxml

class xXml : public xFile
{
public:
    xXml();
    xXml(xString file);
    xXml(xString rootNodeName, xString file);
    xStringArray xXml::RootNodeChildren();
private: 
    rapidxml::file<> * _xmlFile; /** Rapidxml file object */
    rapidxml::xml_document<> _xmlDocument; /** xmldocument that holds parse xml data */ 
    xString _rootNodeName; /** String name of the root node of xml file */
};

#endif