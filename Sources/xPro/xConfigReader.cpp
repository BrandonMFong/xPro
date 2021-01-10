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
    GetMembers(this->Machine.directories);

}
