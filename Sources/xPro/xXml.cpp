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
    std::ifstream theFile (this->_path);
    std::vector<char> buffer((std::istreambuf_iterator<char>(theFile)), std::istreambuf_iterator<char>());
    buffer.push_back('\0');
   
    // Parse the buffer
    this->_document.parse<0>(&buffer[0]);
   
    // Find out the root node
    this->root_node = this->_document.first_node("Directories");
   
    // Iterate over the student nodes
    for (xml_node<> * student_node = root_node->first_node("Directory"); student_node; student_node = student_node->next_sibling())
    {
        std::cout << "\nDirectory Alias =   " << student_node->first_attribute("Alias")->value();
        std::cout << std::endl;

        std::cout << "\nDirectory Value =   " << student_node->value();
        std::cout << std::endl;
           
            // Interate over the Student Names
        // for(xml_node<> * student_name_node = student_node->first_node("Name"); student_name_node; student_name_node = student_name_node->next_sibling())
        // {
        //     std::cout << "Student Name =   " << student_name_node->value();
        //     std::cout << std::endl;
        // }
        // std::cout << std::endl;
    }
}
