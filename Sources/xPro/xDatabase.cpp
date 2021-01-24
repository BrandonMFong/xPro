/**
 * @file xDatabase.cpp
 * @author Brando BrandonMFong.com
 * @brief 
 * @version 0.1
 * @date 2021-01-23
 * 
 * @copyright Copyright (c) 2021
 * 
 */

#include <xPro/xDatabase.h>

xDatabase::xDatabase() : xObject()
{
    xStatus status = this->_status;

    this->_name = xEmptyString;
    this->_user = xEmptyString;
    this->_server = xEmptyString;

    this->_status = status;
}