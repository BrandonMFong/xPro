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

#include <xPro/xConfigReader.h>
#include <xPro/xXml.h>

xXml::xXml() : xFile()
{}

xXml::xXml(xString xmlFile) : xFile(xmlFile)
{
    if(this->_exists)
    {
        pugi::xml_parse_result okayToContinue = this->_xmlDocument.load_file(xmlFile.c_str());
    }
}
