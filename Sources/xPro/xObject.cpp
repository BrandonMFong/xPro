/**
 * @file xDirectory.cpp
 * 
 * @brief xDirectory class
 * 
 * @author Brando
 */

#include <xPro/xConfigReader.h>
#include <xPro/xXml.h>
#include <xPro/xFile.h>
#include <xPro/xDirectory.h>
#include <xPro/xObject.h>

xObject::xObject()
{
    this->_status = True; // Init everything to true 
};

xStatus xObject::Status()
{
    return this->_status;
}
