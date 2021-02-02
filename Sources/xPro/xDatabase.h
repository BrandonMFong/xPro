/**
 * @file xDatabase.h
 * @author Brando BrandonMFong.com
 * @brief Should handle all admin stuff
 * @version 0.1
 * @date 2021-01-23
 * 
 * @copyright Copyright (c) 2021
 * 
 * https://mariadb.com/kb/en/mariadb-connector-c/
 * 
 * Going to use sqlite since it seems easier to integrate
 * https://www.tutorialspoint.com/sqlite/sqlite_c_cpp.htm
 * 
 */

#ifndef _XDATABASE_
#define _XDATABASE_

#include <xPro/xPro.h>

class xDatabase : public xObject
{
public:
    xDatabase();
    xDatabase(xString pathToDatabaseFile);

    /**
     * @brief Getter for _connected variable
     * 
     * @return xBool = True if the file is successfully connected 
     */
    xBool Connected();

    /**
     * @brief Closes database connection 
     * 
     */
    void Close();

    xString Name();
    xString Path();
protected:
    xBool _connected; /** If database has been connected to */
    xString _name; /** Database name */
    xString _path; /** Database file path */
    // xString _user; /** Database user */
    // xString _server; /** Database server */
    sqlite3 * _sqlDatabasePtr; /** Sqlite3 database object */
};

int callback(void *data, int argc, char **argv, char **azColName);

#endif