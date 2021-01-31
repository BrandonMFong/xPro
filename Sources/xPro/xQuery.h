/**
 * @file xQuery.h
 * @author Brando BrandonMFong.com
 * @brief 
 * @version 0.1
 * @date 2021-01-23
 * 
 * @copyright Copyright (c) 2021
 * 
 */

#ifndef _XQUERY_
#define _XQUERY_

#include <xPro/xPro.h>

class xQuery : public xDatabase
{
public:
    xQuery();

    /**
     * @brief Executes query 
     * 
     * @param queryString Query string 
     */
    void Query(xString queryString);
protected:
};

#endif