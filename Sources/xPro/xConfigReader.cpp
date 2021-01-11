/**
 * @file xConfigReader.cpp
 * 
 * @brief xConfigReader class
 * 
 * @author Brando
 * 
 */

#include <xPro/xConfigReader.h>

xConfigReader::xConfigReader()
{}

// Goal:
// I want to use a struct to tell the code what to find
// This algorithm should be in xXml class where the constructor should accept a structure variable by ref
// and returns the filled in variables
xConfigReader::xConfigReader(xString filepath) : xXml(xDefaultConfigRootNodeName,filepath)
{
    std::cout << typeid(std::string).name() << std::endl;
    std::cout << typeid(this->Machine.name).name() << std::endl;
    // std::cout << type_name<decltype(this->Machine.name)>() << std::endl;
    // Going to write into name 
    // for_each(refl::reflect(this->Machine).members, [&](auto member){
    //     xString result = get_display_name(member);
    //     if(result == "name") 
    //     {
    //         std::cout << "found name" << std::endl;
    //         std::cout << this->Machine.name << std::endl;
    //         constexpr auto writer = get_writer(member);
    //         // TODO use writer
    //         writer(this->Machine, "new name");
    //         std::cout << this->Machine.name << std::endl;
    //     }
    // });
}
