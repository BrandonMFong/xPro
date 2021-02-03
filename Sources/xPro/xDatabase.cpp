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

xInt callback(void *data, int argc, char **argv, char **azColName)
{
   int i;
   fprintf(stderr, "%s: ", (const char*)data);
   
    for(i = 0; i<argc; i++)
    {
        printf("%s = %s\n", azColName[i], argv[i] ? argv[i] : "NULL");
    }
   
   printf("\n");
   return 0;
}

xDatabase::xDatabase() : xObject()
{
    xStatus status = this->_status;
    // xFile * databasePath = new xFile();
    xConfigReader * configReader = new xConfigReader(*(new xAppPointer()));

    // if(status)
    // {
    //     status = !configReader->Machine.Database.Path.empty();
    // }

    // if(status)
    // {
    //     databasePath = new xFile(configReader->Machine.Database.Path); // Put file path into xFile object 
    //     status = databasePath->Exists();
    // }

    // if(!status)
    // {
    //     this->_name = xEmptyString;
    //     this->_path = xEmptyString;
    //     this->_connected = False;
    // }
    // else
    // {
    //     this->_name = databasePath->Name(); // Get base name 
    //     this->_path = databasePath->Path(); // Get the full file path 

    //     this->_connected = (sqlite3_open(databasePath->Path().c_str(), &this->_sqlDatabasePtr) == 1) ? False : True;

    //     status = this->_connected ? Bad : Good;
    // }

    if(status)
    {
        status = this->ConnectToDatabase(configReader->Machine.Database.Path);
    }
    
    this->_status = status;
}

xDatabase::xDatabase(xString pathToDatabaseFile) : xObject()
{
    // xInt result;
    xStatus status = this->_status; 
    // xFile * databasePath = new xFile();

    // if(status)
    // {
    //     status = !pathToDatabaseFile.empty();
    // }

    // if(status)
    // {
    //     databasePath = new xFile(pathToDatabaseFile); // Put file path into xFile object 
    //     status = databasePath->Exists();
    // }

    // if(!status)
    // {
    //     this->_name = xEmptyString;
    //     this->_path = xEmptyString;
    //     this->_connected = False;
    // }
    // else
    // {
    //     this->_name = databasePath->Name(); // Get base name 
    //     this->_path = databasePath->Path(); // Get the full file path 

    //     this->_connected = (sqlite3_open(databasePath->Path().c_str(), &this->_sqlDatabasePtr) == 1) ? False : True;

    //     status = this->_connected ? Bad : Good;
    // }

    if(status)
    {
        status = this->ConnectToDatabase(pathToDatabaseFile);
    }

    this->_status = status;
}

xStatus xDatabase::ConnectToDatabase(xString filePath)
{
    xStatus status = !filePath.empty();
    xFile * databasePath = new xFile();

    if(status)
    {
        databasePath = new xFile(filePath); // Put file path into xFile object 
        status = databasePath->Exists();
    }

    if(!status)
    {
        this->_name = xEmptyString;
        this->_path = xEmptyString;
        this->_connected = False;
    }
    else
    {
        this->_name = databasePath->Name(); // Get base name 
        this->_path = databasePath->Path(); // Get the full file path 

        this->_connected = (sqlite3_open(databasePath->Path().c_str(), &this->_sqlDatabasePtr) == 1) ? False : True;

        status = this->_connected ? Bad : Good;
    }

    return status;
}

xBool xDatabase::Connected()
{
    return this->_connected;
}

void xDatabase::Close()
{
    sqlite3_close(this->_sqlDatabasePtr);
}

xString xDatabase::Name()
{
    return this->_name;
}

xString xDatabase::Path()
{
    return this->_path;
}
