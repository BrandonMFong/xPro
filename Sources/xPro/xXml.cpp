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

xXml::xXml(xString filepath) : xFile(filepath)
{
    xBool result = this->_exists;

    if(result) this->_LoadVariables(); 
}

xXml::xXml(xString rootNodeName, xString filepath) : xFile(filepath) 
{
    xBool result = this->_exists;
    this->_rootNodeName = rootNodeName;

    if(result) this->_LoadVariables(); 
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

void xXml::_LoadVariables()
{
    // When file is passed to the base class
    // The path is initialized and we can receive the C String via CStringpath() method 
    this->_xmlFile = new rapidxml::file<>(this->CStringPath());

    this->_xmlDocument.parse<0>(this->_xmlFile->data());
}
