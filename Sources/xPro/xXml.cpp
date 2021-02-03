/**
 * @file xDirectory.cpp
 * 
 * @brief xDirectory class
 * 
 * @author Brando
 * @date 2021-01-23
 * 
 * Using RapidXml lib https://linuxhint.com/parse_xml_in_c__/
 * https://linuxhint.com/parse_xml_in_c__/
 * 
 * I need to initialize with the root node 
 */

#include <xPro/xAppPointer.h>
#include <xPro/xConfigReader.h>
#include <xPro/xXml.h>

xXml::xXml() : xFile()
{
    xStatus status = this->_status;

    this->_isParsed = False;

    this->_status = status;
}

xXml::xXml(xString xmlFile) : xFile(xmlFile)
{
    xStatus status = this->_status;

    if(status)
    {
        status = this->SetXmlDocument(xmlFile);
    }

    this->_status = status;
}

xBool xXml::SetXmlDocument(xString xmlDocument)
{
    pugi::xml_parse_result result;

    result = this->_xmlDocument.load_file(xmlDocument.c_str());
    this->_isParsed = result;

    return result;
}
