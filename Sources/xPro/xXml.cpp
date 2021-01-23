/**
 * @file xDirectory.cpp
 * 
 * @brief xDirectory class
 * 
 * @author Brando
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
{}

xXml::xXml(xString xmlFile) : xFile(xmlFile)
{
    xStatus status = this->_status;
    // pugi::xml_parse_result result;

    if(status)
    {
        // result = this->_xmlDocument.load_file(xmlFile.c_str());
        // this->_isParsed = result;
        // status = this->_isParsed;
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
