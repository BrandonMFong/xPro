/**
 * @file xAppSettings.cpp
 * @author Brando
 * @brief 
 * @version 0.1
 * @date 2021-02-02
 * 
 * @copyright Copyright (c) 2021
 * 
 */

#include <xPro/xAppSettings.hpp>

xAppSettings::xAppSettings() : xJson()
{
    xStatus status = this->_status;
    xFile * filePath;
    xAppPointer * appPointer = new xAppPointer(); // Was thinking about making this global but I don't this it can see it

    // We are going to hard code the path to the app.json since it will 
    // not move by design
    filePath = new xFile(appPointer->Machine.GitRepoDir.InnerXml + dAppSettingsFilePath); 

    if(filePath->Exists())
    {
        this->_name = filePath->Name();
    }

    this->_status = status;
}
