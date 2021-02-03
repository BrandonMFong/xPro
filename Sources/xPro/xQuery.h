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

/**
 * @brief a database object that handles database querying 
 * 
 */
class xQuery : public xDatabase
{
public:
    /**
     * @brief Construct a new xQuery object
     * 
     */
    xQuery();

    /**
     * @brief Construct a new xQuery object
     * 
     * @param databaseFilePath the full file path for the database 
     */
    xQuery(xString databaseFilePath);

    /**
     * @brief Executes query 
     * 
     * @param queryString Query string 
     */
    void Query(xString queryString);
protected:
};

#endif