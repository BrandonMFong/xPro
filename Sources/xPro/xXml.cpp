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

#include <xPro/xXml.h>

xXml::xXml()
{}

xXml::xXml(xString filepath) : xFile(filepath)
{
    // When file is passed to the base class
    // The path is initialized and we can receive the C String via CStringpath() method 
    this->_xmlFile = new rapidxml::file<>(this->CStringPath());

    this->_xmlDocument.parse<0>(this->_xmlFile->data());
}

xXml::xXml(xString rootNodeName, xString filepath) : xFile(filepath) 
{
    // When file is passed to the base class
    // The path is initialized and we can receive the C String via CStringpath() method 
    this->_xmlFile = new rapidxml::file<>(this->CStringPath());

    this->_xmlDocument.parse<0>(this->_xmlFile->data());

    this->_rootNodeName = rootNodeName;
}

xStringArray xXml::RootChildNames()
{
    xStringArray result;
    rapidxml::xml_node<> * root, * child;
    
    root = this->_xmlDocument.first_node(this->_rootNodeName.c_str()); // Get the root node's xmlnode object

    child = root->first_node(); // init with first node of the root node's children 
    while(child)
    {
        result.push_back(child->name());
        child = child->next_sibling();
    }
    return result;
}

xString xXml::RootNodeName()
{
    return this->_rootNodeName;
}
