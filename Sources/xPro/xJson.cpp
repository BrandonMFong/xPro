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

#include <xPro/xAppSettings.hpp>
#include <xPro/xJson.h>

xJson::xJson() : xFile()
{
    xStatus status = this->_status;

    this->_status = status;
}

xJson::xJson(xString filePath) : xFile(filePath)
{
    xStatus status = this->_status;

    if(status)
    {
        status = this->SetJsonDocument(filePath);
    }

    this->_status = status;
}

xBool xJson::SetJsonDocument(xString filePath)
{
    xStatus status = Good;
    std::ifstream inputFile(filePath);

    inputFile >> this->_jsonDocument;
    status = this->_jsonDocument.is_null() ? Bad : Good;

    this->_isParsed = status ? True : False;

    return status;
}
