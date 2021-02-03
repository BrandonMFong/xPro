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

#include <xPro/xQuery.h>

xQuery::xQuery() : xDatabase()
{
    xStatus status = this->_status;

    this->_status = status;
}

xQuery::xQuery(xString databaseFilePath) : xDatabase(databaseFilePath)
{
    xStatus status = this->_status;

    this->_status = status;
}

void xQuery::Query(xString queryString)
{
    xInt result;
    const char* data = "Callback function called";
    char *sqlErrorMessage = 0;
    
   result = sqlite3_exec(this->_sqlDatabasePtr, queryString.c_str(), callback, (void*)data, &sqlErrorMessage);

    if(result != SQLITE_OK) 
    {
        fprintf(stderr, "SQL error: %s\n", sqlErrorMessage);
        sqlite3_free(sqlErrorMessage);
    }
}
