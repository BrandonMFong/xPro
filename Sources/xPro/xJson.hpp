/**
 * @file xJson.h
 * @author Brando 
 * @brief 
 * @version 0.1
 * @date 2021-02-02
 * 
 * @copyright Copyright (c) 2021
 * 
 */

#ifndef _XJSON_
#define _XJSON_

#include <xPro/xPro.hpp>

struct BasicJson
{
    xString Name;
};

class xJson : public xFile
{
public: 
    xJson();

    xJson(xString filePath);
protected:
    xBool SetJsonDocument(xString filePath);
    nlohmann::json _jsonDocument;
    xBool _isParsed;
private:
};

#endif