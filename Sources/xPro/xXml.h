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
#include <xPro/xPro.h>
// #define RAPIDXML_NO_EXCEPTIONS // read rapidxml

// using namespace std;
using namespace rapidxml;

class xXml : public xFile
{
public:
    xXml();
    xXml(xString file);
private: 
    xml_document<> _document;
    // xInputFile * _xmlFile;
    xml_node<> * root_node = NULL;      
};

#endif