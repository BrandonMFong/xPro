/**
 * @file xDirectory.cpp
 * 
 * @brief xDirectory class
 * 
 * @author Brando
 * 
 * Using RapidXml lib https://linuxhint.com/parse_xml_in_c__/
 * https://linuxhint.com/parse_xml_in_c__/
 */

#include <xPro/xXml.h>

xXml::xXml()
{}

xXml::xXml(xString file) : xFile(file) 
{
    rapidxml::file<> xmlFile("/home/brandonmfong/source/repo/xPro/Config/Users/Makito.xml");
    this->_document.parse<0>(xmlFile.data());

    // Find out the root node
    xml_node<> * root = this->_document.first_node("Machine");
    std::cout << root->name() << std::endl;
    xml_node<> * child = root->first_node();
    while(child)
    {
        std::cout << "\t" << child->name() << std::endl;
        child = child->next_sibling();

        // std::cout << "\nDirectory Alias =   " << node->first_attribute("Alias")->value();
        // std::cout << std::endl;
        // node = node->next_sibling();
    }
}
