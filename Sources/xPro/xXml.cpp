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

xXml::xXml()
{}

xXml::xXml(xString xmlFile) : xFile(xmlFile)
{
    std::cout << xmlFile.c_str() << std::endl;
    pugi::xml_parse_result okayToContinue = this->_xmlDocument->load_file(xmlFile.c_str());
}
