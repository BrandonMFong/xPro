/**
 * @file xDirectory.cpp
 * 
 * @author Brando (BrandonMFong.com)
 * @brief 
 * @date 2021-01-23
 * 
 * @copyright Copyright (c) 2021
 */

#include <xPro/xAppPointer.hpp>
#include <xPro/xConfigReader.hpp>
#include <xPro/xXml.hpp>
#include <xPro/xAppSettings.hpp>
#include <xPro/xJson.hpp>
#include <xPro/xFile.hpp>
#include <xPro/xDirectory.hpp>
#include <xPro/xQuery.hpp>
#include <xPro/xDatabase.hpp>
#include <xPro/xObject.hpp>

xObject::xObject()
{
    this->_status = True; // Init everything to true 
};

xStatus xObject::Status()
{
    return this->_status;
}

xBool xObject::Initialized()
{
    return this->_isInitialized;
}

xObject::operator xBool()
{
    return this->_status;
}
