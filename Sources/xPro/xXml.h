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

/**
 * @brief Basic xml parameters
 * 
 */
struct BasicXml
{
    xString Name;
    xString InnerXml;
};

/**
 * @brief Class for Xml that uses pugixml library 
 * 
 */
class xXml : public xFile
{
public:

    /**
     * @brief Construct a new xXml object
     * 
     */
    xXml();

    /**
     * @brief Construct a new xXml object
     * 
     * @param xmlDocument File path to the xml document
     */
    xXml(xString xmlDocument);

    xBool SetXmlDocument(xString xmlDocument);

protected:
    pugi::xml_document _xmlDocument; /** pugixml file object */
    xBool _isParsed; /** Successfully parsed */
private: 
};

#endif