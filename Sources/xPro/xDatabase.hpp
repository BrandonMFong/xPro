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

#include <xPro/xPro.hpp>

/**
 * @brief Sqlite3 database object 
 * 
 */
class xDatabase : public xObject
{
public:
    /**
     * @brief Construct a new xDatabase object
     * 
     */
    xDatabase();

    /**
     * @brief Construct a new xDatabase object
     * 
     * @param pathToDatabaseFile accepts any string to database  
     */
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

    /**
     * @brief Getter for _name
     * 
     * @return xString Name of database file
     */
    xString Name();

    /**
     * @brief Getter for _path 
     * 
     * @return xString Full file path for the database file 
     */
    xString Path();
protected:
    /**
     * @brief Connects to a database with a provided string
     * 
     * @param filePath Path to sqlite3 database file 
     * @return xStatus 
     */
    xStatus ConnectToDatabase(xString filePath);

    xBool _connected; /** If database has been connected to */
    xString _name; /** Database name */
    xString _path; /** Database file path */
    sqlite3 * _sqlDatabasePtr; /** Sqlite3 database object */
};

/**
 * @brief Call back function for query results 
 * 
 * @param data 
 * @param argc 
 * @param argv 
 * @param azColName 
 * @return int 
 */
int callback(void *data, int argc, char **argv, char **azColName);

#endif