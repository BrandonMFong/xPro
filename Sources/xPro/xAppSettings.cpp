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

// How do I get the path to the xPro config path? 
// I need to read the AppPointer in order to know the repo path 
xAppSettings::xAppSettings() : xJson()
{
    xStatus status = this->_status;
    xFile * filePath;
    xAppPointer * appPointer = new xAppPointer(); // Was thinking about making this global but I don't this it can see it

    // We are going to hard code the path to the app.json since it will 
    // not move by design
    filePath = new xFile(appPointer->Machine.GitRepoDir.InnerXml + dAppSettingsFilePath); 
    status = filePath->Exists() ? Good : Bad;

    // Get file name and path 
    if(status)
    {
        this->_name = filePath->Name();
        this->_path = filePath->Path();
    }

    status = this->SetJsonDocument(filePath->Path());

    if(status)
    {
        // TODO load the struct
    }

    this->_status = status;
}
