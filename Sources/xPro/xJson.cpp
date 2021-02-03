/**
 * @file xJson.cpp
 * @author Brando
 * @brief 
 * @version 0.1
 * @date 2021-02-02
 * 
 * @copyright Copyright (c) 2021
 * 
 */

#include <xPro/xJson.h>

xJson::xJson() : xFile()
{
    xStatus status = this->_status;

    this->_status = status;
}

xJson::xJson(xString filePath) : xFile(filePath)
{
    
}
