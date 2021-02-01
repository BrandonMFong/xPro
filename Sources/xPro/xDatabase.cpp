/**
 * @file xDatabase.cpp
 * @author Brando BrandonMFong.com
 * @brief 
 * @version 0.1
 * @date 2021-01-23
 * 
 * @copyright Copyright (c) 2021
 * 
 */

#include <xPro/xQuery.h>
#include <xPro/xDatabase.h>

xInt stdCallBack(void *NotUsed, int argc, char **argv, char **azColName)
{
    std::cout << "Something bad happened" << std::endl;
    return 0;
}

xDatabase::xDatabase() : xObject()
{
    xInt result;
    xBool okayToContinue = True;
    xStatus status = this->_status;
    xFile * databasePath;
    xAppPointer * appPointer = new xAppPointer();
    xConfigReader * configReader = new xConfigReader(*appPointer);

    if((configReader->Machine.Database.Path.empty() == True) && (okayToContinue))
    {
        this->_name = xEmptyString;
        this->_user = xEmptyString;
        this->_server = xEmptyString;

        okayToContinue = False;
    }
    else
    {
        // Not used
        this->_user = xEmptyString;
        this->_server = xEmptyString;

        databasePath = new xFile(configReader->Machine.Database.Path); // Put file path into xFile object 

        // okayToContinue = (databasePath) ? True : False;
    }

    if(databasePath)
    {
        this->_name = databasePath->Name(); // Get base name 

        result = sqlite3_open(databasePath->ToCString(), &this->_sqlDatabasePtr);

        this->_connected = (result) ? False : True;
        status = this->_connected ? Bad : Good;
    }
    
    this->_status = status;
}

xBool xDatabase::Connected()
{
    return this->_connected;
}

void xDatabase::Close()
{
    sqlite3_close(this->_sqlDatabasePtr);
}
