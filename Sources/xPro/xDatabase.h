/**
 * @file xDatabase.h
 * @author Brando BrandonMFong.com
 * @brief 
 * @version 0.1
 * @date 2021-01-23
 * 
 * @copyright Copyright (c) 2021
 * 
 */

#ifndef _XSQL_
#define _XSQL_

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