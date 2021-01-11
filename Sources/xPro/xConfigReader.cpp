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
// Can use type identifiers. I want to catch when I read a struct type
xConfigReader::xConfigReader(xString filepath) : xXml(xDefaultConfigRootNodeName,filepath)
{
    // std::cout << typeid(std::string).name() << std::endl;
    // std::cout << typeid(this->Machine.name).name() << std::endl;

    // Going to write into name 
    for_each(refl::reflect(this->Machine).members, [&](auto member)
    {
        xString name = get_display_name(member);// using result to test variable name 
        

        std::cout << "Var:" << name  << ". Is a struct = ";

        constexpr auto isStruct = refl::descriptor::get_attribute<IsStruct>(member);
        std::cout << isStruct.flag << std::endl;
        // if(result == "name") 
        // {
        //     // Write 
        //     constexpr auto writer = get_writer(member);
        //     writer(this->Machine, "new name");
        // }
    });
}
