/**
 * @file xDatabase.h
 * @author Brando BrandonMFong.com
 * @brief Should handle all admin stuff
 * @version 0.1
 * @date 2021-01-23
 * 
 * @copyright Copyright (c) 2021
 * 
 * https://dev.mysql.com/doc/connector-cpp/8.0/en/preface.html
 * 
 */

#ifndef _XDATABASE_
#define _XDATABASE_

#include <xPro/xPro.h>

class xDatabase : public xObject
{
public:
    xDatabase();
protected:
    xString _name; /** Database name */
    xString _user; /** Database user */
    xString _server; /** Database server */
};

#endif